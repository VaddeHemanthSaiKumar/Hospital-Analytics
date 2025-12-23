create table Gold.FactEncounters(
FactEncounterKey int identity(1,1) primary key,
Payerkey int,
patientkey int,
Organizationkey int,
EncounterClassKey int,
EncounterCodekey int,
ReasonCodeKey int,
Id nvarchar(50),
[Start] date,
[stop] date,
BaseEncounterCost float,
TotalClaimCost float,
PayerCoverage float,
InsertDate date,
UpdateDate date
)


insert into Gold.FactEncounters(EncounterClassKey,EncounterCodeKey,ReasonCodeKey,Payerkey,Organizationkey,patientkey,Id,[Start],[stop],BaseEncounterCost,TotalClaimCost,PayerCoverage,InsertDate)
select gdec.EncounterClassKey,gdeo.EncounterCodeKey,gder.ReasonCodeKey,gdp.Payer_key,gdo.Organizationkey,gdpa.patient_key,se.Id,se.[START],se.[STOP],se.BASE_ENCOUNTER_COST,se.TOTAL_CLAIM_COST,se.PAYER_COVERAGE,GETDATE() as InsertDate
from silver.encounters se left join Gold.DimPayers gdp
on se.PAYER=gdp.Id left join Gold.DimPatients gdpa
on se.PATIENT=gdpa.Id left join Gold.DimOrganizations gdo
on se.ORGANIZATION=gdo.id left join Gold.DimEncounterClass gdec
on se.ENCOUNTERCLASS=gdec.EncounterClass left join Gold.DimEncounterCode gdeo
on se.CODE=gdeo.Code and se.DESCRIPTION=gdeo.Description left join Gold.DimEncounterReasonCode gder
on se.REASONCODE=gder.ReasonCode

select * from Gold.FactEncounters
