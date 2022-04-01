#!/bin/bash
WORDTOREMOVE="PRE";

for subject in $(aws s3 ls  s3://uke-csi-hchs/xcpengine/ --endpoint-url https://s3-uhh.lzs.uni-hamburg.de); do

 
    subject="${subject//"PRE"}"
    subject="${subject//"/"}"
    echo $subject

#		if [ -d $subject ]; then
			aws s3 cp s3://uke-csi-hchs/xcpengine/$subject/fcon/schaefer200x7/${subject}_schaefer200x7_network.txt /mnt/c/Users/mschu/Documents/CSI/HCHS/new_cohort/fMRI_resting/raw_aroma --endpoint-url https://s3-uhh.lzs.uni-hamburg.de			
#		else
#			echo '$subject failed'
#        fi
done


