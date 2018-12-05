cls
clear

/*
This program will merge formatted datasets to single dataset
for years 1993 to 2015]

Formatted to 2015 variables:
	YEAR SETTYPE PATWT
	DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D
	ETOHAB ALZHD ARTHRTIS ASTHMA AUTISM CANCER CEBVD CKD COPD CHF CAD
	DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID HTN 
	OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
	SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT
	MED1-MED30
*/

*source folder where all the formatted NAMCS datasets are in Stata .dta format
local source "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.1_Datasets_Formatted"

*output folder where the merged NAMCS datasets will be created in Stata .dta format
local output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.2_Datasets_Merged"


*load the datasets from 2009 to 2015 first, since they are the most similar
cd "`source'"

*2015
use namcs2015.dta


*merge 2014 to 2015
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30 using namcs2014.dta

	*drop the merge indicator
	drop _merge

	
*merge 2013 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED10 using namcs2013.dta

	*drop the merge indicator
	drop _merge

*merge 2012 to previous
*	differences: only 10 meds
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED10 using namcs2012.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2011 to previous
*	differences: only 8 meds
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using namcs2011.dta

	*drop the merge indicator
	drop _merge

	
*merge 2010 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using namcs2010.dta

	*drop the merge indicator
	drop _merge

	
*merge 2009 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using namcs2009.dta

	*drop the merge indicator
	drop _merge

	
/*merge 2008 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using namcs2008.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2007 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using namcs2007.dta

	*drop the merge indicator
	drop _merge	
	
	
*merge 2006 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using namcs2006.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2005 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using namcs2005.dta

	*drop the merge indicator
	drop _merge

	
*merge 2004 to previous
*	differences: no "SPECCAT" variable
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED8 using namcs2004.dta

	*drop the merge indicator
	drop _merge

	
*merge 2003 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED8 using namcs2003.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2002 to previous
*	differences: only 6 meds
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED6 using namcs2002.dta

	*drop the merge indicator
	drop _merge	

	
*merge 2001 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED6 using namcs2001.dta

	*drop the merge indicator
	drop _merge	

	
*merge 2000 to previous
*	differences: no SETTYPE variable
merge 1:1 	YEAR PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED6 using namcs2000.dta

	*drop the merge indicator
	drop _merge		
*/

*sort by year, descending
gsort -YEAR

cd "`output'"
save namcs_2015to1993, replace
