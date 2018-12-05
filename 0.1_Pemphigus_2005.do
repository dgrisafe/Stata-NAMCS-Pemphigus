*note:	This program works for NAMCS dataset for 2005.
*		The variables all become upper case for later years.
*		Another program will be used to subset these years

cls
clear

*mac path to complete NAMCS datasets for 1993 to 2015
*	each dataset has about 30,000 observations
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/!NAMCS_Stata"
use namcs2005.dta


*keep observations with diagnoses of pemphigus (6944) and pemphidoid (6955)

keep if (	strpos(diag1, "6944") | strpos(diag2, "6944") | strpos(diag3, "6944") | ///
			strpos(diag1, "6945") | strpos(diag2, "6945") | strpos(diag3, "6945"))


*check out the observations in subset
list patwt diag1 diag2 diag3 age sex racer raceeth specr speccat
summarize patwt diag1 diag2 diag3 age sex

*only keep relevant variables for Sharma (2007)
*	Tables 1 & 2:		gender, age, racer, insurance, region, setting, practice, provider
*	Figure1:	proportion of visits
*	Figure2:	proportions of topical medication Rxs provided during visits
*		label define MEDCODF 09137 "PIMECROLIMUS"
*		label define MEDCODF 97130 "TACROLIMUS"
*		label define MEDCODF 94079 "CORTICOSTEROID(S)" , add

*	Keep all variables for weights
keep 	year settype patwt 													///
		diag1 diag2 diag3 													///
		sex age ager racer raceeth paytype region msa owns specr speccat		///
		med1-med8

*format variables so in standard format as datasets from later years
rename(	year settype patwt 													///
		diag1 diag2 diag3 													///
		sex age ager racer raceeth paytype region msa owns specr speccat			///
		med1 med2 med3 med4 med5 med6 med7 med8								///
	) (	YEAR SETTYPE PATWT 													///
		DIAG1 DIAG2 DIAG3 													///
		SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
		MED1 MED2 MED3 MED4 MED5 MED6 MED7 MED8								///
	)

order  	YEAR SETTYPE PATWT 													///
		DIAG1 DIAG2 DIAG3 													///
		SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
		MED1-MED8

*change directory to where would like to save datasets
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1992-15"
save pemphigus_namcs_2005, replace

summarize
