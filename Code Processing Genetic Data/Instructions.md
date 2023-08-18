# Instructions for Section

The primary document I followed for much of this is the PRS Pipeline from the paper “Calculating Polygenic Risk Scores (PRS) in UK Biobank: A Practical Guide for Epidemiologists”. However, we found several supporting documents and studies that we'll link when relevant as well.

*Genomic Build Comparison Between UK Biobank and Locke Study (GRCH37 vs GRCH38)*

There are two primary ways to identify a single nucleotide polymorphism (SNP) in this dataset: the rsID and the position of the variant, as measured by its chromosome and position within the chromosome (measured in terms of base pairs). We use both to identify genetic variants accurately (especially in cases where rsIDs may not be unique). However, ensuring the position of the SNP is coded correctly requires the use of the same genomic build between studies. While rsIDs are build-invariant (and so remain the same regardless of build chosen), position coordinates often change with newer genomic build updates. In our case, while Locke et al. 2015, relied on HG38, the UK Biobank’s coordinates are from GRCH37 (the previous genomic build version). As a result, we manually changed the positions of the genetic variants selected in Locke by utilizing the website https://grch37.ensembl.org/Homo_sapiens/Variation/Explore?db=core;r=19:11201806-11202806;v=rs6511720;vdb=variation;vf=23192401 and confirmed with dbSNP that these coordinates were correct.
This process is often done automatically with the LiftOver tool. However, because we weren’t sure how computationally expensive this would be and we’re only doing this for a select number of variants, we hand coded. Our sanity checks provide convincing evidence that this process was completed without any errors.

*Checking for Multi-Allelic & Palindromic SNPs: SNP Quality Control Assessment*

Multi-allelic SNPs are a standard type of SNP to screen out. In brief, a multi-allelic SNP is one with more than the conventional two alleles, which would make applying any of our estimators impossible. UK Biobank has a list of these SNPs available online, which we compared to our own variants and concluded we had none (as expected). Palindromic SNPs are those with the same letters on the forward and reverse strands, which makes identifying the effect allele challenging. This is particularly difficult when the effect allele frequency is roughly 0.5, which would make actually differentiating them virtually impossible (and so would suggest excluding the SNPs is better). Based on these qualifications, there were two palindromic SNPs: rs1558902 (16:52,361,075) and rs9641123 (7:93,035,668), which were also identified in previous analyses. Our solution to this is a slight deviation from the pre-analysis plan by running both with and without these two variants.

*Extracting SNPs from each chromosome individually*

This is the start of the actual work processing the genotype data. We use the imputed datasets for each chromosome (available at Bulk -> Imputation -> UKB -> imputation from genotype -> ukb22828_c[chromosome number]_b0_v3.bgen). BGEN files are typical for imputed genetic data, which we’ll go into greater detail on later. These bgen files contain all of the SNPs gathered in the UK Biobank, of which we only use the subset we specified in our pre-analysis plan.


# Swiss Army Knife (from Command Line in UK Biobank RAP)

*First create variable that takes us to the object:*

>chrSNP="bgenix -g /mnt/project/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c1_b0_v3.bgen -incl-rsids /mnt/project/Bulk/Imputation/UKB\ imputation\ from\ genotype/SNPlist97.txt -incl-range >/mnt/project/Bulk/Imputation/UKB\ imputation\ from\ genotype/ChrPosGRCH37SNPList97.txt > Chr1.bgen"

*NOTE: C1 and Chr1 replaced by chromosome being extracted

Then run:

>dx run swiss-army-knife \
>-icmd = "${chrSNP}" --brief –yes

Have now created a BGEN file with the BMI affecting variants from the chromosome of choice. We did this for all 22 autosomal chromosomes.


*Converting BGEN files to PLINK and hard call rounding*

PLINK is a software used for working with genetic data, so our next step was to convert these files to PLINK. This is where the imputation of some genetic variants matters. Simply put, every individual only had a few missing SNPs, for which they were assigned some probability of having 0, 1, or 2 alleles in the BGEN file. There are two ways to handle this sort of missingness: estimated allelic dosages, where you simply insert the expected value of the allelic count for that variant, and hard calls, which assigns the SNP to the allele count it’s closest to in probability. In other words, if a person has an expected allelic count of 1.1, the hard count allele count would be 1 compared to 1.1 for the allelic dosage technique. For the sake of simplicity, we rely on the fill-missing-from-dosage command, which creates hard calls and, if a tie exists, (i.e. an expected value of 1.5 alleles) it defaults to the lower value. This could introduce some noise but the amount of missingness across individuals is so low that it shouldn’t have an enormous impact. We followed the guide available at https://www.cog-genomics.org/plink/2.0/data#make_pgen. It is worth noting; however, that this is a divergence from the pre-analysis plan.

# Swiss Army Knife (Again using Command Line Interface)

Again first creating the variable housing the command:

>plinktesting="plink2 --bgen /mnt/project/Chr1.bgen ref-first \
>--sample /mnt/project/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c1_b0_v3.sample 
>--set-all-var-ids @:#_\$r_\$a \
>--freq \
>--make-pgen fill-missing-from-dosage \
>--out chrom1TEST"

Then run Swiss Army Knife again:

>dx run swiss-army-knife \
>-icmd="${plinktesting}" --brief --yes

Now we have PLINK files for each chromosome with only the variants necessary for the analysis in each.


*Converting PLINK Files to Variant Call Format Files*

This is an intermediate step to convert these files to CSVs. Admittedly, this step is likely redundant but it’s the best way we’ve seen.
Need to convert plink file into usable txt file so we can add variants to phenotype dataset.

Again specifying command as a variable:

>plinkers="plink2 --pfile /mnt/project/chrom2 --recode vcf --out Chrom2_file_text"

Then run Swiss Army Knife:

>dx run swiss-army-knife \
>-icmd=”${plinkers}” --brief --yes 

This transforms the files into variant call format file, which are readily manipulated in R. Again repeating for all 22 autosomal chromosomes. 


*Converting VCF Files to CSV*

For all chromosomes at once, use R to convert VCF files into CSVs and make data workable using “UK Biobank Chrome Conversion."

*References*

1. 	Locke AE, Kahali B, Berndt SI, et al. Genetic studies of body mass index yield new insights for obesity biology. Nat 2015 5187538. 2015;518(7538):197-206. doi:10.1038/nature14177
2. 	Collister JA, Liu X, Clifton L. Calculating Polygenic Risk Scores (PRS) in UK Biobank: A Practical Guide for Epidemiologists. Front Genet. 2022;13:105. doi:10.3389/FGENE.2022.818574/BIBTEX
3. 	Ormond C, Ryan NM, Corvin A, Heron EA. Converting single nucleotide variants between genome builds: from cautionary tale to solution. Brief Bioinform. 2021;22(5):1-7. doi:10.1093/BIB/BBAB069
4. 	Guo Y, Dai Y, Yu H, Zhao S, Samuels DC, Shyr Y. Improvements and impacts of GRCh38 human reference on high throughput sequencing data analysis. Genomics. 2017;109(2):83-90. doi:10.1016/J.YGENO.2017.01.005
5. 	Hemani G, Zheng J, Elsworth B, et al. The MR-base platform supports systematic causal inference across the human phenome. Elife. 2018;7. doi:10.7554/ELIFE.34408
6. 	Hartwig FP, Davies NM, Hemani G, Davey Smith G. Two-sample Mendelian randomization: avoiding the downsides of a powerful, widely applicable but potentially fallible technique. Int J Epidemiol. 2016;45(6):1717->1726. doi:10.1093/ije/dyx028
7. 	Nelson SC, Doheny KF, Laurie CC, Mirel DB. Is ‘forward’ the same as ‘plus’?… and other adventures in SNP allele nomenclature. Trends Genet. 2012;28(8):361. doi:10.1016/J.TIG.2012.05.002
8. 	Band G, Marchini J. BGEN: a binary file format for imputed genotype and haplotype data. doi:10.1101/308296
9. 	O’Sullivan JW, Ioannidis JPA. Reproducibility in the UK biobank of genome-wide significant signals discovered in earlier genome-wide association studies. Sci Reports 2021 111. 2021;11(1):1-7. doi:10.1038/s41598->021-97896-y
10. C M, F DGM, DA  van der P, J B, NA S, J T. The use of two-sample methods for Mendelian randomization analyses on single large datasets. Int J Epidemiol. April 2021. doi:10.1093/IJE/DYAB084




