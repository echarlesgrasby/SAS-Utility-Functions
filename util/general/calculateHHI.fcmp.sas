/* *****************************************************************************************************************************************
  Author: Eric C. Grasby
  PROC FCMP utility for calculating the Herfindahl-Hirschmann Index (HHI) from a dataaset of firms and their associated "market share

  -------------
  This procedure is written in suport of the author's dissertation work. @See here: https://github.com/echarlesgrasby/dissertation
  *******************************************************************************************************************************************
*/

LIBNAME GEN_UTIL '/path/to/shared/func_lib';
OPTIONS CMPLIB=GEN_UTIL.FUNCTIONS;

PROC FCMP OUTLIB=GEN_UTIL.FUNCTIONS.FUNC;
    /**********************************************************************************************

    ***********************************************************************************************/
    FUNCITON calculateHHI(arr[*]);
    ENDSUB;
RUN;
