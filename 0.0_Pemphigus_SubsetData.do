cls
clear

/*
This program will subset variables from years 1993 to 2015 based on a 3-digit ICD9 code.
To change the 3-digit ICD9 code,  replace any "694" with the desired code.
*/

*source folder where all the raw NAMCS datasets are in Stata .dta format
local source "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/!NAMCS_Stata"

*output folder where all the subset NAMCS datasets will be created in Stata .dta format
local output "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/Pemphigus1993-15/0.0_Datasets_Subset"


/* These datasets have *uppercase* 3-digit diagnosis variables */

*local macro subsetting each dataset
local yeardata1	namcs2015 namcs2014 namcs2013 namcs2012 namcs2011 namcs2010 ///
				namcs2009 namcs2008 namcs2007 namcs2006 					///
				namcs2001 namcs2000 namcs1999 namcs1998 namcs1997 namcs1996 ///
				namcs1995 
	
*Loop subsetting data on a given 3 digit ICD9 diagnosis
foreach set in `yeardata1'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
		
	*keep observations with diagnoses of Bullous dermatoses (694) 
	keep if	strpos(DIAG13D, "694") | strpos(DIAG23D, "694") | strpos(DIAG33D, "694")
			
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* These datasets *do NOT have* 3-digit diagnosis variables */

*local macro subsetting each dataset
local yeardata2	namcs2005 namcs2004 namcs2003
	
*Loop subsetting data on a given 3 digit ICD9 diagnosis
foreach set in `yeardata2'{

	*clear loaded data
	clear
		
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
		
	*keep observations with diagnoses of Bullous dermatoses (694) 
	keep if	strpos(diag13d, "694") | strpos(diag23d, "694") | strpos(diag33d, "694")
			
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* These datasets have *lowercase* 3-digit diagnosis variables */

*local macro subsetting each dataset
local yeardata3	namcs2002
				
	
*Loop subsetting data on a given 3 digit ICD9 diagnosis
foreach set in `yeardata3'{
	
	*clear loaded data
	clear
	
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
		
	*keep observations with diagnoses of Bullous dermatoses (694) 
	keep if	strpos(diag13d, "694") | strpos(diag23d, "694") | strpos(diag33d, "694")
			
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}


/* These datasets have *labeled categorical* 3-digit diagnosis variables */

*local macro subsetting each dataset
local yeardata3	namcs1994 namcs1993
				
	
*Loop subsetting data on a given 3 digit ICD9 diagnosis
foreach set in `yeardata3'{
	
	*clear loaded data
	clear
	
	*mac path to complete NAMCS datasets for 1993 to 2015
	cd "`source'"

	*load the dataset
	use `set'
		
	*keep observations with diagnoses of Bullous dermatoses (694) 
	keep if	DIAG13D == 1694 | DIAG23D == 1694 | DIAG33D == 1694
			
	*change directory to where would like to save datasets
	cd "`output'"
	save `set', replace
	
}
