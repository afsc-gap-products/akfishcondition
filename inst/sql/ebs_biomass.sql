/* Query to retrieve stratum biomass for combined EBS continental shelf strata 10-62 from tables prepared by Rebecca Haehn (rebecca.haehn@noaa.gov), AFSC/RACE/GAP. Does not include northwest strata 82 and 90. 
Prepared by: Sean Rohan (sean.rohan@noaa.gov), AFSC/RACE/GAP
Query updated: September 22, 2021 
--- 

README by Rebecca Haehn

Here are biomass/population tables for various species.  These tables have been computed 
without fishing-power corrections for all years.  

 The HAULCOUNT will indicate the total hauls within each stratum or subarea. If a stratum 
is not listed for a particular year, then no hauls/stations were conducted in that stratum during that year.


The outputs are run separately for "standard"   "plusnw" strata.

Standard strata=10,20,31,32,41,42,43,50,61,62.
Plusnw strata=10,20,31,32,41,42,43,50,61,62,82,90.
The standard area includes years 1982-present.
The plusnw area included years 1987-present. Years 1982-86 are NOT included for the plusnw output because essentially no stations 
 within strata 82 & 90 (subarea 8 & 9) were sampled during those years.


************************************
Strata are also grouped as follows:

Subarea
1 (stratum 10)
2 (stratum 20)
3 (strata 31, 32)
4 (strata 41, 42, 43)
5 (stratum 50)
6 (strata (61, 62)
8 (stratum 82)
9 (stratum 90)

Depth zones
100 (<50 m)
200 (50-100 m)
300 (100-200 m)

All strata combined
999
************************************

The tables have the following columns:

SPECIES_CODE
SPECIES_NAME
COMMON_NAME
YEAR
STRATUM
MEANWGTCPUE (kg/hectare)
VARMNWGTCPUE (Variance of the mean CPUE by weight)
BIOMASS (metric tons)
VARBIO
LOWERB (metric tons)
UPPERB (metric tons)
DEGREEFWGT
MEANNUMCPUE
VARMNNUMCPUE (Variance of the mean CPUE by number)
POPULATION (numbers)
VARPOP 
LOWERP (numbers)
UPPERP (numbers)
DEGREEFNUM
HAULCOUNT (no. hauls conducted in stratum)
CATCOUNT (no. hauls with catch weights)
NUMCOUNT (no. hauls with catch numbers)
LENCOUNT  (no. hauls with lengths) 
*/
SELECT HAEHNR.BIOMASS_EBS_PLUSNW.SPECIES_CODE, 
HAEHNR.BIOMASS_EBS_PLUSNW.COMMON_NAME, 
HAEHNR.BIOMASS_EBS_PLUSNW.YEAR, 
HAEHNR.BIOMASS_EBS_PLUSNW.STRATUM, 
HAEHNR.BIOMASS_EBS_PLUSNW.BIOMASS, 
HAEHNR.BIOMASS_EBS_PLUSNW.VARBIO, 
HAEHNR.BIOMASS_EBS_PLUSNW.LOWERB, 
HAEHNR.BIOMASS_EBS_PLUSNW.UPPERB
FROM HAEHNR.BIOMASS_EBS_PLUSNW
WHERE (((HAEHNR.BIOMASS_EBS_PLUSNW.SPECIES_CODE) in (21740, 21741, 21720, 10110, 10210, 10130, 10261, 10285))) AND
STRATUM between 1 AND 6