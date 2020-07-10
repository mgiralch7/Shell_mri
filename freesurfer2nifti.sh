#!/bin/bash
#title		:freesurfer2nifti.sh
#description	:Transforms the files in the mri, seg, surf and label folder to nifti format
#author		:Monica Keith
#usage		:./freesurfer2nifti.sh <freesurfer_folder>
#bash_version	:4.4.20(1)-release

set -e 

# First argument is the Freesurfer folder
FSfolder=$1

# By default, convert the images in the three folders and attemt to perform segmentation
conv_mri=1
segm=1
conv_surf=1
conv_label=1
rm_tmp=0

# Evaluate other arguments
# If any flag is present indicating to skip the conversion in one folder or the brain segmentation, change the value of the corresponding variable
shift
while test ${#} -gt 0
do
	[ "$1" == "--nomri" ] && conv_mri=0 && echo "You indicated to skip the mri folder"
	[ "$1" == "--noseg" ] && segm=0 && echo "You indicated to NOT perform segmentation on the apar+aseg file"
	[ "$1" == "--nosurf" ] && conv_surf=0 && echo "You indicated to skip the surf folder"
	[ "$1" == "--nolabel" ] && conv_label=0 && echo "You indicated to skip the label folder"
	[ "$1" == "--clean" ] && rm_tmp=1 && echo "You indicated to clean all temporary files"
	if [ "$1" == "-h" ] || [ "$1" == "--help" ]
	then
		printf "Usage:freesurfer2nifti.sh <FreeSurfer_folder> [flags]\n\n"
		printf	"Converts the following images in the mri, surf and label folder to nifti and segments the regions in the apar+aseg file:\n"
		printf "mri folder: brain.mgz, brainmask.mgz, aparc+aseg.mgz\n"
		printf "surf folder: white matter\n"
		printf "label folder: MT V1 V2 BA1 BA2 BA3a BA3b BA4a BA4p BA6 BA44 BA45 cortex\n\n"
		printf "By default, all operations are performed unless one of the flags are used\n\n"
		printf "Flags:\n"
		printf '%s\t\t%s\n' '--nomri' 'Skip converting images in the mri folder. By default images in the mri folder ARE converted.'
		printf '%s\t%s\n' '--nosurf' 'Skip converting images in the surf folder. By default images in the surf folder ARE converted.'
		printf '%s\t%s\n' '--nolabel' 'Skip converting images in the label folder. By default images in the label folder ARE converted.'
		printf '%s\t\t%s\n' '--noseg' 'Do NOT perform segmentation on the aparc+aseg file. By default segmentation is attempted. File aseg.auto_noCCseg.label_intensities.txt should be present in the mri folder and it should be a comma separated file instead of spaces or tabs.'
		printf '%s\t\t%s\n' '--clean' 'Clean all temporary files. By default temporary files are NOT removed.'
		printf '%s\t%s\n\n' '-h --help' 'Show this message'
		printf '%s\n' "Author: Monica Keith"

		exit 0
	fi
	shift
done

[ ! -d "${FSfolder}" ] && echo "Freesurfer folder ${FSfolder} not found. Use -h flag for help." && exit 1
cd "${FSfolder}"

# Convert images in the mri folder and re-orient to standard coordinates
if [ $conv_mri -eq 1 ]
then
	echo "Converting images on the mri folder..."
	mkdir -p mri/nifti
	mri_convert mri/brain.mgz mri/nifti/brain.nii.gz
	fslreorient2std mri/nifti/brain mri/nifti/brain
	mri_convert mri/brainmask.mgz mri/nifti/brainmask.nii.gz
	fslreorient2std mri/nifti/brainmask mri/nifti/brainmask
	mri_convert mri/aparc+aseg.mgz mri/nifti/aparc_aseg.nii.gz
	fslreorient2std mri/nifti/aparc_aseg mri/nifti/aparc_aseg

	# Segment cortical and subcortical regions
	if [ $segm -eq 1 ]
	then
		if [ -f mri/aseg.auto_noCCseg.label_intensities.txt ]
		then
			echo "Segmenting cortical regions in the mri folder..."
			for line in $(cat mri/aseg.auto_noCCseg.label_intensities.txt)
			do
				IFS=',' read -a ARRAY <<< "$line"
				int=${ARRAY[0]}
				reg=${ARRAY[1]}
				# Segment the brain region
				# Remove file if no voxels found
				if [ "${reg}" != "" ]
				then
					echo "Segmenting ${reg}..."
					fslmaths mri/nifti/aparc_aseg -thr $int -uthr $int mri/nifti/$reg
					N=$(fslstats mri/nifti/$reg -V | awk '{print $1}')
					[ $N -eq 0 ] && rm  mri/nifti/$reg.nii.gz
				fi
			done
		else
			echo "Label intensities file not found, skipping the cortical and subcortical segmentation."
		fi
	fi
fi

# Convert images in the surf folder and re-orient to standard coordinates
if [ $conv_surf -eq 1 ]
then
	echo "Converting images on the surf folder..."
	mkdir -p surf/nifti
	for hem in lh rh
	do
		mris_convert surf/$hem.white surf/$hem.white.asc
		mris_convert surf/$hem.white surf/$hem.white.gii
		surf2volume surf/$hem.white.gii mri/nifti/brain.nii.gz surf/nifti/${hem}_white.nii.gz freesurfer
		fslreorient2std surf/nifti/${hem}_white surf/nifti/${hem}_white
	done
fi

# Convert images in the label folder and re-orient to standard coordinates
if [ $conv_label -eq 1 ]
then
	echo "Converting images on the label folder..."
	mkdir -p label/nifti
	for hem in lh rh
	do
		for reg in MT V1 V2 BA1 BA2 BA3a BA3b BA4a BA4p BA6 BA44 BA45 cortex
		do
			rm -f label/${hem}_${reg}_list.txt
			echo "label/${hem}.${reg}.label" >> label/${hem}_${reg}_list.txt
			label2surf -l label/${hem}_${reg}_list.txt -s surf/${hem}.white.asc -o label/${hem}_${reg}.gii
			surf2volume label/${hem}_${reg}.gii mri/nifti/brain.nii.gz label/nifti/${hem}_${reg}.nii.gz freesurfer
			fslreorient2std label/nifti/${hem}_${reg} label/nifti/${hem}_${reg}
		done
	done
fi
