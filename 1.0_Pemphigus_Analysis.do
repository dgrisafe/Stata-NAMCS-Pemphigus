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
local source_all "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/0.1_Datasets_Merged"

local source_case "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/0.2_Datasets_PemphigusID"

*output folder where analysis Figures and Tables output will be stored
local output_dat "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/1.0_Pemphigus_Analysis"

*output folder where analysis Figures and Tables output will be stored
local output_fig "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Figures & Tables/1.0_Pemphigus_Analysis"

*change to output directory for all analysis
cd "`source_case'"

*load merged, clean dataset
use "namcs_2015to1995_ICD9_694.dta"

	
/*
Exploratory data analysis & Formatting
*/

*change to output directory for datasets with new derived variables
cd "`output_dat'"

*sort on case status (cases, then controls), then by year (2015 to 1995)
gsort -CACO -YEAR

*make case id, useful for further analyses
gen ptid = _n


*indicator variable to see whether diagnosed with Pemphigus (694.4), Pemphigoid (694.5), or Unspecified bullous dermatoses (694.9)
gen pemphcat = .
	*identify all cases
		replace pemphcat = -1 if CACO == 1
	*Dermatitis herpetiformis (694.0)
		replace pemphcat = 0 if	DIAG1 == "6940-" | DIAG2 == "6940-" | DIAG3 == "6940-" | DIAG4 == "6940-" | DIAG5 == "6940-"
	*Impetigo herpetiformis (694.3)
		replace pemphcat = 3 if	DIAG1 == "6943-" | DIAG2 == "6943-" | DIAG3 == "6943-" | DIAG4 == "6943-" | DIAG5 == "6943-"
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
label define pemphcatf	-1 "Case that does not fit into any specific category"									///
						0 "(694.0) Dermatitis herpetiformis"													///
						3 "(694.3) Impetigo herpetiformis" 														///
						4 "(694.4) Pemphigus"																	///
						5 "(694.5) Pemphigoid"																	///
						60 "(694.60) Benign mucous membrane pemphigoid without mention of ocular involvement"	///
						61 "(694.61) Benign mucous membrane pemphigoid with ocular involvement"					///
						8 "(694.8) Other specified bullous dermatoses"											///
						9 "(694.9) Unspecified bullous dermatoses"
label value pemphcat pemphcatf

tab pemphcat
	
*collapse pemphcat so ≥ 5 observations per category
gen pemphcatcol = .
replace pemphcatcol = 1 	if pemphcat == 5
replace pemphcatcol = 2 	if pemphcat == 4
replace pemphcatcol = 3 	if pemphcat == 0 | pemphcat == 3 | pemphcat == 8 | pemphcat == 9 | pemphcat == 60 | pemphcat == 61

label define pemphcatcolf	1 "(694.5) Pemphigoid"						///
							2 "(694.4) Pemphigus"						///
							3 "Other or Unspecified bullous dermatoses"
label value pemphcatcol pemphcatcolf

*look at 				
tab pemphcat pemphcatcol


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
							1 "teenager"	///
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


/* How to eliminate singletons in NAMCS data
*	https://www.cdc.gov/nchs/data/ahcd/ultimatecluster.pdf
*	Problem when running logistic regressions on survey data prior to year 2002

*SAS code to create CSTRATM and CPSUM for 1993-2001

	CSTRATM=STRATM;
	CPSUM=PSUM;
	IF CPSUM IN (1 2 3 4) THEN DO;
	CSTRATM=(STRATM*100000)+(1000*(MOD(YEAR,100)))+
	(SUBFILE*100)+PROSTRAT;
	CPSUM=PROVIDER+100000;
	END;
	ELSE CSTRATM=(STRATM*100000);

* need to keep variables: STRATM PSUM SUBFILE PROSTRAT PROVIDER

*/

	*this is the Stata version of the SAS loop above, taken from the link above that
	replace CSTRATM = STRATM if (YEAR >= 1993 & YEAR <= 2001)
	replace CPSUM  = PSUM if (YEAR >= 1993 & YEAR <= 2001)
	gen calcWTs = .

	replace CSTRATM = (STRATM * 100000) + (1000 * (mod(YEAR,100))) + (SUBFILE * 100) + PROSTRAT if (YEAR >= 1993 & YEAR <= 2001 & inlist(PSUM,1,2,3,4))
	replace CPSUM = PROVIDER + 100000 if (YEAR >= 1993 & YEAR <= 2001 & inlist(PSUM,1,2,3,4))
	replace calcWTs = 1 if (YEAR >= 1993 & YEAR <= 2001 & inlist(PSUM,1,2,3,4))

	replace CSTRATM = (STRATM * 100000) if (YEAR >= 1993 & YEAR <= 2001 & !inlist(PSUM,1,2,3,4))
	replace calcWTs = 2 if (YEAR >= 1993 & YEAR <= 2001 & !inlist(PSUM,1,2,3,4))
	
	label define calcWTsf 1 "Calc 1" 2 "Calc 2"
	label value calcWTs calcWTsf
	label variable calcWTs "How was CSTRATM calculated? (Years 1993 to 2001 only)"
	
	*look at calculated CSTRATM values
	tab YEAR calcWTs


/*
**Total Estimated Patient Visits from 1995 to 2015**
	
	*cases
	total PATWT if CACO == 1
	
	*controls
	total PATWT if CACO == 0	

**GRAPH Table 1 Variables w/Collapsed Categories**

local table1_NAMCS		SEX AGER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR
local table1_all		gender		agecat agecat5		race white		insur		region		setting		practice physoff	provider
local diseaseCat		pemphcat pemphcatcol 
local table1_collapse 	gender agecat5 white insur region setting physoff provider

*change directory to analysis figure folder
cd "`output_fig'"

*summary statistics and estimates of all cases (694)
sum PATWT if CACO == 1
total PATWT if CACO == 1

*summary statistics and estimates of all cases (694) by specific diseases
bysort pemphcatcol:	sum PATWT if CACO == 1
total PATWT if CACO == 1, over(pemphcatcol)

*Tb1 - summary statistics and estimates of cases (694) and controls by sociodem vars
foreach dvar in `table1_collapse' {
	
	*look at counts in each category of SD variables
	bysort `dvar':	sum PATWT if CACO == 1
	bysort `dvar':	sum PATWT if CACO == 0
	
	*look at PATWT summed by categorical SD variables
	total PATWT if CACO == 1, over(`dvar')
	total PATWT if CACO == 0, over(`dvar')
}

/*make bar graphs showing frequency counts of each demographic variable for cases and controls
foreach dvar in `table1_collapse' {
	
	**case
	graph bar (count) if CACO == 1, over(`dvar', label(ticks angle(15) labsize(small)))		///
		blabel(bar, format(%9.0f))															///
		title("Frequency of cases from 1995 to 2015 by `dvar'")								///
		ytitle("Number of Observations (count)")											///
		name(bar_`dvar'_case, replace)
		graph export "bar_`dvar'_case.png", replace
		
	**control
	graph bar (count) if CACO == 0, over(`dvar', label(ticks angle(15) labsize(small)))		///
		blabel(bar, format(%9.0f))															///
		title("Frequency of controls from 1995 to 2015 by `dvar'")							///
		ytitle("Number of Observations (count)")											///
		name(bar_`dvar'_control, replace)
		graph export "bar_`dvar'_control.png", replace

}
*/
*/

*save dataset with reformatted variables
order ptid CACO YEAR SETTYPE PATWT pemphcatcol pemphcat
sort ptid

cd "`output_dat'"

*all observations
save "namcs_2015to1995_anal.dta", replace

*cases only
keep if CACO == 1
save "namcs_2015to1995_anal_CasesOnly.dta", replace

*reload the entire dataset with formatted variables for further analysis
use "namcs_2015to1995_anal.dta"


/*
Table 1 - Sociodemographics
/

*change to output directory for analysis figures and tables
cd "`output_fig'"

*all sociodemographic variables in table 1
local NAMCSvars SEX AGER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR

*for loop showing summed patient weights for each variable
foreach sdem in `NAMCSvars' {

	*get sum of patient weight (PATWT) by sociodemographic variables
	total PATWT, over(`sdem')
	*show number of observations by sociodemographic variables
	bysort `sdem': sum PATWT, vsquish
	
	*corresponding graphs
	graph hbar (percent) PATWT, over(`sdem', label(labsize(small) angle(45) ticks))	///
	blabel(bar, format(%9.1f))														///
	title("Percent of Total Patient Weight by `sdem'") 								///
	ytitle("Percent of Patient Weight")												///
	ylabel(0(25)100) ymticks(0(10)100)
	*save graph
	graph export "EDA_`sdem'.png", replace
	
}
*/

/*
Table 2 - Bullous dermatoses (ICD9 694) diagnosis types
/

total PATWT, over(pemphcat)


/*
Figure 1 - table of summed patient weights by year, with 95% confidence intervals
See Figure 1 (Davis 2015)
*/

*data to be used to make a line plot in excel

bysort YEAR:	sum PATWT if CACO == 1

*all Bullous dermatoses
total PATWT if CACO == 1, over(YEAR)

*(694.5) Pemphigoid
bysort YEAR:	sum PATWT if pemphcatcol == 1
total PATWT if pemphcatcol == 1, over(YEAR)

*(694.4) Pemphigus
bysort YEAR:	sum PATWT if pemphcatcol == 2
total PATWT if pemphcatcol == 2, over(YEAR)

*Other or Unspecified bullous dermatoses
bysort YEAR:	sum PATWT if pemphcatcol == 3
total PATWT if pemphcatcol == 3, over(YEAR)
*/

/* 
reshape diagnosis data from wide to long 
https://stats.idre.ucla.edu/stata/modules/reshaping-data-wide-to-long/
*/

/*change to output directory for all analysis
cd "`output_dat'"

*load original wide dataset
use "namcs_2015to1995_anal_CasesOnly.dta", clear

*look at data in wide form
list ptid DIAG1 DIAG2 DIAG3 DIAG4 DIAG5 if CACO == 1

*reshape to long data
reshape long DIAG, i(ptid) j(dxid) 

*look at most common comorbidities: 
*	(1) IGNORE any pemphigus diagnoses, 
*	(2) IGNORE any comorbidities that have less than 2 observations
*all Bullous dermatoses
tab DIAG if CACO == 1, sort

*(694.5) Pemphigoid
tab DIAG if pemphcatcol == 1, sort

*(694.4) Pemphigus
tab DIAG if pemphcatcol == 2, sort

*Other or Unspecified bullous dermatoses
tab DIAG if pemphcatcol == 3, sort


*save long dataset
save "namcs_2015to1995_anal_LongDiag.dta", replace


/* 
reshape medications prescribed data from wide to long 
https://stats.idre.ucla.edu/stata/modules/reshaping-data-wide-to-long/
*/

*load analytical wide dataset
use "namcs_2015to1995_anal_CasesOnly.dta", clear

*look at data of cases in wide form
list ptid s_MED1-s_MED30 if CACO == 1

*reshape to long data
reshape long s_MED, i(ptid) j(medid) 

*look at most common comorbidities
tab s_MED, sort

*generate indicator variable for 694 Primary diagnosis 
*	(i.e. 694 in first diagnosis position)
gen diag1_694 = .
replace diag1_694 = 1 if DIAG13D == "694"
tab s_MED if diag1_694 == 1, sort

*generate indicator variable for (694.5) Pemphigoid Primary diagnosis 
*	(i.e. 694.5 in first diagnosis position)
gen diag1_694_5 = .
replace diag1_694_5 = 1 if DIAG1 == "6945-"
tab s_MED if diag1_694_5 == 1, sort

*generate indicator variable for (694.4) Pemphigus Primary diagnosis 
*	(i.e. 694.4 in first diagnosis position)
gen diag1_694_4 = .
replace diag1_694_4 = 1 if DIAG1 == "6944-"
tab s_MED if diag1_694_4 == 1, sort

*generate indicator variable for Other or Unspecified bullous dermatoses Primary diagnosis 
*	(i.e. 6940- 6943- 69460 69461 6948- 6949- in first diagnosis position)
gen diag1_694_other = .
replace diag1_694_other = 1 if DIAG1 == "6940-" | DIAG1 == "6943-" | DIAG1 == "69460" | DIAG1 == "69461" | DIAG1 == "6948-" | DIAG1 == "6949-"
tab s_MED if diag1_694_other == 1, sort


*save long dataset
save "namcs_2015to1995_anal_LongMeds.dta", replace
*/

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
cls
clear
local output_dat "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/1.0_Pemphigus_Analysis"
cd "`output_dat'"
use "namcs_2015to1995_anal.dta", clear

*load directory for output
cd "`output_fig'"


/* -DG 12/17/18 -
Need to figure out how to collapse the three strata with single sampling unit.
There's not that many, or that many observations, but cannot determine strata identification
because Stata is reporting them in scientific notation only to 2 decimal place.
The differences in strata are much smaller and it is not possible to identify the strata names
*/

*replace the strata with 1 PSU with the neighboring value
*73 observations: CSTRATM == 201.06105
*replace CSTRATM = 201.06107 if CSTRATM >= 201.061049 * 100000 & CSTRATM <= 201.061051 * 100000
replace CSTRATM = . if CSTRATM >= 201.061049 * 100000 & CSTRATM <= 201.061054 * 100000

*28 observations: CSTRATM == 202.99112
*replace CSTRATM = 202.99110 if CSTRATM == 202.99112 * 100000
replace CSTRATM = . if CSTRATM == 202.99112 * 100000

*39 observations: CSTRATM == 203.00101
*replace CSTRATM = 202.99115 if CSTRATM == 203.00101 * 100000
replace CSTRATM = . if CSTRATM == 203.00101 * 100000


*preparation for survey sampled logistic regression
*https://stats.idre.ucla.edu/stata/faq/how-do-i-use-the-stata-survey-svy-commands/
svyset CPSUM [pweight=PATWT], strata(CSTRATM)

*actually run the regression
svy: logistic CACO

*how to see where the errors are from
*	https://www.statalist.org/forums/forum/general-stata-discussion/general/1375170-survey-analysis-error-with-single-stratum
svydes

*look to see the specific values of the CSTRATM strata that only have 1 PSU value
gen stratName = CSTRATM / 100000
format stratName %10.5f
tab stratName, sort

tab CSTRATM CPSUM
