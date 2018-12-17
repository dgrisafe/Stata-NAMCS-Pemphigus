cls
clear

/*
This program will subset variables from years 1993 to 2015 based on a 3-digit ICD9 code.
To change the 3-digit ICD9 code,  replace any "694" with the desired code.
*/

*source folder where all the subset NAMCS datasets are in Stata .dta format
local source "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/0.1_Datasets_Merged"

*output folder where all the subset NAMCS datasets will be created in Stata .dta format
local output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/0.2_Datasets_PemphigusID"



*macro identifying the 3-digit ICD9 code

local ThreeD_ICD9 "694"

foreach code in `ThreeD_ICD9' {

	*clear loaded data
	clear
	
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use "namcs_2015to1995.dta"
	
	*add an indicator variable for cases or controls
	gen CACO = 0
	replace CACO = 1 if	strpos(DIAG13D, "`code'") | strpos(DIAG23D, "`code'") | strpos(DIAG33D, "`code'") | strpos(DIAG43D, "`code'") | strpos(DIAG53D, "`code'")
	label define CACOf	0 "Control" 1 "Case"
	label value CACO CACOf
	label var CACO "Case indicator variable"

	*change directory to where would like to save datasets
	cd "`output'"
	
	*organize variables in meaningful order
	order  	CACO YEAR SETTYPE PATWT 														///
			DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D			///
			SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
			s_MED1-s_MED30																	///
			ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM CANCER CASTAGE			///
			CEBVD CAD CHF CKD COPD CRF DEPRN DIABETES DIABTYP1 DIABTYP2 DIABTYP0			///
			ESRD HIV HPE HTN HYPLIPID IHD OBESITY OSA OSTPRSIS SUBSTAB						///
			NOCHRON TOTCHRON
	
	*save complete dataset of cases and controls, now with indicator variable
	save "namcs_2015to1995_ICD9_`code'.dta", replace
	
	*keep observations with diagnoses of Bullous dermatoses (694) 
	keep if	strpos(DIAG13D, "`code'") | strpos(DIAG23D, "`code'") | strpos(DIAG33D, "`code'") | strpos(DIAG43D, "`code'") | strpos(DIAG53D, "`code'")
				
	*save dataset of cases only
	save namcs_2015to1995_ICD9_`code'_CasesOnly, replace
		
}
