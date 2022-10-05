drop table HAUL_nbs;
drop view HAUL_nbs;
create view HAUL_nbs as
SELECT  
  to_number(to_char(a.start_time,'yyyy')) year,
  'NBS' survey,
  a.CRUISEJOIN,
  a.hauljoin,
  a.vessel,
  a.cruise,
  a.HAUL,
  a.HAUL_TYPE,
  a.PERFORMANCE,
  START_TIME,
  DURATION,
  DISTANCE_FISHED,
  NET_WIDTH,
  NET_MEASURED,
  NET_HEIGHT,
  a.STRATUM,
  START_LATITUDE,
  END_LATITUDE,
  START_LONGITUDE,
  END_LONGITUDE,
  STATIONID,
  GEAR_DEPTH,
  BOTTOM_DEPTH,
  BOTTOM_TYPE,
  SURFACE_TEMPERATURE,
  GEAR_TEMPERATURE,
  WIRE_LENGTH,
  GEAR,
  ACCESSORIES,
  SUBSAMPLE,
  AUDITJOIN
FROM 
	RACEBASE.HAUL A
JOIN 
	RACE_DATA.V_CRUISES B
ON 
	(B.CRUISEJOIN = A.CRUISEJOIN)
WHERE 
	A.PERFORMANCE >= 0
	AND A.HAUL_TYPE = 3
	AND A.STATIONID IS NOT NULL
	AND B.SURVEY_DEFINITION_ID = 143
	AND B.YEAR in (2010,2017,2019,2021,2022);

drop view surveys_nbs;
create view surveys_nbs as
select distinct c.CRUISEJOIN,
'NBS' survey,
c.VESSEL,
c.CRUISE,
c.START_DATE,
c.END_DATE,
c.MIN_LATITUDE,
c.MAX_LATITUDE,
c.MIN_LONGITUDE,
c.MAX_LONGITUDE,
c.AGENCY_NAME,
c.SURVEY_NAME,
to_number(to_char(start_date,'yyyy')) year
from racebase.cruise c, HAUL_nbs h
where c.cruisejoin=h.cruisejoin
and c.vessel=h.vessel
and c.cruise=h.cruise
and to_number(to_char(start_date,'yyyy'))=h.year
order by year;


drop view CATCH_nbs;
create view CATCH_nbs as
select YEAR,
'NBS' survey,
c.CRUISEJOIN,
c.HAULJOIN,
CATCHJOIN,
c.VESSEL,
c.CRUISE,
c.HAUL,
SPECIES_CODE,
WEIGHT,
NUMBER_FISH,
SUBSAMPLE_CODE,
VOUCHER,
c.AUDITJOIN
from racebase.catch c, HAUL_nbs h
where h.hauljoin=c.hauljoin;

drop view LENGTH_nbs;
create view LENGTH_nbs as
select 'NBS' survey,
C.CRUISEJOIN,
C.HAULJOIN,
C.CATCHJOIN,
C.VESSEL,
C.CRUISE,
C.HAUL,
SPECIES_CODE,
LENGTH,
FREQUENCY,
SEX,
SAMPLE_TYPE,
LENGTH_TYPE,
C.AUDITJOIN
from racebase.LENGTH c, HAUL_nbs h
where h.hauljoin=c.hauljoin;

drop view SPECIMEN_nbs;
create view SPECIMEN_nbs as
select 'NBS' survey,
C.CRUISEJOIN,
C.HAULJOIN,
C.VESSEL,
C.CRUISE,
C.HAUL,
SPECIES_CODE,
SPECIMENID,
BIOSTRATUM,
LENGTH,
SEX,
WEIGHT,
AGE,
MATURITY,
MATURITY_TABLE,
GONAD_WT,
C.AUDITJOIN,
SPECIMEN_SUBSAMPLE_METHOD,
SPECIMEN_SAMPLE_TYPE,
AGE_DETERMINATION_METHOD
from racebase.SPECIMEN c, HAUL_nbs h
where h.hauljoin=c.hauljoin;

drop view nbs_CPUE;
create view nbs_CPUE as
select       'NBS' survey,
             a.year,
             b.catchjoin,
             a.hauljoin,
             a.vessel,
             a.cruise,
             a.haul,
             a.stratum,
             a.stationid,
             a.distance_fished,
             a.net_width,
             a.species_code,
             nvl(b.weight,0) weight,
             nvl(b.number_fish,0) number_fish,
             ((a.distance_fished*a.net_width)/1000) effort,
             nvl(b.weight,0)/((a.distance_fished*a.net_width)/1000) wgtcpue,
             nvl(b.number_fish,0)/((a.distance_fished*a.net_width)/1000) numcpue
from       (select distinct c.year,
                            c.hauljoin,
                            c.vessel,
                            c.cruise,
                            c.haul,
                            c.stratum,
                            c.stationid,
                            c.distance_fished,
                            c.net_width,
                            a.species_code
          from CATCH_nbs a, HAUL_nbs c, racebase.species b
                       where a.year=c.year
                            and a.species_code=b.species_code
             ) a, 
             CATCH_nbs b
where     a.hauljoin = b.hauljoin(+) and
          a.species_code=b.species_code(+);


drop view CPUE_nbs_POS;
create view CPUE_nbs_POS as
select
	a.year,
  a.vessel,
  a.haul,
  a.species_code,
  c.species_name,
  c.common_name,
	b.start_latitude latitude,
	b.start_longitude longitude,
	b.surface_temperature sst_c,
	b.gear_temperature btemp_c,
	b.bottom_depth depth_m,
	a.wgtcpue,
	a.numcpue
from 
  NBS_CPUE a, 
  HAUL_NBS b,
  racebase.species c
where
	a.hauljoin=b.hauljoin
  and a.species_code=c.species_code
  and a.year in (2010, 2017, 2019, 2021, 2022)
order by
  a.year,
  a.vessel,
  a.haul,
  a.species_code;

REM THE FOLLOWING INCLUDES BIOMASS FOR ALL SPECIES IDENTIFIED DURING THE SURVEYS
Drop view nbs_biomass;
create view nbs_biomass as
select  'NBS' survey,
        year,
        species_code,
        species_name,
        common_name,
        STRATUM,
        HAULCOUNT haul_count,
        CATCOUNT catch_count,
        NUMCOUNT number_count,
        LENCOUNT length_count,
        MEANWGTCPUE*100 MEAN_WGT_CPUE,
        VARMNWGTCPUE*10000 VAR_WGT_CPUE,
        MEANNUMCPUE*100 MEAN_NUM_CPUE,
        VARMNNUMCPUE*10000 VAR_NUM_CPUE,
        biomass STRATUM_BIOMASS,
        VARBIO BIOMASS_VAR,
        LOWERB MIN_BIOMASS,
        UPPERB MAX_BIOMASS,
        DEGREEFwgt degreef_biomass,
        POPULATION STRATUM_POP,
        VARPOP POP_VAR,
        LOWERP MIN_POP,
        UPPERP MAX_POP,
        DEGREEFNUM degreef_pop
from haehnr.biomass_nbs_safe
where species_code not in(400,10111,10260,10129,79000,78010); 


REM NO GROUPED TABLES ARE NECESSARY FOR THE NBS

drop view nbs_sizecomp;
create view nbs_sizecomp as
select  'NBS' survey,
        year,
        species_code,
        species_name,
        common_name,
        stratum,
        LENGTH,
        MALES,
        FEMALES,
        UNSEXED,
        TOTAL
from haehnr.sizecomp_nbs_stratum 
where 
  species_code not in(400,10111,10260,10129,79000,78010)
order by year,
        species_code,
        stratum,
        LENGTH;

REM BE AWARE HERE THAT THERE IS A SEX=9 (COMBINED SEXES) IN ADDITION TO SEX = 1,2,&3
drop view nbs_agecomp;
create view nbs_agecomp as
select 
  'NBS' survey,
  year,
  species_code,
  STRATUM,
  sex,
  age,
  agepop,
  meanlen MEAN_LENGTH,
  sdev STANDARD_DEVIATION
from haehnr.agecomp_nbs_stratum;