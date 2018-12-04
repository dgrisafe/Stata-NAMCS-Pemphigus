*note:	This program works for NAMCS datasets from years 1993 to 1994.
*		The variables become lower case for years 2002-2005.
*		Another program will be used to subset these years
*		Note: 2004 and earlier does not have "speccat" variable.
*		Note: 2002 and earliers only has at most 6 spots for meds.
*		Note: 2000 lacks "SETTYPE" (says its NAMCS data), has "OWNER (not "OWNS") variable
*		Note: 1999 says "URBAN" (not "MSA"); no observations for 1999
*		Note: 1996 says "TYPEPAY" (not "PAYTYPE"); does not have "OWNER" variable; no observations 1996
*		Note: 1994 has numeric values for DIAG1-3, with labels which had to be force to strings; no "AGER" variable
*				1994 has no TYPEPAY (made one), and has no MED6

cls
clear

*mac path to complete NAMCS datasets for 1993 to 2015
*	each dataset has about 30,000 observations
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/!NAMCS_Stata"
use namcs1993.dta

*convert diagnosis variables to strings
tostring DIAG1 DIAG2 DIAG3, replace force

*keep observations with diagnoses of pemphigus (6944) and pemphidoid (6955)
keep if (	strpos(DIAG1, "6944") | strpos(DIAG2, "6944") | strpos(DIAG3, "6944") | ///
			strpos(DIAG1, "6945") | strpos(DIAG2, "6945") | strpos(DIAG3, "6945"))


*check out the observations in subset
list PATWT DIAG1 DIAG2 DIAG3 AGE SEX 
summarize PATWT DIAG1 DIAG2 DIAG3 AGE SEX
		
*make a TYPEPAY variable from the indicator variables
gen TYPEPAY = .
replace TYPEPAY = 1 	if PRIVINS == 1 | HMO == 1
replace TYPEPAY = 2 	if MEDICARE == 1
replace TYPEPAY = 3 	if MEDICAID == 1
replace TYPEPAY = 4 	if OTHGOVT == 1
replace TYPEPAY = 5 	if SELFPAY == 1
replace TYPEPAY = 6 	if NOCHARGE == 1
replace TYPEPAY = 7 	if OTHPAY == 1
replace TYPEPAY = -8	if UNKPAY == 1
replace TYPEPAY = -9 	if PRIVINS == 0 & HMO == 0 & MEDICARE == 0		///
						& MEDICAID == 0 & OTHGOVT == 0 & SELFPAY == 0 	///
						& NOCHARGE == 0 & OTHPAY == 0 & UNKPAY == 0

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
		SEX AGE RACE ETHNIC TYPEPAY REGION URBAN SPECR								///
		MED1-MED5
		
*format variables so in standard format as datasets from later years
rename	(RACE	ETHNIC		TYPEPAY		REGION		URBAN)					///
		(RACER	RACERETH	PAYTYPER	REGIONOFF	MSA)

order  	YEAR PATWT 															///
		DIAG1 DIAG2 DIAG3 													///
		SEX AGE RACER RACERETH PAYTYPER REGIONOFF MSA SPECR					///
		MED1-MED5

		
*change directory to where would like to save datasets
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1992-15"
save pemphigus_namcs_1993, replace

summarize
