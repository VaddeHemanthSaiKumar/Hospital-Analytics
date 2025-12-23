create table Gold.FactProcedures(
FactProcedureKey int identity(1,1) primary key,
ProcedureCodeKey int,
ReasonCodeKey int,
[START] date,
[STOP] date,
BaseCost int,
Encounter nvarchar(50),
Insertdate date,
UpdateDate date
)

insert into Gold.FactProcedures([START],[STOP],BaseCost,Encounter,ProcedureCodeKey,ReasonCodeKey,Insertdate)
select sp.[START],sp.[STOP],sp.BASE_COST,sp.ENCOUNTER,gdcc.ProcedureCodeKey,gdprr.ReasonCodeKey,GETDATE() as InsertDate
from silver.procedures sp left join Gold.DimProcedureCode gdcc
on sp.CODE=gdcc.Code and sp.DESCRIPTION=gdcc.Description left join Gold.DimProcedureReasonCode gdprr
on sp.REASONCODE=gdprr.ReasonCode left join Gold.FactEncounters gfee
on sp.ENCOUNTER=gfee.Id

select * from Gold.FactProcedures
