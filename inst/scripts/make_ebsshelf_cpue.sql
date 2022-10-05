REM  MAKE SURE ALL THE PLUSNW AND STANDARD AREA BIOMASS, SIZECOMP, AND AGECOMP SCRIPTS
REM   HAVE BEEN RUN ON HAEHNR FIRST, SO THE APPROPRIATE TABLES ARE CREATED AND AVAILABLE
REM   ON YOUR USERCODE.

set heading off
select 'drop table '||table_name||';' 
from user_tables 
where table_name
like '%';

drop table HAUL_ebsshelf;
drop view HAUL_ebsshelf;
create view HAUL_ebsshelf as
SELECT  
  to_number(to_char(a.start_time,'yyyy')) year,
  'EBS_SHELF' survey,
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
  AND A.STRATUM IN(10,20,31,32,41,42,43,50,61,62,82,90)
  AND B.SURVEY_DEFINITION_ID = 98;

drop table surveys_ebsshelf;
create view surveys_ebsshelf as
select distinct c.CRUISEJOIN,
'EBS_SHELF' survey,
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
from racebase.cruise c, HAUL_ebsshelf h
where c.cruisejoin=h.cruisejoin
and c.vessel=h.vessel
and c.cruise=h.cruise
and to_number(to_char(start_date,'yyyy'))=h.year
order by year;


drop table CATCH_ebsshelf;
drop view CATCH_ebsshelf;
create view CATCH_ebsshelf as
select YEAR,
'EBS_SHELF' survey,
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
from racebase.catch c, HAUL_ebsshelf h
where h.hauljoin=c.hauljoin;

drop table LENGTH_ebsshelf;
create view LENGTH_ebsshelf as
select 'EBS_SHELF' survey,
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
from racebase.LENGTH c, HAUL_ebsshelf h
where h.hauljoin=c.hauljoin;

drop table SPECIMEN_ebsshelf;
drop view SPECIMEN_ebsshelf;
create view SPECIMEN_ebsshelf as
select 'EBS_SHELF' survey,
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
from racebase.SPECIMEN c, HAUL_ebsshelf h
where h.hauljoin=c.hauljoin;



drop table EBSSHELF_CPUE;
drop view EBSSHELF_CPUE;
create view EBSSHELF_CPUE as
select       'EBS_SHELF' survey,
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
          from CATCH_ebsshelf a, HAUL_ebsshelf c, racebase.species b
                       where a.year=c.year
                            and a.species_code=b.species_code
             ) a, 
             CATCH_ebsshelf b
where     a.hauljoin = b.hauljoin(+) and
          a.species_code=b.species_code(+);


drop view CPUE_EBSSHELF_POS;
create view CPUE_EBSSHELF_POS as
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
  EBSSHELF_CPUE a, 
  HAUL_ebsshelf b,
  racebase.species c
where
	a.hauljoin=b.hauljoin
  and a.species_code=c.species_code
order by
	a.year,
  a.vessel,
  a.haul,
  a.species_code;
  
  
drop view species_codes;
create view species_codes as
select * from racebase.species;

drop view ebsshelf_biomass_plusnw;
create view ebsshelf_biomass_plusnw as
select  'EBS_SHELF' survey,
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
from haehnr.biomass_ebs_plusnw
where species_code not in(400,10111,10260,10129,79000,78010); 

drop view ebsshelf_biomass_plusnw_groupd;
create view ebsshelf_biomass_plusnw_groupd as
select  'EBS_SHELF' survey,
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
from haehnr.biomass_ebs_plusnw_grouped;



drop view ebsshelf_biomass_standard;
create view ebsshelf_biomass_standard as
select  'EBS_SHELF' survey,
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
from haehnr.biomass_ebs_standard
where species_code not in(400,10111,10260,10129,79000,78010);

drop view ebsshelf_biomass_stand_grouped;
create viw ebsshelf_biomass_stand_grouped as
select  'EBS_SHELF' survey,
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
from haehnr.biomass_ebs_standard_grouped;


drop view ebsshelf_sizecomp_plusnw;
create view ebsshelf_sizecomp_plusnw as
select  'EBS_SHELF' survey,
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
from haehnr.sizecomp_ebs_plusnw_stratum 
where 
  species_code not in(400,10111,10260,10129,79000,78010)
  and stratum<>999999
union
select  'EBS_SHELF' survey,
        year,
        species_code,
        species_name,
        common_name,
        999 STRATUM,
        LENGTH,
        MALES,
        FEMALES,
        UNSEXED,
        TOTAL
from haehnr.sizecomp_ebs_plusnw_stratum
where species_code not in(400,10111,10260,10129,79000,78010)
and stratum=999999
order by year,
        species_code,
        stratum,
        LENGTH;


drop view ebsshelf_sizecomp_plusnw_grp;
create view ebsshelf_sizecomp_plusnw_grp as
select  'EBS_SHELF' survey,
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
from haehnr.sizecomp_ebs_plusnw_stratum_grouped
where stratum<>999999
union
select  'EBS_SHELF' survey,
        year,
        species_code,
        species_name,
        common_name,
        999 STRATUM,
        LENGTH,
        MALES,
        FEMALES,
        UNSEXED,
        TOTAL
from haehnr.sizecomp_ebs_plusnw_stratum_grouped
where stratum=999999
order by year,
        species_code,
        stratum,
        LENGTH;

drop view ebsshelf_sizecomp_standard;
create view ebsshelf_sizecomp_standard as
select  'EBS_SHELF' survey,
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
from haehnr.sizecomp_ebs_standard_stratum
where stratum<>999999 and species_code not in(400,10111,10260,10129,79000,78010)
union
select  'EBS_SHELF' survey,
        year,
        species_code,
        species_name,
        common_name,
        999 STRATUM,
        LENGTH,
        MALES,
        FEMALES,
        UNSEXED,
        TOTAL
from haehnr.sizecomp_ebs_standard_stratum
where stratum=999999 and species_code not in(400,10111,10260,10129,79000,78010)
order by year,
        species_code,
        stratum,
        LENGTH;


drop view ebsshelf_sizecomp_stand_grp;
create view ebsshelf_sizecomp_stand_grp as
select  'EBS_SHELF' survey,
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
from haehnr.sizecomp_ebs_standard_stratum_grouped
where stratum<>999999
union
select  'EBS_SHELF' survey,
        year,
        species_code,
        species_name,
        common_name,
        999 STRATUM,
        LENGTH,
        MALES,
        FEMALES,
        UNSEXED,
        TOTAL
from haehnr.sizecomp_ebs_standard_stratum_grouped
where stratum=999999
order by year,
        species_code,
        stratum,
        LENGTH;
        
drop view ebsshelf_agecmp_plusnw;
create viw ebsshelf_agecmp_plusnw as
select 
  species_code,
  year,'EBS_SHELF' survey,
  STRATUM,
  sex,
  age,
  agepop,
  meanlen,sdev 
from haehnr.agecomp_ebs_plusnw_stratum;

drop table ebsshelf_agecomp_plusnw;
create table ebsshelf_agecomp_plusnw as
select 
'EBS_SHELF' survey,
year SURVEY_YEAR, 
SPECIES_CODE,
STRATUM,
sex,
age,
agepop,
meanlen MEAN_LENGTH,
SDEV STANDARD_DEVIATION
from haehnr.agecomp_ebs_plusnw_stratum
where stratum<>9999999
union
select 
'EBS_SHELF' survey,
year SURVEY_YEAR, 
SPECIES_CODE,
999 STRATUM,
sex,
age,
agepop,
meanlen MEAN_LENGTH,
SDEV STANDARD_DEVIATION
from haehnr.agecomp_ebs_plusnw_stratum
where stratum=9999999
order by SPECIES_CODE,SURVEY_YEAR,stratum,sex,age;

drop view ebsshelf_agecomp_standard;
create view ebsshelf_agecomp_standard as
select 
'EBS_SHELF' survey,
year SURVEY_YEAR, 
SPECIES_CODE,
STRATUM,
sex,
age,
agepop,
meanlen MEAN_LENGTH,
SDEV STANDARD_DEVIATION
from haehnr.agecomp_ebs_standard_stratum
where stratum<>9999999
union
select 
'EBS_SHELF' survey,
year SURVEY_YEAR, 
SPECIES_CODE,
999 STRATUM,
sex,
age,
agepop,
meanlen MEAN_LENGTH,
SDEV STANDARD_DEVIATION
from haehnr.agecomp_ebs_standard_stratum
where stratum=9999999
order by SPECIES_CODE,SURVEY_YEAR,stratum,sex,age;