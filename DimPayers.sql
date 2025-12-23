Create table Gold.DimPayers(
Payer_key int identity(1,1) primary key,
Id nvarchar(50),
[Name] nvarchar(50),
[Address] nvarchar(50),
City nvarchar(50),
State_Headquartered nvarchar(50),
Zip int,
Phone nvarchar(50),
InsertDate date,
UpdateDate date
)

insert into Gold.DimPayers(Id,[Name],[Address],City,State_Headquartered,Zip,Phone,InsertDate)
select distinct 
	coalesce(Id,'Not Defined'),
	coalesce([NAME],'Not Defined'),
	coalesce([ADDRESS],'Not Defined'),
	coalesce(CITY,'Not Defined'),
	coalesce(STATE_HEADQUARTERED,'Not Defined'),
	coalesce(ZIP,0),
	coalesce(PHONE,'0-000-000'),
	GETDATE() as InsertDate
from silver.payers


select * from Gold.DimPayers

