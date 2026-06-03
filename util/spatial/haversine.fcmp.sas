LIBNAME SPAT_UTIL '/path/to/shared/func_lib';
OPTIONS CMPLIB=SPAT_UTIL.FUNCTIONS;


PROC FCMP OUTLIB=SPAT_UTIL.FUNCTIONS.FUNC;
  /****************************************************************************************************************
   * FUNCTION: getHaversineDistance
   * PURPOSE:  Computes a Haversine distance (in miles) between 2 input LAT/LON coordinates. All input coordinates
   *           MUST be expressed in decimal degrees
   *    - LAT_SRC : source point latitude (Numeric)
   *    - LON_SRC : source point longitude (Numeric)
   *    - LAT_DEST : destination point latitude (Numeric)
   *    - LON_DEST : destination point longitude (Numeric)
   * RETURNS: Shortest point to point distance on Earth's surface ("as the crow flies"), expressed in miles
  *****************************************************************************************************************/
  FUNCTION getHaversineDistance(LAT_SRC, LON_SRC, LAT_DEST, LON_DEST);
    PI = CONSTANT('PI');
    DIVISOR_180 = 180;
    MEAN_EARTH_RADIUS = 3959;

    /* convert all input coordinates to radians */
    RAD_LATSRC = (LAT_SRC * PI) / DIVISOR_180;
    RAD_LONSRC = (LON_SRC * PI) / DIVISOR_180;
    RAD_LATDEST = (LAT_DEST * PI) / DIVISOR_180;
    RAD_LONDEST = (LON_DEST * PI) / DIVISOR_180;

    /* determine delta values from the converted radian points */
    DELTA_PHI = (RAD_LATDEST - RAD_LATSRC);
    DELTA_LAMBDA = (RAD_LONDEST - RAD_LONSRC);

    /* compute the Haversine distance according to the Haversine formula, expressed as:
		    A = SIN(DELTA_PHI / 2)^2 + COS(RAD_LATSRC) * COS(RAD_LATDEST) * SIN(DELTA_LAMBDA / 2)^2
		    B = 2 * ATAN2(SQRT(A), SQRT(1-A));
		    C = MEAN_EARTH_RADIUS * B
    */

       A = SIN(DELTA_PHI / 2)**2 + COS(RAD_LATSRC) * COS(RAD_LATDEST) * SIN(DELTA_LAMBDA / 2)**2;
       B = 2 * ATAN(SQRT(A), SQRT(1-A));
       D = MEAN_EARTH_RADIUS * B; 

       /* return numeric result to caller */ 
       RETURN(D);
  ENDSUB;
QUIT;
