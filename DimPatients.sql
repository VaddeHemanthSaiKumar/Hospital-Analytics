create table Gold.DimPatients(
patient_key int identity(1,1) primary key,
Id nvarchar(50),
Birthdate date,
Deathdate date,
Prefix nvarchar(50),
Suffix nvarchar(50),
Maiden nvarchar(50),
Marital nvarchar(50),
Race nvarchar(50),
Ethnicity nvarchar(50),
Gender nvarchar(50),
Birthplace nvarchar(50),
[ADDRESS] nvarchar(50),
City nvarchar(50),
[State] nvarchar(50),
County nvarchar(50),
Zip smallint,
LAT float,
LON float,
InsertDate date,
UpdateDate date
)

insert into Gold.DimPatients(Id,Birthdate,Deathdate,Prefix,Suffix,Maiden,Marital,Race,Ethnicity,Gender,Birthplace,[ADDRESS],City,[State],County,Zip,LAT,LON,InsertDate)
select distinct 
	coalesce(Id,'Not Defined'),
	coalesce(BIRTHDATE,'1900-01-01'),
	DEATHDATE,
	coalesce(PREFIX,'Not Defined'),
	coalesce(SUFFIX,'Not Defined'),
	coalesce(MAIDEN,'Not Defined'),
	coalesce(MARITAL,'Not Defined'),
	coalesce(RACE,'Not Defined'),
	coalesce(ETHNICITY,'Not Defined'),
	coalesce(GENDER,'Not Defined'),
	coalesce(BIRTHPLACE,'Not Defined'),
	coalesce([ADDRESS],'Not Defined'),
	coalesce(CITY,'Not Defined'),
	coalesce([STATE],'Not Defined'),
	coalesce(COUNTY,'Not Defined'),
	coalesce(ZIP,0),
	coalesce(LAT,0),
	coalesce(LON,0),
	GETDATE() as InsertDate
from silver.patients



select * from Gold.DimPatients