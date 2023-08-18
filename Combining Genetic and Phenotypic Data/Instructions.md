Instructions for Section
---------------
We used “EDITED Official UKB Combining Pheno and Geno Data.R” and “Official UKB Combining Pheno and Geno ALL OTHER CHROMS.R”. 
This process did involve transposing the matrix of genetic variants for each chromosome and using some regular expressions to get the ID variable formatted correctly. It seems to have gone smoothly based on sanity checks.

We then used “EDITED Official UKB Processing Full Dataset.R” for this step. This was a bit painstaking as it involved looking at which allele was the effect allele (in this case, which one resulted in increased BMI) in Locke et al. and then counting the number of each of these alleles by variant for each individual, which I did individually. The results presented in Effect Allele Frequency suggest that this went well. This is a process that could result in individual errors (although I’ve checked the code numerous times) but it would not result in the lack of significance across the variants we’re facing.
