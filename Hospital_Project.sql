

--create schema Bronze
--create schema silver
--create schema Gold

--select COUNT(*) as total_count,
--sum(case when id is null then 1 else 0 end) as id_nulls,
--sum(case when START is null then 1 else 0 end) as start_nulls,
--sum(case when PATIENT is null then 1 else 0 end) as patient_nulls,
--sum(case when ORGANIZATION is null then 1 else 0 end) as organization_nulls,
--sum(case when PAYER is null then 1 else 0 end) as payer_nulls,
--sum(case when ENCOUNTERCLASS is null then 1 else 0 end) as encounter_class_nulls,
--sum(case when CODE is null then 1 else 0 end) as code_nulls
--from encounters
--Encounters Table
select COUNT(*) as id_count from silver.encounters where Id is null 
select COUNT(*) as start_count from silver.encounters where START is null 
select COUNT(*) as stop_count from silver.encounters where STOP is null
select COUNT(*) as patient_count from silver.encounters where PATIENT is null 
select COUNT(*) as organization_count from silver.encounters where ORGANIZATION is null 
select COUNT(*) as payer_count from silver.encounters where PAYER is null
select COUNT(*) as encounterclass_count from silver.encounters where ENCOUNTERCLASS is null 
select COUNT(*) as code_count from silver.encounters where CODE is null 
select COUNT(*) as description_count from silver.encounters where DESCRIPTION is null 
select COUNT(*) as base_encounter_count from silver.encounters where BASE_ENCOUNTER_COST is null 
select COUNT(*) as total_claim_count from silver.encounters where TOTAL_CLAIM_COST is null 
select COUNT(*) as payer_coverage_count from silver.encounters where PAYER_COVERAGE is null 
select COUNT(*) as reasoncode_count from silver.encounters where REASONCODE is null 
select COUNT(*) as reasondescription_count from silver.encounters where REASONDESCRIPTION is null 


--organizations
select * from silver.organizations
select COUNT(*) as Id_count from silver.organizations where Id is null
select COUNT(*) as Name_count from silver.organizations where NAME is null
select COUNT(*) as Address_count from silver.organizations where ADDRESS is null
select COUNT(*) as city_count from silver.organizations where CITY is null
select COUNT(*) as state_count from silver.organizations where STATE is null
select COUNT(*) as zip_count from silver.organizations where ZIP is null
select COUNT(*) as Lat_count from silver.organizations where LAT is null
select COUNT(*) as Lon_count from silver.organizations where LON is null

--patients
select * from silver.patients
select COUNT(*) as Id_count from silver.patients where Id is null
select COUNT(*) as Birthdate_count from silver.patients where BIRTHDATE is null
select COUNT(*) as deathdate_count from silver.patients where DEATHDATE is null
select COUNT(*) as prefix_count from silver.patients where PREFIX is null
select COUNT(*) as first_count from silver.patients where FIRST is null
select COUNT(*) as last_count from silver.patients where LAST is null
select COUNT(*) as suffix_count from silver.patients where SUFFIX is null
select COUNT(*) as maiden_count from silver.patients where MAIDEN is null
select COUNT(*) as marital_count from silver.patients where MARITAL is null
select COUNT(*) as race_count from silver.patients where RACE is null
select COUNT(*) as ethnicity_count from silver.patients where ETHNICITY is null
select COUNT(*) as gender_count from silver.patients where GENDER is null
select COUNT(*) as birthplace_count from silver.patients where BIRTHPLACE is null
select COUNT(*) as address_count from silver.patients where ADDRESS is null
select COUNT(*) as city_count from silver.patients where CITY is null
select COUNT(*) as state_count from silver.patients where STATE is null
select COUNT(*) as county_count from silver.patients where COUNTY is null
select COUNT(*) as zip_count from silver.patients where ZIP is null
select COUNT(*) as lat_count from silver.patients where LAT is null
select COUNT(*) as lon_count from silver.patients where LON is null

--payers
select * from silver.payers
select COUNT(*) as Id_count from silver.payers where Id is null
select COUNT(*) as Name_count from silver.payers where NAME is null
select COUNT(*) as Adress_count from silver.payers where ADDRESS is null
select COUNT(*) as City_count from silver.payers where CITY is null
select COUNT(*) as State_headquartered_count from silver.payers where STATE_HEADQUARTERED is null
select COUNT(*) as zip_count from silver.payers where ZIP is null
select COUNT(*) as phone_count from silver.payers where PHONE is null

--procedures
select * from silver.procedures
select COUNT(*) as start_count from silver.procedures where START is null
select COUNT(*) as stop_count from silver.procedures where STOP is null
select COUNT(*) as patient_count from silver.procedures where PATIENT is null
select COUNT(*) as encounter_count from silver.procedures where ENCOUNTER is null
select COUNT(*) as code_count from silver.procedures where CODE is null 
select COUNT(*) as description_count from silver.procedures where DESCRIPTION is null
select COUNT(*) as base_cost_count from silver.procedures where BASE_COST is null
select COUNT(*) as reasoncode_count from silver.procedures where REASONCODE is null
select COUNT(*) as reasondescription_count from silver.procedures where REASONDESCRIPTION is null


--Transformations
--encounters
update silver.encounters set REASONCODE=0 where REASONCODE is null
update silver.encounters set REASONDESCRIPTION='Not Defined' where REASONDESCRIPTION is null
alter table silver.encounters alter column START date
alter table silver.encounters alter column STOP date

--patients
update silver.patients set SUFFIX='Not Defined' where SUFFIX is null
update silver.patients set MAIDEN='Not Defined' where MAIDEN is null
update silver.patients set MARITAL='Others' where MARITAL is null
update silver.patients set ZIP=0 where ZIP is null


--payers
update silver.payers set ADDRESS='Not Defined' where ADDRESS is null
update silver.payers set CITY='Not Defined' where CITY is null
update silver.payers set STATE_HEADQUARTERED='Not Defined' where STATE_HEADQUARTERED is null
update silver.payers set ZIP=0 where ZIP is null
update silver.payers set PHONE='0-000-000' where PHONE is null


--procedures
update silver.procedures set REASONCODE=0 where REASONCODE is null
update silver.procedures set REASONDESCRIPTION='Not Defined' where REASONDESCRIPTION is null
alter table silver.procedures alter column START date
alter table silver.procedures alter column STOP date

select * from silver.encounters
select * from silver.organizations
select * from silver.patients
select * from silver.payers
select * from silver.procedures

--Gold Layer

create table Gold.Fact_Procedures(
Fact_Procedure_key int identity(1,1) primary key,
[START] date,
[STOP] date,
Base_Cost int,
Encounter nvarchar(50),
Procedure_key int,
foreign key (Procedure_key) references Gold.Dim_Procedures(Procedure_key)
)
drop table gold.Fact_Procedures

insert into Gold.Fact_Procedures([START],[STOP],Base_Cost,Encounter,Procedure_key)
select sp.[START],sp.[STOP],sp.BASE_COST,sp.ENCOUNTER,gdpr.Procedure_key
from silver.procedures sp left join Gold.Fact_Encounters gfe
on sp.ENCOUNTER=gfe.Id left join gold.Dim_Procedures gdpr
on sp.CODE=gdpr.Code and sp.[DESCRIPTION]=gdpr.[Description] and sp.REASONCODE=gdpr.ReasonCode 
and sp.REASONDESCRIPTION=gdpr.ReasonDescription

select * from Gold.Fact_Procedures
