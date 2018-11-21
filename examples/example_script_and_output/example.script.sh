#!/bin/bash

# first, calculate the outlier_dp and outlier_gq
ForestQC set_outlier -i ../test.vcf.gz -m 500M

# second, calculate the statistics
ForestQC stat -i ../test.vcf.gz -o example.result.tsv -d ../concordance_rate_SNP.txt.gz -c ../gc_content_hg19.chrX.tsv -as ../user_features.tsv -p ../PedStructSeqID.txt --dp 20.0 --gq 51.0

# before doing this step, you need to combine all the statistics files generated by the previous step into one file, if there are multiple statistics files
# third, split the variant into good, bad and gray variants
ForestQC split -i example.result.tsv -as ../user_features.tsv -t ../user_thresholds.tsv

# fourth, classify the gray variants into good and bad variants
ForestQC classify -g good.example.result.tsv -b bad.example.result.tsv -y gray.example.result.tsv -f Mean_DP,Mean_GQ,f1,f3,SD_DP

# fifth, combine all bad variants together, and all good variants together. Note that "good.*" should be placed before "predicted.*", which is the same for "bad.*". Because "good.*" and "bad.*" have headers, while "predicted.* do not.
cat good.example.result.tsv predicted_good.variants.tsv > all.good.variants.tsv
cat bad.example.result.tsv predicted_bad.variants.tsv > all.bad.variants.tsv