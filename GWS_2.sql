use mini_project
--this can be uncommented to see all the column that appear in the orignial table and all the corresponding values
--select * from dbo.APC

-- 1.first the relevant columns that have codes need to be identified by checking each column against the GWS data dictionary
-- 2.columns which have codes that represent certain infromation and options are then each individually used below to 
-- create tables that have the ID and description for the relevant columns.
--3. The tables created are all identified with a dim code.
--4. the tables are created such that they contain the relevant values that exisit in the original table and not those that dont appear 
--eg. if a certain epitype does not apear in the APC table then it will not appear in the dim table
--5. some nulls were cleansed and removed in these tables
--6. The creation of each of these separate tables can be seen below

/* the table code:
1. ID OBJECT ID...END, DROP TABLE
This bit of code says that if the table specified exitis then drop it so that the code below it can be re run and the table created
2. SELECT DISTICNT..CASE..INTO NEW TABLE FROM CURRENT TABLE
This bit of code creates the table again and lists all the possible cases (for the specific column) and then input the values that exisit from the 
current table to the new table
the table is called Dim[ColumnName]
This process is repeated for each column that was identified to have codes
*/
--Epitype column
IF OBJECT_ID('dbo.DimEpitype') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimEpitype
END

SELECT DISTINCT
     epitype as ID
     ,CASE
                 WHEN epitype = '1' THEN 'General episode (anything that is not covered by the other codes)'
				 WHEN epitype = '2' THEN 'Delivery episode'
                 WHEN epitype = '3' THEN 'Birth episode'
				 WHEN epitype = '4' THEN 'Formally detained under the provisions of mental health legislation or long-term (over one year) psychiatric patients who should have additional information recorded on the psychiatric census. This value can only appear in unfinished records (Episode Status (EPISTAT) = 1)'
				 WHEN epitype = '5' THEN 'Other delivery event'
				 WHEN epitype = '6' THEN 'Other birth event'
				 -- noticed that there were nulls when the epitype said 0 so this was added to clean the data
				 when epitype='0' then 'Unknown'
	END AS DESCRIPTION

INTO dbo.DimEpitype
FROM dbo.APC

--can uncomment code below to view table
--select * from DimEpitype

--sex column
IF OBJECT_ID('dbo.DimSex') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimSex
END

SELECT DISTINCT
     sex as ID
     ,CASE
                WHEN sex = '1' THEN 'Male'
				WHEN sex = '2' THEN 'Female'
				WHEN sex = '9' THEN 'Not specified'
				WHEN sex = '0' THEN 'Not known'
     END AS DESCRIPTION

INTO dbo.DimSex
FROM dbo.APC

--can uncomment code below to view table
select * from DimSex


--epistat column

IF OBJECT_ID('dbo.DimEpistat') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimEpistat
END

SELECT DISTINCT 
	epistat as ID,
	CASE 
	when epistat = '1' then 'Unfinished'
	when epistat = '3' then 'Finished'
	when epistat = '9' then 'Derived unfinished (not present on processed data)'
	
END as [Description]
into dbo.DimEpistat
from APC

--can uncomment code below to view table
--select * from DimEpistat

IF OBJECT_ID('dbo.DimAdmincat') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdmincat
END

--admincat column
SELECT DISTINCT 
	admincat as ID,
	CASE 
	when admincat = '1' then 'NHS patient including overseas visitors charged under Section 121 of the NHS Act 1977 as amended by Section 7(12) and (14) of the Health and Medicine Act 1988'
	when admincat = '2' then 'Private patient: one who uses accommodation or services authorised under section 65 and/or 66 of the NHS Act 1977 (Section 7(10) of Health and Medicine Act 1988 refers) as amended by Section 26 of the National Health Service and Community Care Act 1990' 
	when admincat = '3' then 'Amenity patient: one who pays for the use of a single room or small ward in accord with section 12 of the NHS Act 1977, as amended by section 7(12) and (14) of the Health and Medicine Act 1988'
	when admincat = '4' then 'A category II patient: one for whom work is undertaken by hospital medical or dental staff within categories II as defined in paragraph 37 of the Terms and Conditions of Service of Hospital Medical and Dental Staff'
	when admincat = '98' then 'Not applicable'
END as [Description]
into dbo.DimAdmincat
from APC

--can uncomment code below to view table
--select * from DimAdmincat

--admincatst column

IF OBJECT_ID('dbo.DimAdmincatst') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdmincatst
END


SELECT DISTINCT 
	admincatst as ID,
	CASE 
	when admincatst = '1' then 'NHS patient'
	when admincatst = '2' then 'Private patient' 
	when admincatst = '3' then 'Amenity patient'
	when admincatst = '4' then 'Category II patient'
	when admincatst = '98' then 'Not applicable'
END as [Description]
into dbo.DimAdmincatst
from APC

--can uncomment code below to view table
--select * from DimAdmincatst

--category table
IF OBJECT_ID('dbo.DimCategory') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimCategory
END

SELECT DISTINCT
     category as ID
     ,CASE
                WHEN category = '10' THEN 'NHS patient: not formally detained'
				WHEN category = '11' THEN 'NHS patient: formally detained under Part II of the Mental Health Act 1983'
				WHEN category = '12' THEN 'NHS patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'
				WHEN category = '13' THEN 'NHS patient: formally detained under part X, Mental Health Act 1983'  
				WHEN category = '20' THEN 'Private patient: not formally detained'
				WHEN category = '21' THEN 'Private patient: formally detained under Part II of the Mental Health Act 1983'
				WHEN category = '22' THEN 'Private patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'
				WHEN category = '23' THEN 'Private patient: formally detained under part X, Mental health Act 1983'
				WHEN category = '30' THEN 'Amenity patient: not formally detained'
				WHEN category = '31' THEN 'Amenity patient: formally detained under Part II of the Mental Health Act 1983'
				WHEN category = '32' THEN 'Amenity patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'
				WHEN category = '33' THEN 'Amenity patient: formally detained under part X, Mental health Act 1983'
     END AS DESCRIPTION

INTO dbo.DimCategory
FROM dbo.APC

--can uncomment code below to view table
--select * from DimCategory

--ethnos column

IF OBJECT_ID('dbo.DimEthnos') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimEthnos
END
-- THEN THE SELECT … INTO from a query to create the table just here…
SELECT DISTINCT
     ETHNOS as ID
     ,CASE
     WHEN ETHNOS = 'H' THEN 'Indian (Asian or Asian British)'
                 WHEN ETHNOS = 'A' THEN 'British (White)'
                 WHEN ethnos = 'B' THEN 'Irish (White)'
				 WHEN ethnos = 'C' THEN 'Another other White background'
				 WHEN ethnos = 'D' THEN 'White and Black Caribbean (Mixed)'
				 WHEN ethnos = 'E' THEN 'White and Black African (Mixed)'
				 WHEN ethnos = 'F' THEN 'White and Asian (Mixed)'
				 WHEN ethnos = 'G' THEN 'Any other Mixed background'
				 WHEN ethnos = 'J' THEN 'Pakistani (Asian or Asian British)'
				 WHEN ethnos = 'K' THEN 'Bangladeshi (Asian or Asian British)'
				 WHEN ethnos = 'L' THEN 'Any other Asian background'
				 WHEN ethnos = 'M' THEN 'Caribbean (Black or British)'
				 WHEN ethnos = 'N' THEN 'African (Black or British)'
				 WHEN ethnos = 'P' THEN 'Any other black background'
				 WHEN ethnos = 'R' THEN 'Chinese (other ethnic group'
				 WHEN ethnos = 'S' THEN 'Any other ethnic group'
				 WHEN ethnos = 'Z' THEN 'Not stated'
				 WHEN ethnos = 'X' THEN 'Not known (prior to 2013)'
				 -- entries with values of 99 showed null, therfore they were also classified as unknown for clean data
				 WHEN ethnos = '99' THEN 'Not known (2013 onwards)'
     END AS DESCRIPTION
-- UNCOMMENT THIS BIT WHEN TESTED AND LOOKING GOOD
INTO dbo.DimEthnos
FROM dbo.APC

--can uncomment code below to view table
--select * from DimEthnos

--leglcat column

IF OBJECT_ID('dbo.DimLeglCat') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimLeglCat
END

SELECT DISTINCT
     leglcat as ID
     ,CASE
                WHEN leglcat = '01' THEN 'Informal'
				WHEN leglcat = '02' THEN 'Formally detained under the Mental Health Act, Section 2'
				WHEN leglcat = '03' THEN 'Formally detained under the Mental Health Act, Section 3'
				WHEN leglcat = '04' THEN 'Formally detained under the Mental Health Act, Section 4'
				WHEN leglcat = '05' THEN 'Formally detained under the Mental Health Act, Section 5(2)'
				WHEN leglcat = '06' THEN 'Formally detained under the Mental Health Act, Section 5(4)'
				WHEN leglcat = '07' THEN 'Formally detained under the Mental Health Act, Section 35'
				WHEN leglcat = '08' THEN 'Formally detained under the Mental Health Act, Section 36'
				WHEN leglcat = '09' THEN 'Formally detained under the Mental Health Act, Section 37 with Section 41 restrictions'
				WHEN leglcat = '10' THEN 'Formally detained under the Mental Health Act, Section 37 excluding Section 37(4)'
				WHEN leglcat = '11' THEN 'Formally detained under the Mental Health Act, Section 37(4)'
				WHEN leglcat = '12' THEN 'Formally detained under the Mental Health Act, Section 38'
				WHEN leglcat = '13' THEN 'Formally detained under the Mental Health Act, Section 44'
				WHEN leglcat = '14' THEN 'Formally detained under the Mental Health Act, Section 46'
				WHEN leglcat = '15' THEN 'Formally detained under the Mental Health Act, Section 47 with Section 49 restrictions'
				WHEN leglcat = '16' THEN 'Formally detained under the Mental Health Act, Section 47'
				WHEN leglcat = '17' THEN 'Formally detained under the Mental Health Act, Section 48 with Section 49 restrictions'
				WHEN leglcat = '18' THEN 'Formally detained under the Mental Health Act, Section 48'
				WHEN leglcat = '19' THEN 'Formally detained under the Mental Health Act, Section 135'
				WHEN leglcat = '20' THEN 'Formally detained under the Mental Health Act, Section 136'
				WHEN leglcat = '21' THEN 'Formally detained under the previous legislation (fifth schedule)'
				WHEN leglcat = '22' THEN 'Formally detained under Criminal Procedure (Insanity) Act 1964 as amended by the Criminal Procedures (Insanity and Unfitness to Plead) Act 1991'
				WHEN leglcat = '23' THEN 'Formally detained under other Acts'
				WHEN leglcat = '24' THEN 'Supervised discharge under the Mental Health (Patients in the Community) Act 1995'
				WHEN leglcat = '25' THEN 'Formally detained under the Mental Health Act, Section 45A'
				WHEN leglcat = '26' THEN 'Not applicable'
				WHEN leglcat = '27' THEN 'Not known'
				-- entries with values of 00 showed null, therfore they were also classified as unknown for clean data
				when leglcat='00' then 'Not known'
				
     END AS DESCRIPTION
-- UNCOMMENT THIS BIT WHEN TESTED AND LOOKING GOOD
INTO dbo.DimLeglCat
FROM dbo.APC

--can uncomment code below to view table
--select * from DimLeglCat

--admimeth column


IF OBJECT_ID('dbo.DimAdmimeth') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdmimeth
END


SELECT DISTINCT 
	admimeth as ID,
	CASE 
	when admimeth = '11' then 'Waiting list. . A Patient admitted electively from a waiting list having been given no date of admission at a time a decision was made to admit'
	when admimeth = '12' then 'Booked. A Patient admitted having been given a date at the time the decision to admit was made, determined mainly on the grounds of resource availability' 
	when admimeth = '13' then 'Planned. A Patient admitted, having been given a date or approximate date at the time that the decision to admit was made. This is usually part of a planned sequence of clinical care determined mainly on social or clinical criteria (e.g. check cystoscopy)". A planned admission is one where the date of admission is determined by the needs of the treatment, rather than by the availability of resources'
	when admimeth = '21' then 'Accident and emergency or dental casualty department of the Health Care Provider'
	when admimeth = '22' then 'General Practitioner: after a request for immediate admission has been made direct to a Hospital Provider, i.e. not through a Bed bureau, by a General Practitioner: or deputy'
	when admimeth = '23' then 'Bed bureau'
	when admimeth = '24' then 'Consultant Clinic, of this or another Health Care Provider'
	when admimeth = '25' then 'Admission via Mental Health Crisis Resolution Team'
	when admimeth = '2A' then 'Accident and Emergency Department of another provider where the patient had not been admitted'
	when admimeth = '2B' then 'Transfer of an admitted patient from another Hospital Provider in an emergency'
	when admimeth = '28' then ' Other means, examples are:
- Admitted from the Accident and Emergency Department of another provider
where they had not been admitted
- Transfer of an admitted patient from another Hospital Provider in an emergency
- Baby born at home as intended'
	when admimeth = '31' then 'Admitted ante-partum'
	when admimeth = '32' then 'Admitted post-partum'
	when admimeth = '99' then 'Not known: a validation error'
END as [Description]
into dbo.DimAdmimeth
from dbo.APC

--can uncomment code below to view table
--select * from DimAdmimeth

--adminsorc table
IF OBJECT_ID('dbo.DimAdmisorc') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdmisorc
END

SELECT DISTINCT
     Admisorc as ID
     ,CASE
		WHEN Admisorc = '19' THEN 'The usual place of residence, unless listed below, for example, a private dwelling whether owner occupied or owned by Local Authority, housing association or other landlord. This includes wardened accommodation but not residential accommodation where health care is provided. It also includes PATIENTS with no fixed abode.'
		WHEN Admisorc = '29' THEN 'Temporary place of residence when usually resident elsewhere, for example, hotels and residential educational establishments'
		WHEN Admisorc = '30' THEN 'Repatriation from high security psychiatric hospital (1999-00 to 2006-07)'
		WHEN Admisorc = '37' THEN 'Penal establishment: court (1999-00 to 2006-07)'
		WHEN Admisorc = '38' THEN 'Penal establishment: police station (1999-00 to 2006-07)'
		WHEN Admisorc = '39' THEN 'Penal establishment, Court or Police Station /  Police Custody Suite'
		WHEN Admisorc = '48' THEN 'High security psychiatric hospital, Scotland (1999-00 to 2006-07)'
		WHEN Admisorc = '49' THEN 'NHS other hospital provider: high security psychiatric accommodation in an NHS hospital provider (NHS trust or NHS Foundation Trust)'
		WHEN Admisorc = '50' THEN 'NHS other hospital provider: medium secure unit (1999-00 to 2006-07)'
		WHEN Admisorc = '51' THEN 'NHS other hospital provider: ward for general patients or the younger physically disabled or A&E department'
		WHEN Admisorc = '52' THEN 'NHS other hospital provider: ward for maternity patients or neonates'
		WHEN Admisorc = '53' THEN 'NHS other hospital provider: ward for patients who are mentally ill or have learning disabilities'
		WHEN Admisorc = '54' THEN 'NHS run Care Home'
		WHEN Admisorc = '65' THEN 'Local authority residential accommodation i.e. where care is provided'
		WHEN Admisorc = '66' THEN 'Local authority foster care, but not in residential accommodation i.e. where care is provided'
		WHEN Admisorc = '69' THEN 'Local authority home or care (1989-90 to 1995-96)'
		WHEN Admisorc = '79' THEN 'Babies born in or on the way to hospital'
        WHEN Admisorc = '85' THEN 'Non-NHS (other than Local Authority) run care home'
		WHEN Admisorc = '86' THEN 'Non-NHS (other than Local Authority) run nursing home'
		WHEN Admisorc = '87' THEN 'Non-NHS run hospital'
		WHEN Admisorc = '88' THEN 'non-NHS (other than Local Authority) run hospice'
		WHEN Admisorc = '89' THEN 'Non-NHS institution (1989-90 to 1995-96)'
		WHEN Admisorc = '98' THEN 'Not applicable'
		WHEN Admisorc = '99' THEN 'Not known'

     END AS DESCRIPTION

INTO dbo.DimAdmisorc
FROM dbo.APC

--can uncomment code below to view table
--select * from DimAdmisorc

--classpat table
IF OBJECT_ID('dbo.DimClasspat') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimClasspat
END


SELECT DISTINCT 
	classpat as ID,
	CASE 
	when classpat = '1' then 'Ordinary admission'
	when classpat = '2' then 'Day case admission' 
	when classpat = '3' then 'Regular day attender'
	when classpat = '4' then 'Regular night attender'
	when classpat = '5' then 'Mothers and babies usin only delivery facilities'
	when classpat = '8' then 'Not applicable (other maternity event)'
	when classpat = '9' then 'Not known'
END as [Description]
into dbo.DimClasspat
from APC

--can uncomment code below to view table
--select * from DimClasspat

--spellbgin column

IF OBJECT_ID('dbo.DimSpellBgin') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimSpellBgin
END


SELECT DISTINCT 
	spellbgin as ID,
	CASE 
	when spellbgin = '0' then 'Not the first episode'
	when spellbgin = '1' then 'First episode of spelll that started in previous year' 
	when spellbgin = '2' then 'First episode of spell that started in current year'
	-- entriesshowed null, therfore they were also classified as N/A for clean data
	when spellbgin = 'NULL' then 'Not applicable'
END as [Description]
into dbo.DimSpellBgin
from APC

--can uncomment code below to view table
--select * from DimSpellBgin


/*
After each table was created with the Column ID's and the corresponding descirptions, a join was done to put the descrioptive column into the original table
and replace the code to become a human understandable table for analysis.
the table was also assesed for remaining nulls and those columns that had null values were changed to unknown for consistency and clean data as shown below in select code
*/

select --selects all the columns of the table with some useing case statements to remove the nulls
spell,
episode,
epistart,
epiend,
case when dimepitype.[description] is null then'unknown'
	else dimepitype.[description]
	end as epitype,
dimsex.description as sex,
case when bedyear is null then datediff(dd,epistart,epiend)
	else bedyear
	end as bedyear,
epidur,
dimepistat.description as epistat,
dimSpellBgin.description as spellbgin,
activage,
admiage,
dimadmincat.description as admincat,
dimadmincatst.description as admincatst,
dimCategory.description category,
dob,
case when endage is null then 'unknown'
else endage
end endage,
case when dimethnos.[description] is null then 'unknown'
	else dimethnos.description
	end as ethnos,
hesid,
dimLeglCat.description leglcat,
lopatid,
mydob,
case when newnhsno is null then 'unknown'
	else newnhsno
	end as newnhsno,
newnhsno_check,
startage,
admistart,
dimAdmiMeth.description admimeth,
dimAdmisorc.description admisorc,
case when elecdate is null then '1800-01-01'
	else elecdate
	end as elecdate,
elecdur,
elecdur_calc,
classpat,
diag_01
--creates new table called clean data
into dbo.CleanData
from APC as T
--joins the tbales together on the code values
inner join dimepitype on T.epitype = dimepitype.ID
inner join dimsex on T.sex = dimsex.ID
inner join dimepistat on T.epistat = dimepistat.ID
inner join dimSpellBgin on T.spellbgin = dimSpellBgin.ID
inner join dimadmincat on T.admincat = dimadmincat.ID
inner join dimadmincatst on T.admincatst = dimadmincatst.ID
inner join dimCategory on T.category = dimCategory.ID
inner join DimEthnos on T.ethnos = DimEthnos.ID
inner join dimLeglCat on T.leglcat = DimLeglCat.ID
inner join dimAdmiMeth on T.admimeth = dimAdmiMeth.ID
inner join dimadmisorc on T.admisorc = dimadmisorc.ID

--the below code can be used to check each column and count the nulls to ensure none are left
/*
select * from dbo.CleanData
select 
count(*) - count(elec)
from dbo.CleanData
*/