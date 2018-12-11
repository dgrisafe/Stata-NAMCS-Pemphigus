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
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30																///
			ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM CANCER CEBVD		///
			CKD COPD CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID	///
			HTN OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
					
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10 ///
				MED11 MED12 MED13 MED14 MED15 MED16 MED17 MED18 MED19 MED20 ///
				MED21 MED22 MED23 MED24 MED25 MED26 MED27 MED28 MED29 MED30
	foreach var in `meds'{
		*format med variables with -9 as missing
		replace `var' = . if `var' == -9
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
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
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED30																///
			ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CEBVD CKD COPD	///
			CHF CAD DEPRN DIABTYP1 DIABTYP2 DIABTYP0 ESRD HPE HIV HYPLIPID HTN		///
			OBESITY OSA OSTPRSIS SUBSTAB NOCHRON TOTCHRON
					
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10 ///
				MED11 MED12 MED13 MED14 MED15 MED16 MED17 MED18 MED19 MED20 ///
				MED21 MED22 MED23 MED24 MED25 MED26 MED27 MED28 MED29 MED30
	foreach var in `meds'{
		*format med variables with -9 as missing
		replace `var' = . if `var' == -9
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
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
	
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			MED1-MED10																///
			ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CEBVD COPD CRF CHF DEPRN		///
			DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10
	foreach var in `meds'{
		*format med variables with -9 as missing
		replace `var' = . if `var' == -9
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
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
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR_14 SPECCAT	///
			MED1-MED10																///
			ARTHRTIS ASTHMA ASTH_SEV ASTH_CON CANCER CASTAGE CEBVD COPD CRF CHF		///
			DEPRN DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

	*variables renamed in 2012
	rename (SPECR_14) (SPECR)

	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  MED9  MED10
	foreach var in `meds'{
		*format med variables with -9 as missing
		replace `var' = . if `var' == -9
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
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
	
	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if OWNS == 1
	replace OWNSR = 3	if OWNS == 2
	replace OWNSR = 2	if OWNS == 3
	replace OWNSR = 2	if OWNS == 4
	replace OWNSR = 3	if OWNS == 5
	replace OWNSR = 3	if OWNS == 6
	replace OWNSR = -8	if OWNS == 7
	replace OWNSR = -9	if OWNS == -9
	
	*reformat extra "oncology" category of SPECR to "other category
	replace SPECR = 15	if SPECR == 16
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 													///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D							///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR SPECCAT	///
			MED1-MED8															///
			ARTHRTIS ASTHMA CANCER CEBVD CRF CHF COPD DEPRN DIABETES HYPLIPID	///
			HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
			
	*variables renamed in 2012
	rename (REGION) (REGIONOFF)

	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8
	foreach var in `meds'{
		*format med variables with -9 as missing
		replace `var' = . if `var' == -9
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2008 dataset,
which has the following deviations from 2015 formatting:
	Only has 8 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Reformat RACEETH, OWNS, SPECR variables to match 2015
	Comorbidity list: ARTHRTIS ASTHMA CANCER CASTAGE CEBVD CHF CRF COPD DEPRN 
		DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
*/

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
	
	*RACEETH needs to be reformatted to 2015 variable RACERETH
	gen RACERETH = .
	replace RACERETH = 1 if RACEETH == 1
	replace RACERETH = 2 if RACEETH == 2
	replace RACERETH = 3 if RACEETH == 3
	replace RACERETH = 4 if RACEETH == 4
	replace RACERETH = 4 if RACEETH == 5
	replace RACERETH = 4 if RACEETH == 6
	replace RACERETH = 4 if RACEETH == 7

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if OWNS == 1
	replace OWNSR = 3	if OWNS == 2
	replace OWNSR = 2	if OWNS == 3
	replace OWNSR = 2	if OWNS == 4
	replace OWNSR = 3	if OWNS == 5
	replace OWNSR = 3	if OWNS == 6
	replace OWNSR = -8	if OWNS == 7
	replace OWNSR = -9	if OWNS == -9
	
	*reformat extra "oncology" category of SPECR to "other category
	replace SPECR = 15	if SPECR == 16	
	
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR SPECCAT		///
			MED1-MED8																///
			ARTHRTIS ASTHMA CANCER CASTAGE CEBVD CHF CRF COPD DEPRN 				///
			DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

	*variables renamed in 2008
	rename (REGION) (REGIONOFF)
			
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8
	foreach var in `meds'{
		*format med variables with -9 as missing
		replace `var' = . if `var' == -9
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2007 datasets,
which has the following deviations from 2015 formatting:
	Only has 8 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Reformat RACEETH, PAYTYPE, OWNS, SPECR variables to match 2015
	Comorbidity list: ARTHRTIS ASTHMA CANCER CASTAGE CEBVD CHF CRF COPD DEPRN 
		DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
*/


*local macro subsetting dataset
local yeardata1	namcs2007 
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*RACEETH needs to be reformatted to 2015 variable RACERETH
	gen RACERETH = .
	replace RACERETH = 1 if RACEETH == 1
	replace RACERETH = 2 if RACEETH == 2
	replace RACERETH = 3 if RACEETH == 3
	replace RACERETH = 4 if RACEETH == 4
	replace RACERETH = 4 if RACEETH == 5
	replace RACERETH = 4 if RACEETH == 6
	replace RACERETH = 4 if RACEETH == 7
	
	*PAYTYPE recoded to match 2015 variable PAYTYPER
	replace PAYTYPE = -9 if PAYTYPE == 0

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if OWNS == 1
	replace OWNSR = 3	if OWNS == 2
	replace OWNSR = 2	if OWNS == 3
	replace OWNSR = 2	if OWNS == 4
	replace OWNSR = 3	if OWNS == 5
	replace OWNSR = 3	if OWNS == 6
	replace OWNSR = -8	if OWNS == 7
	replace OWNSR = -9	if OWNS == -9
	
	*reformat extra "oncology" category of SPECR to "other category
	replace SPECR = 15	if SPECR == 16	
	
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPE REGION MSA OWNSR SPECR SPECCAT		///
			MED1-MED8																///
			ARTHRTIS ASTHMA CANCER CASTAGE CEBVD CHF CRF COPD DEPRN 				///
			DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

	*variables renamed in 2007
	rename (REGION PAYTYPE) (REGIONOFF PAYTYPER)
			
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8
	foreach var in `meds'{
		*format med variables with -9 as missing
		replace `var' = . if `var' == -9
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2006 datasets,
which has the following deviations from 2015 formatting:
	Only has 8 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Reformat RACEETH, PAYTYPE, OWNS, SPECR variables to match 2015
	Comorbidity list: ARTHRTIS ASTHMA CANCER CASTAGE CEBVD CHF CRF COPD DEPRN 
		DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON
*/


*local macro subsetting dataset
local yeardata1	namcs2006
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*RACEETH needs to be reformatted to 2015 variable RACERETH
	gen RACERETH = .
	replace RACERETH = 1 if RACEETH == 1
	replace RACERETH = 2 if RACEETH == 2
	replace RACERETH = 3 if RACEETH == 3
	replace RACERETH = 4 if RACEETH == 4
	replace RACERETH = 4 if RACEETH == 5
	replace RACERETH = 4 if RACEETH == 6
	replace RACERETH = 4 if RACEETH == 7
	
	*PAYTYPE recoded to match 2015 variable PAYTYPER
	replace PAYTYPE = -9 if PAYTYPE == 0

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if OWNS == 1
	replace OWNSR = 3	if OWNS == 2
	replace OWNSR = 2	if OWNS == 3
	replace OWNSR = 2	if OWNS == 4
	replace OWNSR = 3	if OWNS == 5
	replace OWNSR = 3	if OWNS == 6
	replace OWNSR = -8	if OWNS == 7
	replace OWNSR = -9	if OWNS == -9
	
	*reformat extra "oncology" category of SPECR to "other category
	replace SPECR = 15	if SPECR == 16	
	
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D								///
			SEX AGE AGER RACER RACERETH RACE PAYTYPE REGION MSA OWNSR SPECR SPECCAT		///
			MED1-MED8																///
			ARTHRTIS ASTHMA CANCER CASTAGE CEBVD CHF CRF COPD DEPRN 				///
			DIABETES HYPLIPID HTN IHD OBESITY OSTPRSIS NOCHRON TOTCHRON

	*variables renamed in 2006
	rename (REGION PAYTYPE RACE) (REGIONOFF PAYTYPER RACEUN)
			
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8
	foreach var in `meds'{
		*format med variables with 90000 as missing
		replace `var' = . if `var' == 90000
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2005 dataset,
which has the following deviations from 2015 formatting:
	ALL variables were in lowercase; made uppercase
	Only has 8 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D 
	Reformat raceeth, paytype, region, owns variables to match 2015
	Comorbidity list: arthrtis asthma cancer chf crf copd cebvd hyplipid deprn
		diabetes htn ihd obesity ostprsis nochron totchron
*/

*local macro subsetting dataset
local yeardata1	namcs2005
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*RACEETH needs to be reformatted to 2015 variable RACERETH
	gen RACERETH = .
	replace RACERETH = 1 if raceeth == 1
	replace RACERETH = 2 if raceeth == 2
	replace RACERETH = 3 if raceeth == 3
	replace RACERETH = 4 if raceeth == 4
	replace RACERETH = 4 if raceeth == 5
	replace RACERETH = 4 if raceeth == 6
	replace RACERETH = 4 if raceeth == 7
	
	*PAYTYPE recoded to match 2015 variable PAYTYPER
	replace paytype = -9 if paytype == 0

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if owns == 1
	replace OWNSR = 3	if owns == 2
	replace OWNSR = 2	if owns == 3
	replace OWNSR = 2	if owns == 4
	replace OWNSR = 3	if owns == 5
	replace OWNSR = -8	if owns == 6
	
	*Keep all variables for weights
	keep 	year settype patwt 														///
			diag1 diag13d diag2 diag23d diag3 diag33d 								///
			sex age ager racer RACERETH race paytype region msa OWNSR specr speccat		///
			med1-med8																///
			arthrtis asthma cancer chf crf copd cebvd hyplipid deprn				///
			diabetes htn ihd obesity ostprsis nochron totchron

	*variables renamed in 2005
	rename (region paytype race) (REGIONOFF PAYTYPER RACEUN)
	
	*rename all variables uppercase
	rename *, upper
		
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8  
	foreach var in `meds'{
		*format med variables with 90000 as missing
		replace `var' = . if `var' == 90000
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace

}


/* 
This is the 2004  and 2003 datasets,
which has the following deviations from 2015 formatting:
	ALL variables were in lowercase; made uppercase
	Only has 8 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D SPECCAT 
	Reformat paytype, region, owns variables to match 2015
	Derive RACERETH from ethnic and racer variables
	Comorbidity list: There's no comorbidity list in 2004
*/

*local macro subsetting dataset
local yeardata1	namcs2004 namcs2003
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'

	*RACEETH needs to be derived from ethnic and racer to 2015 variable RACERETH
	gen RACERETH = .
	replace RACERETH = 1 if racer 	== 1 & ethnic == 2
	replace RACERETH = 2 if racer 	== 2 & ethnic == 2
	replace RACERETH = 3 if ethnic 	== 1
	replace RACERETH = 4 if racer 	== 3 & ethnic == 2
	replace RACERETH = . if ethnic 	== 0
	
	*PAYTYPE recoded to match 2015 variable PAYTYPER
	replace paytype = -9 if paytype == 0

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if owns == 1
	replace OWNSR = 3	if owns == 2
	replace OWNSR = 2	if owns == 3
	replace OWNSR = 2	if owns == 4
	replace OWNSR = 3	if owns == 5
	replace OWNSR = -8	if owns == 6
		
	*Keep all variables for weights
	keep 	year settype patwt 														///
			diag1 diag13d diag2 diag23d diag3 diag33d 								///
			sex age ager racer RACERETH race paytype region msa OWNSR specr 				///
			med1-med8

	*variables renamed in 2004
	rename (region paytype race) (REGIONOFF PAYTYPER RACEUN)
			
	*rename all variables uppercase
	rename *, upper

	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  MED7  MED8
	foreach var in `meds'{
		*format med variables with 90000 as missing
		replace `var' = . if `var' == 90000
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}



/* 
This is the 2002 dataset,
which has the following deviations from 2015 formatting:
	ALL variables were in lowercase; made uppercase
	Only has 6 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D SPECCAT 
	Reformat paytype, region, owns variables to match 2015
	Derive RACERETH from ethnic and racer variables
	MED variables were already strings, did not have to convert
	Comorbidity list: There's no comorbidity list in 2002
*/

*local macro subsetting dataset
local yeardata1	namcs2002
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'

	*RACEETH needs to be derived from ethnic and racer to 2015 variable RACERETH
	gen RACERETH = .
	*non-Hispanic White
	replace RACERETH = 1 if racer 	== 1 & ethnic == 2
	*non-Hispanic Black
	replace RACERETH = 2 if racer 	== 2 & ethnic == 2
	*Hispanic
	replace RACERETH = 3 if ethnic 	== 1
	*non-Hispanic Other
	replace RACERETH = 4 if racer 	== 3 & ethnic == 2
	*missing
	replace RACERETH = . if ethnic 	== 0
	
	*PAYTYPE recoded to match 2015 variable PAYTYPER
	replace paytype = -9 if paytype == 0
	replace paytype = -8 if paytype == 8

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if owns == 1
	replace OWNSR = 3	if owns == 2
	replace OWNSR = 2	if owns == 3
	replace OWNSR = 2	if owns == 4
	replace OWNSR = 3	if owns == 5
	replace OWNSR = -8	if owns == 6
		
	*Keep all variables for weights
	keep 	year settype patwt 														///
			diag1 diag13d diag2 diag23d diag3 diag33d 								///
			sex age ager racer RACERETH race paytype region msa OWNSR specr 		///
			med1-med6

	*variables renamed
	rename (region paytype race) (REGIONOFF PAYTYPER RACEUN)
			
	*rename all variables uppercase
	rename *, upper

	*format medication variables so consistient with format from year to year
	*	NOTE: med variables already strings
	local meds	MED1  MED2  MED3  MED4  MED5  MED6
	foreach var in `meds'{
		*format med variables with 90000 as missing
		replace `var' = "" if `var' == "90000"
		*rename variable to follow format
		generate s_`var' = `var' 
		*drop categorical labeled variable
		drop `var'
	}
	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}



/* 
This is the 2001 dataset,
which has the following deviations from 2015 formatting:
	Only has 6 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D SPECCAT 
	Reformat paytype, region, owns variables to match 2015
	Derive RACERETH from ethnic and racer variables
	Comorbidity list: There's no comorbidity list in 2001
*/

*local macro subsetting dataset
local yeardata1	namcs2001
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'

	
	*RACEETH needs to be derived from ethnic and racer to 2015 variable RACERETH
	gen RACERETH = .
	*non-Hispanic White
	replace RACERETH = 1 if RACER 	== 1 & ETHNIC == 2
	*non-Hispanic Black
	replace RACERETH = 2 if RACER 	== 2 & ETHNIC == 2
	*Hispanic
	replace RACERETH = 3 if ETHNIC 	== 1
	*non-Hispanic Other
	replace RACERETH = 4 if RACER 	== 3 & ETHNIC == 2
	*missing
	replace RACERETH = . if ETHNIC 	== 0
	
	*PAYTYPE recoded to match 2015 variable PAYTYPER
	replace PAYTYPE = -9 if PAYTYPE == 0
	replace PAYTYPE = -8 if PAYTYPE == 8

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	replace OWNSR = 1	if OWNS == 1
	replace OWNSR = 3	if OWNS == 2
	replace OWNSR = 2	if OWNS == 3
	replace OWNSR = 2	if OWNS == 4
	replace OWNSR = 3	if OWNS == 5
	replace OWNSR = -8	if OWNS == 6
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D 								///
			SEX AGE AGER RACER RACERETH RACE PAYTYPE REGION MSA OWNSR SPECR 		///
			MED1-MED6

	*variables renamed in 2004
	rename (REGION PAYTYPE RACE) (REGIONOFF PAYTYPER RACEUN)
			
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  
	foreach var in `meds'{
		*format med variables with 90000 as missing
		replace `var' = . if `var' == 90000
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 2000 to 1997 datasets,
which has the following deviations from 2015 formatting:
	Only has 6 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D SPECCAT SETTYPE
	Reformat paytype, region, owns variables to match 2015
	ETHNIC formatted differently from 2001 dataset
	Derive RACERETH from ethnic and racer variables
	Comorbidity list: There's no comorbidity list in 2001
*/

*local macro subsetting dataset
local yeardata1	namcs2000 namcs1999 namcs1998 namcs1997
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*make SETTYPE variable (== 1 for all NAMCS data)
	gen SETTYPE = 1
	
	*for 1999, rename URBAN to MSA
	if (YEAR == 1999 | YEAR == 1998 | YEAR == 1997) {
		rename URBAN MSA
	}

	
	*RACEETH needs to be derived from ethnic and racer to 2015 variable RACERETH
	gen RACERETH = .
	*missing
	replace RACERETH = . if ETHNIC 	== 3
	*non-Hispanic White
	replace RACERETH = 1 if RACER 	== 1 & ETHNIC != 1
	*non-Hispanic Black
	replace RACERETH = 2 if RACER 	== 2 & ETHNIC != 1
	*Hispanic
	replace RACERETH = 3 if ETHNIC 	== 1
	*non-Hispanic Other
	replace RACERETH = 4 if RACER 	== 3 & ETHNIC != 1
	
	*PAYTYPE recoded to match 2015 variable PAYTYPER
	replace PAYTYPE = -9 if PAYTYPE == 9
	replace PAYTYPE = -8 if PAYTYPE == 8

	*reformat OWNS variable to match 2015 OWNSR variable
	gen OWNSR = .
	*physician or physician group
	replace OWNSR = 1	if OWNER == 2
	*Medical/academic health center; community health center; other hospital
	replace OWNSR = 2	if OWNER == 1
	*Insurance company, health plan, or HMO; other health corporation; other
	replace OWNSR = 3	if OWNER == 3 | OWNER == 4 | OWNER == 5
	*blank
	replace OWNSR = -9	if OWNER == 6
		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D 								///
			SEX AGE AGER RACER RACERETH RACE ETHNIC PAYTYPE REGION MSA OWNSR SPECR 		///
			MED1-MED6

	*variables renamed in 2004
	rename (REGION PAYTYPE RACE) (REGIONOFF PAYTYPER RACEUN)
			
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  
	foreach var in `meds'{
		*format med variables with 90000 as missing
		replace `var' = . if `var' == 90000
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}

	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* 
This is the 1996 to 1995 datasets,
which has the following deviations from 2015 formatting:
	Only has 6 positions for meds
	Does not have: DIAG4 DIAG43D DIAG5 DIAG53D SPECCAT SETTYPE
	Reformat paytype, region, owns variables to match 2015
	ETHNIC formatted differently from 2001 dataset
	Derive RACERETH from ethnic and racer variables
	Comorbidity list: There's no comorbidity list
	There's no PAYTYPER variable, but several indicator variables 
		to derive the PAYTYPER variable from.
	There's no OWNSR variable; cannot derive.	
*/

*local macro subsetting dataset
local yeardata1	namcs1996 namcs1995
	
*Loop formatting data
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
	
	*make SETTYPE variable (== 1 for all NAMCS data)
	gen SETTYPE = 1

	*replace urban variable to MSA
	rename URBAN MSA
	
	*RACEETH needs to be derived from ethnic and racer to 2015 variable RACERETH
	gen RACERETH = .
	*missing
	replace RACERETH = . if ETHNIC 	== 3
	*non-Hispanic White
	replace RACERETH = 1 if RACER 	== 1 & ETHNIC != 1
	*non-Hispanic Black
	replace RACERETH = 2 if RACER 	== 2 & ETHNIC != 1
	*Hispanic
	replace RACERETH = 3 if ETHNIC 	== 1
	*non-Hispanic Other
	replace RACERETH = 4 if RACER 	== 3 & ETHNIC != 1
	
	*TYPEPAY and coverage indicator variables recoded to match 2015 variable PAYTYPER
	gen PAYTYPE = .
	
		*Blank
		replace PAYTYPE = -9 	if TYPEPAY == 0
		*Other
		replace PAYTYPE = 7 	if TYPEPAY == 6 | OTHINS == 1
		*Unknown
		replace PAYTYPE = -8 	if TYPEPAY == 7 | UNKINS ==1
		
		*Private insurance (PPO, Fee-for-service, HMO
		replace PAYTYPE = 1 	if TYPEPAY == 1 | TYPEPAY == 2 | TYPEPAY == 3 | BCBS == 1 | OTHPRIV == 1
		*Medicare
		replace PAYTYPE = 2 	if MEDICARE == 1
		*Medicaid
		replace PAYTYPE = 3 	if MEDICAID == 1
		*Worker's comp
		replace PAYTYPE = 4 	if WORKCOMP == 1
		*Self-pay
		replace PAYTYPE = 5 	if TYPEPAY == 4
		*No charge/charity
		replace PAYTYPE = 6 	if TYPEPAY == 5

		
	*Keep all variables for weights
	keep 	YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D 								///
			SEX AGE AGER RACER RACERETH RACE ETHNIC PAYTYPE REGION MSA SPECR 		///
			MED1-MED6

	*variables renamed in 2004
	rename (REGION PAYTYPE RACE) (REGIONOFF PAYTYPER RACEUN)
			
	*format medication variables so consistient with format from year to year
	local meds	MED1  MED2  MED3  MED4  MED5  MED6  
	foreach var in `meds'{
		*format med variables with 90000 as missing
		replace `var' = . if `var' == 90000
		*convert to string
		decode `var', generate(s_`var')
		*drop categorical labeled variable
		drop `var'
	}

	
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/*all other years
namcs2002 namcs2001 namcs2000 namcs1999 namcs1998 namcs1997 namcs1996 namcs1995
*/
