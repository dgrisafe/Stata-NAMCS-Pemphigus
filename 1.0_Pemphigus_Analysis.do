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
local output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Figures & Tables/0.3_Datasets_Analysis"


*load merged, clean dataset
cd "`source'"
use "namcs_2015to1993.dta"

*change to output directory for all analysis
cd "`output'"


/*
Formatting - 
Some variables needed to be collapsed or further formatted to make sense in analysis
*/

*PAYTYPER
	*set workers comp (4), self-pay (5), and no-charge (6) to unknown (7) because so small
	*replace PAYTYPER = 7 if PAYTYPER == 4 |PAYTYPER == 5 | PAYTYPER == 6 | PAYTYPER == -8
	* set unknown and missing indicators to "."
	*replace PAYTYPER = . if PAYTYPER == 0 | PAYTYPER == -9

	
/*
Exploratory data analysis
*/


/*
Table 1 - Sociodemographics
*/

*all sociodemographic variables in table 1
local table1 SEX AGER RACERETH RACEUN PAYTYPER REGION MSA OWNSR SPECR

*for loop showing summed patient weights for each variable
foreach sdem in `table1' {
	total PATWT, over(`sdem')
	graph hbar (percent) PATWT, over(`sdem') blabel(bar, format(%9.1f)) ///
	title("Percent of Total Patient Weight by `sdem'") ///
	ytitle("Percent of Patient Weight")
	graph export "EDA_`sdem'.png", replace
}

/*
Figure 1 - table of summed patient weights by year, with 95% confidence intervals
See Figure 1 (Davis 2015)
*/
total PATWT, over(YEAR)

/*
cd "`output'"
save namcs_2015to1993_analysis, replace
