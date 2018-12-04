*note:	This program works for NAMCS datasets from years 1997 to 1999.
*		The variables become lower case for years 2002-2005.
*		Another program will be used to subset these years
*		Note: 2004 and earlier does not have "speccat" variable.
*		Note: 2002 and earliers only has at most 6 spots for meds.
*		Note: 2000 lacks "SETTYPE" (says its NAMCS data), has "OWNER (not "OWNS") variable
*		Note: 1999 says "URBAN" (not "MSA"); no observations for 1999

cls
clear

*mac path to complete NAMCS datasets for 1993 to 2015
*	each dataset has about 30,000 observations
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/!NAMCS_Stata"
use namcs1999.dta


*keep observations with diagnoses of pemphigus (6944) and pemphidoid (6955)

keep if (	strpos(DIAG1, "6944") | strpos(DIAG2, "6944") | strpos(DIAG3, "6944") | ///
			strpos(DIAG1, "6945") | strpos(DIAG2, "6945") | strpos(DIAG3, "6945"))


*check out the observations in subset
list PATWT DIAG1 DIAG2 DIAG3 AGE SEX 
summarize PATWT DIAG1 DIAG2 DIAG3 AGE SEX

*only keep relevant variables for Sharma (2007)
*	Tables 1 & 2:		gender, age, race, insurance, region, setting, practice, provider
*	Figure1:	proportion of visits
*	Figure2:	proportions of topical medication Rxs provided during visits
*		label define MEDCODF 09137 "PIMECROLIMUS"
*		label define MEDCODF 97130 "TACROLIMUS"
*		label define MEDCODF 94079 "CORTICOSTEROID(S)" , add

*	Keep all variables for weights
keep 	YEAR PATWT 															///
		DIAG1 DIAG2 DIAG3 													///
		SEX AGE AGER RACE ETHNIC PAYTYPE REGION URBAN OWNER SPECR			///
		MED1-MED6
		
*format variables so in standard format as datasets from later years
rename	(RACE	ETHNIC		PAYTYPE		REGION		URBAN	OWNER)			///
		(RACER	RACERETH	PAYTYPER	REGIONOFF	MSA		OWNSR)

order  	YEAR PATWT 															///
		DIAG1 DIAG2 DIAG3 													///
		SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR		///
		MED1-MED6

		
*change directory to where would like to save datasets
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1992-15"
save pemphigus_namcs_1999, replace

summarize
