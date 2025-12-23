create table Gold.DimEncounterClass(
EncounterClassKey int identity(1,1) primary key,
EncounterClass nvarchar(50),
InsertDate date,
UpdateDate date
)


insert into Gold.DimEncounterClass(EncounterClass,InsertDate)
select distinct 
	coalesce(ENCOUNTERCLASS,'NotDefined'),
	GETDATE() as InsertDate
from silver.encounters

select * from Gold.DimEncounterClass