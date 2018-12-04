*note:	This program works for NAMCS datasets from years 200? to 2013.
*		The variables all become lower case for previous years.
*		Another program will be used to subset these years

*		Note: only 10 medicine variables for 2013; no observations for 2013
*		There are 2 SPECR variables in 2012: (SPECR_14 and SPECR_17), went with former

cls
clear

*mac path to complete NAMCS datasets for 1993 to 2015
*	each dataset has about 30,000 observations
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/!NAMCS_Stata"
use namcs2012_chc.dta


*keep observations with diagnoses of pemphigus (6944) and pemphidoid (6955)

keep if (	strpos(DIAG1, "6944") | strpos(DIAG2, "6944") | strpos(DIAG3, "6944") | ///
			strpos(DIAG1, "6945") | strpos(DIAG2, "6945") | strpos(DIAG3, "6945"))


*check out the observations in subset
list PATWT DIAG1 DIAG2 DIAG3 AGE SEX SPECCAT
summarize PATWT DIAG1 DIAG2 DIAG3 AGE SEX

*only keep relevant variables for Sharma (2007)
*	Tables 1 & 2:		gender, age, race, insurance, region, setting, practice, provider
*	Figure1:	proportion of visits
*	Figure2:	proportions of topical medication Rxs provided during visits
*		label define MEDCODF 09137 "PIMECROLIMUS"
*		label define MEDCODF 97130 "TACROLIMUS"
*		label define MEDCODF 94079 "CORTICOSTEROID(S)" , add

*	Keep all variables for weights
keep 	YEAR SETTYPE PATWT 													///
		DIAG1 DIAG2 DIAG3 													///
		SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR_14 SPECCAT	///
		MED1-MED10

*chose SPECR_14 (not SPECR_17), and renamed it to fit
rename (SPECR_14) (SPECR)

order  	YEAR SETTYPE PATWT 													///
		DIAG1 DIAG2 DIAG3 													///
		SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
		MED1-MED10

*change directory to where would like to save datasets
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1992-15"
save pemphigus_namcs_2012_chc, replace

summarize
