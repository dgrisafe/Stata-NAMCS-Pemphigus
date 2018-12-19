cls
clear

/*
This program will merge formatted datasets to single dataset
for years 1995 to 2015]

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
local source "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/0.0_Datasets_Formatted"

*output folder where the merged NAMCS datasets will be created in Stata .dta format
local output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1995-15/0.1_Datasets_Merged"


*load the datasets from 2009 to 2015 first, since they are the most similar
cd "`source'"

*Load initial 2015 dataset in preparation to add everything to it
use "namcs2015.dta"

*macro of all subsequent datasets to be merged (2014 to 1995)
local datasets_14to95	"namcs2014.dta"	"namcs2013.dta"	"namcs2012.dta"	"namcs2011.dta"	"namcs2010.dta"	///
						"namcs2009.dta"	"namcs2008.dta"	"namcs2007.dta"	"namcs2006.dta"	"namcs2005.dta"	///
						"namcs2004.dta"	"namcs2003.dta"													///
						"namcs2002.dta"	"namcs2001.dta"	"namcs2000.dta"									///
						"namcs1999.dta"	"namcs1998.dta"	"namcs1997.dta"	"namcs1996.dta"	"namcs1995.dta"
*/
*for loop to merge each dataset
foreach dataset in "`datasets_14to95'"{
	*merge dataset with previous
	append using "`dataset'"
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
order  	YEAR SETTYPE PATWT CSTRATM CPSUM												///
		DIAG1 DIAG13D DIAG2 DIAG23D DIAG3 DIAG33D DIAG4 DIAG43D DIAG5 DIAG53D			///
		SEX AGE AGER RACER RACERETH RACEUN PAYTYPER REGIONOFF MSA OWNSR SPECR SPECCAT	///
		s_MED1-s_MED30																	///
		ETOHAB ALZHD ARTHRTIS ASTHMA ASTH_SEV ASTH_CON AUTISM CANCER CASTAGE			///
		CEBVD CAD CHF CKD COPD CRF DEPRN DIABETES DIABTYP1 DIABTYP2 DIABTYP0			///
		ESRD HIV HPE HTN HYPLIPID IHD OBESITY OSA OSTPRSIS SUBSTAB						///
		NOCHRON TOTCHRON STRATM PSUM SUBFILE PROSTRAT PROVIDER
		
		
/* 	This code will format the sampling variables in datasets 2001 to 1993
	so they are the same as those in subsequent years.
	The documentation on this is available at the following PDF:
	https://www.cdc.gov/nchs/data/ahcd/ultimatecluster.pdf

	*SAS code to create CSTRATM and CPSUM for 1993-2001

		CSTRATM=STRATM;
		CPSUM=PSUM;
		IF CPSUM IN (1 2 3 4) THEN DO;
		CSTRATM=(STRATM*100000)+(1000*(MOD(YEAR,100)))+
		(SUBFILE*100)+PROSTRAT;
		CPSUM=PROVIDER+100000;
		END;
		ELSE CSTRATM=(STRATM*100000);

	*need to keep variables: STRATM PSUM SUBFILE PROSTRAT PROVIDER

*/

	*this is the Stata version of the SAS loop above, taken from the link above that
	
		*create properly named CSTRATM and CPSUM variables for years 1993 to 2001
		replace CSTRATM = STRATM if (YEAR >= 1993 & YEAR <= 2001)
		replace CPSUM  = PSUM if (YEAR >= 1993 & YEAR <= 2001)
		gen calcWTs = .

		*calculate CSTRATM and CPSUM correctly for years 1993 to 2001 (Calc 1)
		replace CSTRATM = (STRATM * 100000) + (1000 * (mod(YEAR,100))) + (SUBFILE * 100) + PROSTRAT if (YEAR >= 1993 & YEAR <= 2001 & inlist(PSUM,1,2,3,4))
		replace CPSUM = PROVIDER + 100000 if (YEAR >= 1993 & YEAR <= 2001 & inlist(PSUM,1,2,3,4))
		*indicator variable to show which observations were recalculated this way (Calc 1)
		replace calcWTs = 1 if (YEAR >= 1993 & YEAR <= 2001 & inlist(PSUM,1,2,3,4))

		*calculate CSTRATM and CPSUM correctly for years 1993 to 2001 (Calc 2)
		replace CSTRATM = (STRATM * 100000) if (YEAR >= 1993 & YEAR <= 2001 & !inlist(PSUM,1,2,3,4))
		*indicator variable to show which observations were recalculated this way (Calc 2)
		replace calcWTs = 2 if (YEAR >= 1993 & YEAR <= 2001 & !inlist(PSUM,1,2,3,4))
		
		*format indicator variable properly
		label define calcWTsf 1 "Calc 1" 2 "Calc 2"
		label value calcWTs calcWTsf
		label variable calcWTs "How was CSTRATM calculated? (Years 1993 to 2001 only)"
		
		*look at calculated CSTRATM values by calculation method
		tab YEAR calcWTs
		
		*only need calculation indicator variable to check performed correctly
		*	do not need for further analysis
		drop calcWTs
	
	*To Eliminate Singletons in NAMCS Data…
		
		* For 1996 NAMCS data
		replace CSTRATM = (203 * 100000) + (1000 * (mod(YEAR,100))) + (SUBFILE * 100) + PROSTRAT	/// 
			if SUBFILE == 1 & PROSTRAT == 14 & YEAR == 1996 & STRATM == 202

		* For 1999 NAMCS data
		replace CSTRATM = (203 * 100000) + (1000 * (mod(YEAR,100))) + (SUBFILE * 100) + PROSTRAT	///
			if SUBFILE == 1 & PROSTRAT == 12 & YEAR == 1999 & STRATM == 202
		
		* For 2000 NAMCS data
		replace CSTRATM = (202 * 100000) + (1000 * (mod(YEAR,100))) + (SUBFILE * 100) + PROSTRAT	///
			if SUBFILE == 1 & PROSTRAT == 1 & YEAR == 2000 & STRATM == 203

			
*save a permanent record of this dataset
cd "`output'"
save namcs_2015to1995, replace
