create table Gold.DimEncounterCode(
EncounterCodeKey int identity(1,1) primary key,
Code int,
[Description] nvarchar(100),
InsertDate date,
UpdateDate date
)


insert into Gold.DimEncounterCode(Code,[Description],InsertDate)
select distinct 
	coalesce(CODE,0),
	coalesce([DESCRIPTION],'NotDefined'),
	GETDATE() as InsertDate
from silver.encounters

select * from Gold.DimEncounterCode