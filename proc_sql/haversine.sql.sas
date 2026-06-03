/* 
  * Eric C. Grasby, MSIQ
  * A version of the Haversine "great circle" distance calculation that can be run in a PROC SQL step
*/

PROC SQL;
  SELECT 
        SRC_LATITUDE
        ,SRC_LONGITUDE
        ,DEST_LATITUDE
        ,DEST_LONGITUDE
        , 3959 *                   /* use 3959 as the mean radius of the Earth in miles */
            ACOS(
                COS(RADIANS(SRC_LATITUDE)) * COS(RADIANS(DEST_LATITUDE)) *
                COS(RADIANS(SRC_LONGITUDE)) - RADIANS(DEST_LONGITUDE)) + 
                SIN(RADIANS(SRC_LATITUDE)) * SIN(RADIANS(DEST_LATITUDE))
          ) AS HAVERSINE_DISTANCE_IN_MILES
  FROM WORK.LAT_LON_DATA;
QUIT;
