create table Gold.DimOrganizations(
Organizationkey int identity(1,1) primary key,
id nvarchar(50),
[Name] nvarchar(50),
[Address] nvarchar(50),
city nvarchar(50),
[state] nvarchar(50),
Zip smallint,
LAT float,
LON float,
InsertDate date,
UpdateDate date
)

insert into Gold.DimOrganizations(id,[Name],[Address],city,[state],Zip,LAT,LON,InsertDate)
select distinct 
	coalesce(Id,'Not Defined'),
	coalesce([NAME],'Not Defined'),
	coalesce([ADDRESS],'Not Defined'),
	coalesce(CITY,'Not Defined'),
	coalesce([STATE],'Not Defined'),
	coalesce(ZIP,0),
	coalesce(LAT,0),
	coalesce(LON,0),
	GETDATE() as InsertDate
from silver.organizations


select * from Gold.DimOrganizations