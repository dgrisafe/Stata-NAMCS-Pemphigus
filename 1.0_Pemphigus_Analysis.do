cls
clear

/*
This program will perform the analysis similar to Hori 2015

Formatted to 2015 variables:
	YEAR SETTYPE PATWT
	DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D
	SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT
	s_MED1-s_MED30
	ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM CANCER CASTAGE
	CEBVD CAD CHF CKD COPD CRF DEPRN DIABETES DIABTYP1 DIABTYP2 DIABTYP0
	ESRD HIV HPE HTN HYPLIPID IHD OBESITY OSA OSTPRSIS SUBSTAB
	NOCHRON TOTCHRON
*/

*source folder where the merged NAMCS dataset is in Stata .dta format
local source "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.2_Datasets_Merged"

*output folder where analysis Figures and Tables output will be stored
local dat_output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.3_Datasets_Analysis"

*output folder where analysis Figures and Tables output will be stored
local fig_output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Figures & Tables/0.3_FiguresTables_Analysis"

*change to output directory for all analysis
cd "`source'"

*load merged, clean dataset
use "namcs_2015to1993.dta"

	
/*
Exploratory data analysis & Formatting
*/

*change to output directory for datasets with new derived variables
cd "`dat_output'"

*make case id, useful for further analyses
gen ptid = _n

*indicator variable to see whether diagnosed with Bullous dermatoses (694)
gen pemphind = 0
replace pemphind = 1 if	DIAG13D == "694" | DIAG23D == "694" | DIAG33D == "694" | DIAG43D == "694" | DIAG53D == "694"

*indicator variable to see whether diagnosed with Pemphigus (694.4), Pemphigoid (694.5), or Unspecified bullous dermatoses (694.9)
gen pemphcat = .
	*Dermatitis herpetiformis (694.0)
		replace pemphcat = 0 if	DIAG1 == "6940-" | DIAG2 == "6940-" | DIAG3 == "6940-" | DIAG4 == "6940-" | DIAG5 == "6940-"
	*Pemphigus (694.4)
		replace pemphcat = 4 if	DIAG1 == "6944-" | DIAG2 == "6944-" | DIAG3 == "6944-" | DIAG4 == "6944-" | DIAG5 == "6944-"
	*Pemphigoid (694.5)
		replace pemphcat = 5 if	DIAG1 == "6945-" | DIAG2 == "6945-" | DIAG3 == "6945-" | DIAG4 == "6945-" | DIAG5 == "6945-"
	*Benign mucous membrane pemphigoid without mention of ocular involvement (694.6)
		replace pemphcat = 60 if	DIAG1 == "69460" | DIAG2 == "69460" | DIAG3 == "69460" | DIAG4 == "69460" | DIAG5 == "69460"
	*Benign mucous membrane pemphigoid with ocular involvement (694.61)
		replace pemphcat = 61 if	DIAG1 == "69461" | DIAG2 == "69461" | DIAG3 == "69461" | DIAG4 == "69461" | DIAG5 == "69461"
	*Unspecified bullous dermatoses (694.8)
		replace pemphcat = 8 if	DIAG1 == "6948-" | DIAG2 == "6948-" | DIAG3 == "6948-" | DIAG4 == "6948-" | DIAG5 == "6948-"
	*Unspecified bullous dermatoses (694.9)
		replace pemphcat = 9 if	DIAG1 == "6949-" | DIAG2 == "6949-" | DIAG3 == "6949-" | DIAG4 == "6949-" | DIAG5 == "6949-"

*format
label define pemphcatf	0 "(694.0) Dermatitis herpetiformis"													///
						4 "(694.4) Pemphigus"																	///
						5 "(694.5) Pemphigoid"																	///
						60 "(694.60) Benign mucous membrane pemphigoid without mention of ocular involvement"	///
						61 "(694.61) Benign mucous membrane pemphigoid with ocular involvement"					///
						8 "(694.8) Other specified bullous dermatoses"											///
						9 "(694.9) Unspecified bullous dermatoses"
label value pemphcat pemphcatf
		
*look at 				
tab pemphcat

save "namcs_2015to2003_anal.dta", replace


/*
Table 1 - Sociodemographics
/

*change to output directory for analysis figures and tables
cd "`fig_output'"

*look at histogram of age
histogram AGE, frequency
sum AGE, detail

*all sociodemographic variables in table 1
local table1 SEX AGER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR

*for loop showing summed patient weights for each variable
foreach sdem in `table1' {

	*get sum of patient weight (PATWT) by sociodemographic variables
	total PATWT, over(`sdem')
	*show number of observations by sociodemographic variables
	bysort `sdem': sum PATWT, vsquish
	
	*corresponding graphs
	graph hbar (percent) PATWT, over(`sdem', label(labsize(small) angle(45) ticks))	///
	blabel(bar, format(%9.1f))										///
	title("Percent of Total Patient Weight by `sdem'") 				///
	ytitle("Percent of Patient Weight")								///
	ylabel(0(25)100) ymticks(0(10)100)
	*save graph
	graph export "EDA_`sdem'.png", replace
}
*/

/*
Figure 1 - table of summed patient weights by year, with 95% confidence intervals
See Figure 1 (Davis 2015)
*/

*data to be used to make a line plot in excel
total PATWT, over(YEAR)


/* 
reshape diagnosis data from wide to long 
https://stats.idre.ucla.edu/stata/modules/reshaping-data-wide-to-long/
*/

*change to output directory for all analysis
cd "`dat_output'"

*load original wide dataset
use "namcs_2015to2003_anal.dta"

*look at data in wide form
list ptid DIAG1 DIAG2 DIAG3 DIAG4 DIAG5

*reshape to long data
reshape long DIAG, i(ptid) j(dxid) 

*look at most common comorbidities (IGNORE any pemphigus diagnoses)
tab DIAG, sort

*save long dataset
save "namcs_2015to1993_anal_LongDiag.dta", replace


/* 
reshape medications prescribed data from wide to long 
https://stats.idre.ucla.edu/stata/modules/reshaping-data-wide-to-long/
*/

*load analytical wide dataset
use "namcs_2015to2003_anal.dta"

*look at data in wide form
list ptid s_MED1-s_MED30

*reshape to long data
reshape long s_MED, i(ptid) j(medid) 

*look at most common comorbidities
tab s_MED, sort

*generate indicator variable for 694 Primary reason for visit 
*	(i.e. 694 in first diagnosis position)
gen diag1694 = 0
replace diag1694 = 1 if DIAG13D == "694"

*look at most common comorbidities
tab s_MED if diag1694 == 1, sort

*save long dataset
save "namcs_2015to1993_anal_LongMeds.dta", replace


/*
Pierce's notes for running logistics in NAMCS

	*generate pooled weight by XX number of years summed together (specific to NAMCS)
	gen poolwt = PATWT/12

	*preparation for survey sampled logistic regression
	*https://stats.idre.ucla.edu/stata/faq/how-do-i-use-the-stata-survey-svy-commands/
	svyset CPSUM [pweight=poolwt], strata(CSTRATM)

	*actually run the regression
	svy: logistic y x1 x2 x3
	tab RACER
*/

*use wide analytical dataset for regression analysis
cd "`dat_output'"
use "namcs_2015to2003_anal.dta"

*load directory for output
cd "`fig_output'"
