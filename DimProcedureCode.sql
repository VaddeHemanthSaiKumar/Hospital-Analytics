create table Gold.DimProcedureCode(
ProcedureCodeKey int identity(1,1) primary key,
Code bigint,
[Description] nvarchar(150),
InsertDate date,
UpdateDate date
)



insert into Gold.DimProcedureCode(Code,[Description],InsertDate)
select distinct 
	coalesce(CODE,0),
	coalesce([DESCRIPTION],'Not Defined'),
	GETDATE() as InsertDate
from silver.procedures



select * from Gold.DimProcedureCode

