# Stata NAMCS Pemphigus

The numeric headings of each program help organize the workflow in a single, linear direction.
I will begin using "1_" once the final dataset has been made and analysis begins.

Programs with heading "0.1_" are data processing for all the individual years. 
Separate, but similar, programs are necessary because the variables change from year to year in the NAMCS.

Once these variables have been processed, program "0.2_" merges them together into a single data set.
This dataset is currently set to select all observations with diagnosis containing 6944 (Pemphigus) or 6945 (Pemphigoid).
Once the merging program has been checked for correct formatting, 
this process can be repeated for any disease of interestby changing the ICD9 codes.

I will continue to add programs for data analysis, which will update automatically via GitHub.
