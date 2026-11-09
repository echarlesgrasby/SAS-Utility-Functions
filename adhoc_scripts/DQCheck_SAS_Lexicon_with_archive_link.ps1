<#
    DQCheck_SAS_Lexicon_with_archive_link.ps1
    ERIC C. GRASBY, MSIQ
    NOV 03, 2026

    PURPOSE:
        The purpose of this script is to create a simple txt file of the proceedings of a particular SAS
        conference from SASLEXICON.org. This file is then used as a workspace for validating metadata
        from conference papers (and is used to track any corrections). The corrections are then opened as issues
        in the bugfix repository for SASLEXICON <https://github.com/yabwon/sas.lex.icon.bugs.fixing>

    NOTES:
        - Requires no input parameters upon invocation. 
        - User is prompted for output directory and source URL after the script is invoked.
        - Output is a .txt file (PROCEEDINGS.txt) in a folder of the user's choosing.
#>


function Get-Directory(){
<#
    Get the directory that the output file will be stored in
#>

    $Shell = New-Object -ComObject Shell.Application
    # Parameters: Window Handle (0), Title, Options (1 = Only File System Folders), Root Path
    # If you want to choose a different drive, update the Drive Letter (last parameter in the below "BrowseForFolder" function call)
    $Folder = $Shell.BrowseForFolder(0, "Choose an output folder for the markdown file:", 1, "D:\")

    if ($Folder) {
        $SelectedFolder = $Folder.Self.Path
        Write-Host "Output Directory: $SelectedFolder" -ForegroundColor Green
        return "${SelectedFolder}"
    } else {
        Write-Host "Folder selection cancelled." -ForegroundColor Yellow
    }
}


function Get-SourceUrl(){
<#
    Get the Source URL for SAS LEXICON:

    Example: https://saslexicon.org/SUGI_SGF/1977/SUGI_SGF_1977.html
#>

    while ($true){
        $TargetUrl = Read-Host "Enter the SAS Lexicon URL (must begin with 'https://saslexicon.org/')"
        if ($TargetUrl.StartsWith("https://saslexicon.org/")){
            return $TargetUrl
        }else{
            Write-Error "Invalid Url. Please enter a valid URL.";
        }
    }
    
}


function main($outputFolder, $targetUrl) {
    <#
        Run main program
    #>

    # Fetch slugs for <CONFERENCE NAME> and <YEAR>

    $conf_name = $TargetUrl.Split("/")[3]
    $yr = $TargetUrl.Split("/")[4]

    $resp = Invoke-WebRequest -Uri "${TargetUrl}"

    $RowNum = 0;
    $ColNum = 0;
    $mdOutput = "";

    $resp.ParsedHtml.body.getElementsByTagName("TR") | Select-Object -Skip 1 | %{ 
        $_.childNodes
        $RowNum+=1;
        $ColNum=0;
        } | %{
                    if($ColNum -eq 1){
                        $mtch = [regex]::Matches(($_.IHTMLElement_outerHtml | Select-Object -First 1), '<TD><A\s+href="(.*\.pdf)"\s+rel=.*</TD>')
                        $mdOutput += "# $($_.innerText)";
                        $mdOutput += "`n";
                        $mdOutput += "${conf_name}/${yr}/$($mtch.Groups[1].Value)"
                        $mdOutput += "`n";
                    }
                    elseif($ColNum -eq 2){
                         $mdOutput += "AUTHOR: $($_.innerText)";
                         $mdOutput += "`n";
                    }
                    elseif ($ColNum -eq 3){
                        try{
                            if($_.innerText.trim() -eq ""){
                                $mdOutput += "NO ABSTRACT FOUND!!`n";
                            }else{
                                $mdOutput += "$($_.innerText)`n";
                            }
                        }catch{
                                $mdOutput += "NO ABSTRACT FOUND!!`n";
                        }
                    }
                    elseif($ColNum -eq 5){
                        $linkNodes = $_.getElementsByTagName("A") | Select-Object -First 1;
                        $srcLink = $linkNodes.IHTMLAnchorElement_href;
                        $mdOutput += "# [SOURCE LINK](${srcLink})"
                        $mdOutput += "`n`n";
                    }
                    else{
                        $mdOutput +=  ""
                    }
                    $ColNum+=1;
        }

        $mdoutput | Out-File -Encoding UTF8 "${outputFolder}\PROCEEDINGS.txt";
}

# Prompt the user for output directory and targetUrl
$outputFolder = Get-Directory
$targetUrl = Get-SourceUrl

# If the user cancelled before initiating a good target url, do not run main()
if ($TargetUrl.startsWith("https://saslexicon.org/")){
    main $outputFolder $targetUrl
}