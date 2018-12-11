cls
clear

/*
This program will merge formatted datasets to single dataset
for years 1993 to 2015]

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

*source folder where all the formatted NAMCS datasets are in Stata .dta format
local source "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.1_Datasets_Formatted"

*output folder where the merged NAMCS datasets will be created in Stata .dta format
local output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.2_Datasets_Merged"


*load the datasets from 2009 to 2015 first, since they are the most similar
cd "`source'"

*Load initial 2015 dataset in preparation to add everything to it
use "namcs2015.dta"

*macro of all subsequent datasets to be merged (2014 to 1993)
local datasets_14to93	"namcs2014.dta"	"namcs2013.dta"	"namcs2012.dta"	"namcs2011.dta"	"namcs2010.dta"	///
						"namcs2009.dta"	"namcs2008.dta"	"namcs2007.dta"	"namcs2006.dta"	"namcs2005.dta"	///
						"namcs2004.dta"	"namcs2003.dta"													///
						"namcs2002.dta"	"namcs2001.dta"	"namcs2000.dta"									///
						"namcs1999.dta"	"namcs1998.dta"	"namcs1997.dta"	"namcs1996.dta"	"namcs1995.dta"

*for loop to merge each dataset
foreach dataset in "`datasets_14to93'"{
	*merge dataset with previous
	merge 1:1 	YEAR SETTYPE PATWT 														///
				DIAG1 DIAG2 DIAG3 														///
				SEX AGE AGER RACER RACERETH PAYTYPER REGIONOFF MSA SPECR 				///
				s_MED1-s_MED5 using "`dataset'"
	*drop the merge indicator
	drop _merge	
}		
				

/*
Final formatting for all variables in single merged document
*/

*format diagnosis string variables with "-9" as "" (missing)
local dxvar	DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D
foreach var in `dxvar'{
	replace `var' = "" if `var' == "-9"
}

*format race variable so missing value indicators (-9) are missing
replace RACEUN = . if RACEUN == -9

*sort by year, descending
gsort -YEAR

*organize variables in meaningful order
order  	YEAR SETTYPE PATWT 														///
		DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D	///
		SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
		s_MED1-s_MED30															///
		ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM CANCER CASTAGE	///
		CEBVD CAD CHF CKD COPD CRF DEPRN DIABETES DIABTYP1 DIABTYP2 DIABTYP0	///
		ESRD HIV HPE HTN HYPLIPID IHD OBESITY OSA OSTPRSIS SUBSTAB				///
		NOCHRON TOTCHRON

cd "`output'"
save namcs_2015to1993, replace
