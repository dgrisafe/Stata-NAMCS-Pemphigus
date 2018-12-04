cls
clear

*mac path
cd "/Volumes/GoogleDrive/My Drive/20181101_NAMCS Pierce/Datasets/!NAMCS_Stata"
use namcs2009.dta

summarize

*scatter plot of age and sex
scatter AGE ETHUN if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")

*summarize data
sum AGE ETHUN if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")

*demographics
list VMONTH AGE SEX PREGNANT ETHUN RACEUN if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")

*Table 1
list AGE SEX RFV1 DIAG1 DIAG2 DIAG3 if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")

*Table 2 - MEDICATIONS
list AGE SEX MED NUMNEW ///
	if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")
	
*Table 2 - SERVICES
list AGE SEX EXAM SERVCNT ALLSERV PROC1R ///
	if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")
	
*Table 2 - DOCTORS
list AGE SEX SPECR SPECCAT MDDO RETYPOFFR SOLO EMPSTAT PHYSCOMP ///
	if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")
	
*/

*TABLE 3 - Leading treatments for HS in the NAMCS
*i.e. if someone has diagnosis, what meds are they on?
list AGE SEX MED1 NCMED1 MED2 NCMED2 MED3 NCMED3 ///
	if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")
*NOTE: there are 30 potential medication slots. Look at all of them to count what medications
*	each person is on

*look at comorbidities
sum HTN
histogram HTN, fraction ///
	if strpos(DIAG13D, "705") | strpos(DIAG23D, "705") | strpos(DIAG33D, "705")

*testing 2009 data to see if get same estimate value as in pierce's example paper
list AGE SEX RFV1 PATWT DIAG1 DIAG2 DIAG3 if strpos(DIAG1, "70583") | strpos(DIAG2, "70583") | strpos(DIAG3, "70583")
