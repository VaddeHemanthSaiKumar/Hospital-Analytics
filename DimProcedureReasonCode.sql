create table Gold.DimProcedureReasonCode(
ReasonCodeKey int identity(1,1) primary key,
ReasonCode bigint,
ReasonDescription nvarchar(100),
InsertDate date,
UpdateDate date
)



insert into Gold.DimProcedureReasonCode(ReasonCode,ReasonDescription,InsertDate)
select distinct 
	coalesce(REASONCODE,0),
	coalesce(REASONDESCRIPTION,'NotDefined'),
	GETDATE() as InsertDate
from silver.procedures



select * from Gold.DimProcedureReasonCode


