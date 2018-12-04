*combine all pemphigus datasets for years 1993 to 2015]
*need to go back to cutting programs to ensure the formatting is all the same

cls
clear

*mac path to pemphigus/oid complete NAMCS datasets for 1993 to 2015
*	each dataset has about 10 observations
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1992-15"

*load the datasets from 2006 to 2015 first, since they are the most similar


*2015
use pemphigus_namcs_2015.dta


*merge 2014 to 2015
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30 using pemphigus_namcs_2014.dta

	*drop the merge indicator
	drop _merge

	
*no observations for 2013


*merge 2012 to previous
*	differences: only 10 meds
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED10 using pemphigus_namcs_2012.dta

	*drop the merge indicator
	drop _merge


*merge 2012chc to previous
*	differences: OWNSR_CHC (not "OWNSR"), so don't merge on it
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA SPECR SPECCAT	///
			MED1-MED10 using pemphigus_namcs_2012_chc.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2011 to previous
*	differences: only 8 meds
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using pemphigus_namcs_2011.dta

	*drop the merge indicator
	drop _merge

	
*merge 2010 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using pemphigus_namcs_2010.dta

	*drop the merge indicator
	drop _merge

	
*merge 2009 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using pemphigus_namcs_2009.dta

	*drop the merge indicator
	drop _merge

	
*merge 2008 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using pemphigus_namcs_2008.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2007 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using pemphigus_namcs_2007.dta

	*drop the merge indicator
	drop _merge	
	
	
*merge 2006 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using pemphigus_namcs_2006.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2005 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8 using pemphigus_namcs_2005.dta

	*drop the merge indicator
	drop _merge

	
*merge 2004 to previous
*	differences: no "SPECCAT" variable
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED8 using pemphigus_namcs_2004.dta

	*drop the merge indicator
	drop _merge

	
*merge 2003 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED8 using pemphigus_namcs_2003.dta

	*drop the merge indicator
	drop _merge
	
	
*merge 2002 to previous
*	differences: only 6 meds
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED6 using pemphigus_namcs_2002.dta

	*drop the merge indicator
	drop _merge	

	
*merge 2001 to previous
merge 1:1 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED6 using pemphigus_namcs_2001.dta

	*drop the merge indicator
	drop _merge	

	
*merge 2000 to previous
*	differences: no SETTYPE variable
merge 1:1 	YEAR PATWT 														///
			DIAG1 DIAG2 DIAG3 														///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR 	///
			MED1-MED6 using pemphigus_namcs_2000.dta

	*drop the merge indicator
	drop _merge	
	
	
*save pemphigus_namcs_2015to1993, replace
