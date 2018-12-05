cls
clear

/*
This program will format select variables, which vary from year to year.

Keep relevant variables for Sharma (2007) analysis:
	Tables 1 & 2:		gender, age, race, insurance, region, setting, practice, provider
	Figure1:	proportion of visits
	Figure2:	proportions of topical medication Rxs provided during visits
		label define MEDCODF 09137 "PIMECROLIMUS"
		label define MEDCODF 97130 "TACROLIMUS"
		label define MEDCODF 94079 "CORTICOSTEROID(S)"

Formatted to 2015 variables:
	YEAR SETTYPE PATWT
	DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D
	ETOHAB ALZHD ARTHRTIS ASTHMA AUTISM CANCER CEBVD CKD COPD CHF CAD
	DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID HTN 
	OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
	SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT
	MED1-MED30
*/

*source folder where all the subset NAMCS datasets are in Stata .dta format
local source "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.0_Datasets_Subset"

*output folder where all the formatted NAMCS datasets will be created in Stata .dta format
local output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.1_Datasets_Formatted"


/* 
This is the 2015 dataset, 
which has the standard formats that will be used in analysis
	Comorbidity list: ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM 
		CANCER CEBVD CKD COPD CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE
		HIV HYPLIPID HTN OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
*/

*local macro subsetting dataset
local yeardata1	namcs2015  
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*format med variables with -9 as missing
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10 ///
				MED11 MED12 MED13 MED14 MED15 MED16 MED17 MED18 MED19 MED20 ///
				MED21 MED22 MED23 MED24 MED25 MED26 MED27 MED28 MED29 MED30
	foreach var in `meds'{
		replace `var' = . if `var' == -9
	}
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30																///
			ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM CANCER CEBVD		///
			CKD COPD CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID	///
			HTN OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
			
	order  	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30																///
			ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM CANCER CEBVD		///
			CKD COPD CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID	///
			HTN OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
		
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2014 dataset,
which has the following deviations from 2015 formatting:
	Comorbidities list: ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER 
		CEBVD CKD COPD CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV 
		HYPLIPID HTN OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON

 */

*local macro subsetting dataset
local yeardata1	namcs2014
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*format med variables with -9 as missing
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10 ///
				MED11 MED12 MED13 MED14 MED15 MED16 MED17 MED18 MED19 MED20 ///
				MED21 MED22 MED23 MED24 MED25 MED26 MED27 MED28 MED29 MED30
	foreach var in `meds'{
		replace `var' = . if `var' == -9
	}
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30																///
			ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CEBVD CKD COPD	///
			CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID HTN		///
			OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
			
	order  	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30																///
			ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CEBVD CKD COPD	///
			CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID HTN		///
			OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
		
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2013 dataset,
which has the following deviations from 2015 formatting:
	Only has 10 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Comorbidity list: ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CEBVD COPD CRF 
		CHF DEPRN DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

 */

*local macro subsetting dataset
local yeardata1	namcs2013

*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*format med variables with -9 as missing
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10
	foreach var in `meds'{
		replace `var' = . if `var' == -9
	}
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED10																///
			ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CEBVD COPD CRF CHF DEPRN		///
			DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

	order 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED10																///
			ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CEBVD COPD CRF CHF DEPRN		///
			DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2012 dataset,
which has the following deviations from 2015 formatting:
	Only has 10 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Comorbidity list: ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CASTAGE CEBVD COPD 
		CRF CHF DEPRN DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

*/

*local macro subsetting dataset
local yeardata1	namcs2012

*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*format med variables with -9 as missing
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10
	foreach var in `meds'{
		replace `var' = . if `var' == -9
	}
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR_14 SPECCAT	///
			MED1-MED10																///
			ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CASTAGE CEBVD COPD CRF CHF		///
			DEPRN DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

	*variables renamed in 2012
	rename (SPECR_14) (SPECR)

	order 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED10																///
			ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CASTAGE CEBVD COPD CRF CHF		///
			DEPRN DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
		
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}



/* 
This is the 2011, 2010, and 2009 datasets,
which has the following deviations from 2015 formatting:
	Only has 8 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Reformat OWNS variable to match 2015
	Reformat SPECR variable to match 2015
	Comorbidity list: ARTHRTIS ASTHMA CANCER CEBVD CRF CHF COPD DEPRN DIABETES 
		HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
		*note, 2010 has CASTAGE, but not really useful, so just skipping it
*/

*local macro subsetting dataset
local yeardata1	namcs2011 namcs2010 namcs2009
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*format med variables with -9 as missing
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8
	foreach var in `meds'{
		replace `var' = . if `var' == -9
	}
	
	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if OWNS == 1
	replace OWNSR = 3	if OWNS == 2
	replace OWNSR = 2	if OWNS == 3
	replace OWNSR = 2	if OWNS == 4
	replace OWNSR = 3	if OWNS == 5
	replace OWNSR = 3	if OWNS == 6
	replace OWNSR = 3	if OWNS == 7
	replace OWNSR = -9	if OWNS == -9
	
	*reformat extra "oncology" category of SPECR to "other category
	replace SPECR = 15	if SPECR == 16
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 													///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D							///
			SEX AGE AGER RACER RACERETH PAYTYPER REGION MSA OWNSR SPECR SPECCAT	///
			MED1-MED8															///
			ARTHRTIS ASTHMA CANCER CEBVD CRF CHF COPD DEPRN DIABETES HYPLIPID	///
			HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
			
	*variables renamed in 2012
	rename (REGION) (REGIONOFF)

	order  	YEAR SETTYPE PATWT 													///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D							///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED8															///
			ARTHRTIS ASTHMA CANCER CEBVD CRF CHF COPD DEPRN DIABETES HYPLIPID	///
			HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
		
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2008 dataset,
which has the following deviations from 2015 formatting:
	Only has 8 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Reformat OWNS variable to match 2015
	Reformat SPECR variable to match 2015
	Comorbidity list: 
/

*local macro subsetting dataset
local yeardata1	namcs2008  
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*format med variables with -9 as missing
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10 ///
				MED11 MED12 MED13 MED14 MED15 MED16 MED17 MED18 MED19 MED20 ///
				MED21 MED22 MED23 MED24 MED25 MED26 MED27 MED28 MED29 MED30
	foreach var in `meds'{
		replace `var' = . if `var' == -9
	}
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
			SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30																///
			
	order  	
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/*all other years
namcs2008 namcs2007 namcs2006 namcs2005 namcs2004 namcs2003
namcs2002 namcs2001 namcs2000 namcs1999 namcs1998 namcs1997 namcs1996 namcs1995
*/
