/* 
  * Eric C. Grasby, MSIQ
  * A version of the Haversine "great circle" distance calculation that can be run in a PROC SQL step
*/

%LET MEAN_RADIUS_OF_EARTH = 3959;  /* use 3959 as the mean radius of the Earth in miles */
%LET WORK_LIB = WORK;
%LET SRC_TABLE = LAT_LON_DATA;

PROC SQL;
  SELECT 
         SRC_LATITUDE
        ,SRC_LONGITUDE
        ,DEST_LATITUDE
        ,DEST_LONGITUDE
        , &MEAN_RADIUS_OF_EARTH. *                   
            ACOS(
                COS(RADIANS(SRC_LATITUDE)) * COS(RADIANS(DEST_LATITUDE)) *
                COS(RADIANS(SRC_LONGITUDE)) - RADIANS(DEST_LONGITUDE)) + 
                SIN(RADIANS(SRC_LATITUDE)) * SIN(RADIANS(DEST_LATITUDE))
          ) AS HAVERSINE_DISTANCE_IN_MILES
  FROM &WORK_LIB..&SRC_TABLE.;
QUIT;
