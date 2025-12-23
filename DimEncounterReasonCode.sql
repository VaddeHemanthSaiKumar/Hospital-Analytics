create table Gold.DimEncounterReasonCode(
ReasonCodeKey int identity(1,1) primary key,
ReasonCode bigint,
ReasonDescription nvarchar(100),
InsertDate date,
UpdateDate date
)





insert into Gold.DimEncounterReasonCode(ReasonCode,ReasonDescription,InsertDate)
select distinct 
	coalesce(REASONCODE,0),
	coalesce(REASONDESCRIPTION,'NotDefined'),
	GETDATE() as InsertDate
from silver.encounters



select * from Gold.DimEncounterReasonCode

