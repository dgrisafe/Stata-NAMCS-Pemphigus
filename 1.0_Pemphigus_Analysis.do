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


*Reformat Table 1 variables as they were in Horii 2007, 
*	while obeying Cochran's Rule (5 observations per category)

**GENDER, DERIVED**

	*Gender (male)
	gen gender = .
	replace gender = 0 if SEX == 1
	replace gender = 1 if SEX == 2
	label define genderf 0 "Female" 1 "Male"
	label value gender genderf
	label variable gender "Gender"
	tab gender
	

**AGE CATEGORIZED, DERIVED**

	*look at age variables (AGE, AGER) in original NAMCS categories
	
	*look at histogram of age
*	histogram AGE, frequency name(histogram_AGE, replace)
	sum AGE, detail	
	
	*Age categorized
	gen agecat = .
	replace agecat = 0 if AGE < 10
	replace agecat = 1 if AGE >=10 & AGE < 20
	replace agecat = 2 if AGE >=20 & AGE < 30
	replace agecat = 3 if AGE >=30 & AGE < 40
	replace agecat = 4 if AGE >=40 & AGE < 50
	replace agecat = 5 if AGE >=50 & AGE < 60
	replace agecat = 6 if AGE >=60 & AGE < 70
	replace agecat = 7 if AGE >=70 & AGE < 80
	replace agecat = 8 if AGE >=80 & AGE < 90
	replace agecat = 9 if AGE >= 90
	label define agecatf	0 "< 10"		///
							1 "teenager"		///
							2 "20's"		///
							3 "30's"		///
							4 "40's"		///
							5 "50's"		///
							6 "60's"		///
							7 "70's"		///
							8 "80's"		///
							9 "≥ 90"
	label value agecat agecatf
	label variable agecat "Age (years)"
	
	*age categorized so at least 5 observations in each category
	gen agecat5 = .
	replace agecat5 = 0 if AGE < 50
	replace agecat5 = 1 if AGE >=50 & AGE < 60
	replace agecat5 = 2 if AGE >=60 & AGE < 70
	replace agecat5 = 3 if AGE >=70 & AGE < 80
	replace agecat5 = 4 if AGE >=80 & AGE < 90
	replace agecat5 = 5 if AGE >= 90
	label define agecat5f	0 "< 50"		///
							1 "50-60"		///
							2 "60-70"		///
							3 "70-80"		///
							4 "80-90"		///
							5 "≥ 90"
	label value agecat5 agecat5f
	label variable agecat "Age (years)"
	tab agecat5
	
	
**RACE, DERIVED**
	
	*look at race variables (RACERF, RACERETHF, RACEUNF) in original NAMCS categories
	tab RACER
	tab RACERETH
	tab RACEUN
	
	/* look at formatting of NAMCS race variables
	
	RACER
	label define RACERF 1 "White"  
	label define RACERF 2 "Black" , add
	label define RACERF 3 "Other" , add

	RACERETH
	label define RACERETHF 1 "Non-Hispanic White"
	label define RACERETHF 2 "Non-Hispanic Black" , add
	label define RACERETHF 3 "Hispanic" , add
	label define RACERETHF 4 "Non-Hispanic Other" , add

	RACEUN
	label define RACEUNF 1 "White Only"  
	label define RACEUNF 2 "Black/African American Only" , add
	label define RACEUNF 3 "Asian Only" , add
	label define RACEUNF 4 "Native Hawaiian/Oth Pac Isl Only" , add
	label define RACEUNF 5 "American Indian/Alaska Native Only" , add
	label define RACEUNF 6 "More than one race reported" , add
	label define RACEUNF -9 "Blank" , add
	*/

	*look at RACER by RACERETH
	tab RACER RACERETH

	*Race
	gen race = .
	*White
	replace race = 0 if RACER == 1 & RACERETH == 1
	*Black
	replace race = 2 if RACER == 2 & RACERETH == 2
	*Hispanic
	replace race = 1 if RACER == 1 & RACERETH == 3	
	*Asian or Pacific Islander
	replace race = 3 if RACER == 3 & RACERETH == 4 & (RACEUN == 3 | RACEUN == 4)
	*American Indian/Alaska Native Only
	replace race = 4 if RACER == 3 & RACERETH == 4 & RACEUN == 5
	*Other
	replace race = 5 if RACER == 3 & RACERETH == 4 & (RACEUN != 3 & RACEUN != 4 & RACEUN != 5) 
	label define racef	0 "White"								///
						2 "Black"								///
						1 "Hispanic"							///
						3 "Asian or Pacific Islander"			///
						4 "American Indian/Alaska Native Only"	///
						5 "Other"
	label value race racef
	label variable race "Race"
*	graph bar (count),						///
*		over(race, label(tick angle(15)))	///
*		blabel(bar, format(%9.1f)) name(bar_race, replace)
	*look at race variable compared to original variables
	tab race
	
	*Race - white/not-white
	*	Do this because a lot of the categories have less than 5 observations,
	*		which violates Cochran's rule of ≥ 5 observations per category 
	*		in statistical tests
	gen white = .
	*White Only
	replace white = 1 if RACERETH != 1
	*Not-White
	replace white = 0 if RACER == 1 & RACERETH == 1
	label define whitef	1 "Not White"	///
						0 "White, Only"
	label value white whitef
	label variable white "Race White or not white"
	tab white
	
	*look at white variable vs race variables
	tab white race

	
**INSURANCE, DERIVED**	

	*look at the payment method (PAYTYPER) in original NAMCS categories
	tab PAYTYPER
	
	/* look at formatting of NAMCS PAYTYPER variable
	
	label define PAYTYPERF 1 "Private insurance"  
	label define PAYTYPERF 2 "Medicare" , add
	label define PAYTYPERF 3 "Medicaid, CHIP or other state-based program" , add
	label define PAYTYPERF 4 "Worker's compensation" , add
	label define PAYTYPERF 5 "Self-pay" , add
	label define PAYTYPERF 6 "No charge/Charity" , add
	label define PAYTYPERF 7 "Other" , add
	label define PAYTYPERF -8 "Unknown" , add
	label define PAYTYPERF -9 "All sources of payment are blank" , add	
	*/
	
	*Insurance
	gen insur = .
	*Government: Medicare, Medicaid
	replace insur = 0 if PAYTYPER == 2 | PAYTYPER == 3
	*Commercial: Private Insurance, Worker's Compensation
	replace insur = 1 if PAYTYPER == 1 | PAYTYPER == 4
	*Other: Self-pay, No charge/Charity, Other, Unknown, All Sources Left Blank
	replace insur = 2 if PAYTYPER == 5 | PAYTYPER == 6 | PAYTYPER == 7 | PAYTYPER == -8 | PAYTYPER == -9
	label define insurf  0 "Government" 1 "Commercial" 2 "Other"
	label value insur insurf
	label var insur "Payment method"
	tab insur


**REGION, DERIVED**	

	*look at region (REGIONOFF) in original NAMCS categories
	tab REGIONOFF
	
	/* look at formatting of NAMCS REGIONOFF variable

	label define REGIONF 1 "Northeast"  
	label define REGIONF 2 "Midwest" , add
	label define REGIONF 3 "South" , add
	label define REGIONF 4 "West" , add
	*/
	
	*REGIONOFF is okay; there are sufficient observations in each regional category.
	*	need to rename and relabel to make clean graph
	gen region = .
	replace region = REGIONOFF
	label define regf 1 "Northeast" 2 "Midwest" 3 "South" 4 "West"
	label value region regf
	label var region "Region where majority of physician's sampled visits occurred"
	tab region
	
**SETTING (MSA), DERIVED**

	*look at setting (MSA) in original NAMCS categories
	tab MSA

	/* look at formatting of NAMCS MSA variable
	
	label define MSAF 1 "MSA (Metropolitan Statistical Area)"
	label define MSAF 2 "Non-MSA" , add
	*/
	
	*MSA is okay; there are sufficient observations in each setting category.
	*	need to rename and relabel to make clean graph
	gen setting = .
	replace setting = MSA
	label define setf 1 "Urban" 2 "Nonurban"
	label value setting setf
	label var setting "Metropolitan Statistical Area - Status of physician location"
	tab setting
	
**PRACTICE (OWNSR), DERIVED**

	*look at practice (OWNSR) in original NAMCS categories
	tab OWNSR

	/* look at formatting of NAMCS OWNSR variable	

	label define OWNSRF 1 "Physician or physician group"  
	label define OWNSRF 2 "Medical/academic health center; Community health center; other hospital" , add
	label define OWNSRF 3 "Insurance company, health plan, or HMO; other health corporation; other" , add
	label define OWNSRF -6 "Refused to answer" , add
	label define OWNSRF -8 "Unknown" , add
	label define OWNSRF -9 "Blank" , add
	*/

	*practice
	gen practice = .
	*Physician Office: Physician or physician group
	replace practice = 0 if OWNSR == 1
	*Hospital: Medical/academic health center; Community health center; other hospital
	replace practice = 1 if OWNSR == 2
	*Health Corporation: Insurance company, health plan, or HMO; other health corporation; other
	replace practice = 2 if OWNSR == 3
	*Unknown: Unknown
	replace practice = 3 if OWNSR == -8
	label define pracf 0 "Physician Office" 1 "Hospital" 2 "Health Corporation" 3 "Unknown"
	label value practice pracf
	label var practice "Who owns the practice?"
	tab practice
	
	*physoff - the practice categories are too sparse...need to dichotomize
	gen physoff = .
	*All other practices: 	Medical/academic health center; Community health center; other hospital;; 
	*						Insurance company, health plan, or HMO; other health corporation; other;;
	*						Unknown;;
	*						Refused to answer;;
	*						Blank
	replace physoff = 0 if OWNSR == 2 | OWNSR == 3 | OWNSR == -6 | OWNSR == -8
	*Physician Office: Physician or physician group
	replace physoff = 1 if OWNSR == 1
	label define physofff 0 "All other practices" 1 "Physician or physician group"
	label value physoff physofff
	label var physoff "Do physicians own the practice?"
	tab physoff
	
	total PATWT, over(physoff)
	

**PROVIDER (SPECR), DERIVED**

	*look at provider (SPECR) in original NAMCS categories
	tab SPECR

	/* look at formatting of NAMCS OWNSR variable	
	
	label define SPECRF 01 "General/family practice"  
	label define SPECRF 03 "Internal medicine" , add
	label define SPECRF 04 "Pediatrics" , add
	label define SPECRF 05 "General surgery" , add
	label define SPECRF 06 "Obstetrics and gynecology" , add
	label define SPECRF 07 "Orthopedic surgery" , add
	label define SPECRF 08 "Cardiovascular diseases" , add
	label define SPECRF 09 "Dermatology" , add
	label define SPECRF 10 "Urology" , add
	label define SPECRF 11 "Psychiatry" , add
	label define SPECRF 12 "Neurology" , add
	label define SPECRF 13 "Ophthalmology" , add
	label define SPECRF 14 "Otolaryngology" , add
	label define SPECRF 15 "Other specialties" , add
	*/
	
	*provider - need to move ENT into "Other specialties" bc < 5 observations
	gen provider = .
	*Dermatology: Dermatology
	replace provider = 0 if SPECR == 9
	*Other specialties: Otolaryngology and Other specialties
	replace provider = 1 if SPECR == 14 | SPECR == 15
	*Internal medicine: Internal medicine
	replace provider = 2 if SPECR == 3
	*General/family practice: General/family practice
	replace provider = 3 if SPECR == 1
	*Ophthalmology: Ophthalmology
	replace provider = 4 if SPECR == 13
	label define providerf	3 "General/family practice"		///
							2 "Internal medicine"			///
							0 "Dermatology"					///
							4 "Ophthalmology"				///
							1 "Other specialties"
	label value provider providerf
	label var provider "Physician specialty - 5 Groups"
	tab provider SPECR



**GRAPH Table 1 Variables w/Collapsed Categories**

local table1_NAMCS		SEX AGER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR
local table1_all		gender		agecat agecat5		race white		insur		region		setting		practice physoff	provider
local table1_collapse	gender agecat5 white insur region setting physoff provider

*change directory to analysis figure folder
cd "`fig_output'"

foreach dvar in `table1_collapse' {
	
	*check to make sure at least 5 observations in each category
	graph bar (count), over(`dvar', label(ticks angle(15)))						///
		blabel(bar, format(%9.0f))												///
		title("Frequency of observations from 2003 to 2015 by `dvar'")			///
		subtitle("Must be ≥ 5 observations in each category (Cochran's rule)")	///
		ytitle("Number of Observations (count)")										///
		name(bar_`dvar'_count, replace)
		graph export "bar_`dvar'_count.png", replace

	/* 
	This plot is NOT doing what I thought it was doing.
	It's plotting the MEAN of PATWT by each categorical variable.
	I want it to plot the sum by each categorical variable.
	Need to make new dataset of sociodemographic variables
	using "total PATWT, over(`dvar')"
	
	*now do patient weights
	graph bar PATWT, over(`dvar', label(ticks angle(15)))		///
		blabel(bar, format(%9.0f))								///
		title("Patient visits from 2003 to 2015 by `dvar'")		///
		ytitle("Number of Patient Visits (weighted)")			///
		name(bar_`dvar'_PATWT, replace)
		graph export "bar_`dvar'_PATWT.png", replace
	*/

	*look at counts in each category of SD variables
	bysort `dvar':	sum PATWT
	
	
	*look at PATWT summed by categorical SD variables
	total PATWT, over(`dvar')
}

/*save dataset with reformatted variables
save "namcs_2015to2003_anal.dta", replace


/*
Table 1 - Sociodemographics
*/

*change to output directory for analysis figures and tables
cd "`fig_output'"

*all sociodemographic variables in table 1
local NAMCSvars SEX AGER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR

*for loop showing summed patient weights for each variable
foreach sdem in `NAMCSvars' {

	*get sum of patient weight (PATWT) by sociodemographic variables
	total PATWT, over(`sdem')
	*show number of observations by sociodemographic variables
	bysort `sdem': sum PATWT, vsquish
	
	/*corresponding graphs
	graph hbar (percent) PATWT, over(`sdem', label(labsize(small) angle(45) ticks))	///
	blabel(bar, format(%9.1f))										///
	title("Percent of Total Patient Weight by `sdem'") 				///
	ytitle("Percent of Patient Weight")								///
	ylabel(0(25)100) ymticks(0(10)100)
	*save graph
	graph export "EDA_`sdem'.png", replace
	*/
}
*/

/*
Figure 1 - table of summed patient weights by year, with 95% confidence intervals
See Figure 1 (Davis 2015)
/

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
