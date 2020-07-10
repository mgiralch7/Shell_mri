#!/bin/bash
#title		:segment_desinkan.sh
#description	:Calculates and applies the transformation from the subject anatomical space to MNI space (and vicerversa), also probides the option to apply the transformation to a set of ROI
#author		:Monica Keith
#usage		:./segment_desinkan.sh <desinkan_atlas_path> <output_dir>
#bash_version	:4.4.20(1)-release

set -e

# Variables
# Standard MNI brain
STD=/usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz
[ ! -f $STD ] && echo "Standard FSL file ${STD} not found. Are you sure FSL is installed in your system?" && exit 1
# By default calculate the transformation and then apply it
do_ants=1
# By default, do not attempt to apply the transformation to some ROIs
do_rois=0

# Calculates the transformation between the input brain and $STD
runANTS(){
	INPUT=$1
	OUTPUT=$2

	if [ ! -f $INPUT ] || [ "$INPUT" == "" ]
	then
		echo "Input file ${INPUT} not found"
		exit 1
	fi

	echo "Calculating the transformation between ${INPUT} and ${STD}..."
	echo ANTS 3 -m CC[$STD,$INPUT,1,5] -o $OUTPUT -r Gauss[2,0] -t SyN[0.25] -i 30x99x11 --use-Histogram-Matching
}

# Applies the direct transformation
applyDir(){
	INPUT=$1
	OUTPUT=$2
	WARP=$3
	AFFINE=$4
	NN=$5

	if [ ! -f $INPUT ] || [ "$INPUT" == "" ]
	then
		echo "Input file ${INPUT} not found"
		exit 1
	fi
	if [ ! -f $WARP ] || [ "$WARP" == "" ]
	then
		echo "Warp file ${WARP} not found"
		exit 1
	fi
	if [ ! -f $AFFINE ] || [ "$AFFINE" == "" ]
	then
		echo "Affine file ${AFFINE} not found"
		exit 1
	fi

	echo "Applying the direct transformation to ${INPUT}..."
	if [ $NN == 0 ]
	then
		WarpImageMultiTransform 3 $INPUT $OUTPUT -R $STD $WARP $AFFINE
	else
		WarpImageMultiTransform 3 $INPUT $OUTPUT -R $STD $WARP $AFFINE --use-NN
	fi
}

# Applies the inverse transformation
applyInv(){
	INPUT=$1
	OUTPUT=$2
	INVWARP=$3
	AFFINE=$4

	if [ ! -f $INPUT ] || [ "$INPUT" == "" ]
	then
		echo "Input file ${INPUT} not found"
		exit 1
	fi
	if [ ! -f $INVWARP ] || [ "$INVWARP" == "" ]
	then
		echo "Inverse warp file ${INVWARP} not found"
		exit 1
	fi
	if [ ! -f $AFFINE ] || [ "$AFFINE" == "" ]
	then
		echo "Affine file ${AFFINE} not found"
		exit 1
	fi

	echo "Applying the inverse transformation to ${STD}..."
	WarpImageMultiTransform 3 $STD $OUTPUT -R $INPUT -i $AFFINE $INVWARP
}

# Evaluate the arguments
# If any flag is present, change the corresponding variable
while test ${#} -gt 0
do
	[ "$1" == "--noants" ] && do_ants=0 
	[ "$1" == "--rois" ] && do_rois=1
	if [ "$1" == "-h" ] || [ "$1" == "--help" ]
	then
		printf "Usage:ANTStoMNI.sh [flags]\n\n"
		printf "Calculates and applies the transformation from the subject anatomical space to MNI space (and vicerversa), also probides the option to apply the transformation to a set of ROI\n"
		printf "**This script ONLY understands nifti files**\n\n"
		printf "Flags:\n"
		printf '%s\t\t%s\n' '--noants' 'Skip calculating the anatomical-to-MNI transformation, you will provide the transformation files'
		printf '%s\t\t%s\n' '--rois' 'Apply the transformation to a set of ROI, you will provide the folder path where the files are located'
		printf '%s\t%s\n\n' '-h --help' 'Show this message'
		printf '%s\n' "Author: Monica Keith"

		exit 0
	fi
done

read -p "Path of the input (moving) image: " INPUT
[ ! -f $INPUT ] && echo "Input image ${INPUT} not found" && exit 1
OUTPUT=${INPUT/.nii.gz/_ants}
INVOUTPUT=${INPUT/.nii.gz/_antsInv}

if [ $do_ants == 1 ]
then
	WARP=${OUTPUT}Warp.nii.gz
	INVWARP=${OUTPUT}InverseWarp
	AFFINE=${OUTPUT}Affine.txt

	runANTS $INPUT $OUTPUT.nii.gz
	applyDir $INPUT $OUTPUT.nii.gz $WARP $AFFINE 0
	applyInv $INPUT $INVOUTPUT.nii.gz $INVWARP $AFFINE
else
	read -p "Path of the Affine file: " AFFINE
	[ ! -f $AFFINE ] && echo "Affine file ${AFFINE} not found" && exit 1
	read -p "Path of the Warp file: " WARP
	[ ! -f $WARP ] && echo "Warp file ${WARP} not found" && exit 1
	read -p "Path of the Inverse warp file: " INVWARP
	[ ! -f $INVWARP ] && echo "Inverse warp file ${INVWARP} not found" && exit 1

	applyDir $INPUT $OUTPUT.nii.gz $WARP $AFFINE 0
	applyInv $INPUT $INVOUTPUT.nii.gz $INVWARP $AFFINE 0
fi

if [ $do_rois == 1 ]
then
	read -p "Path to the folder containing the binary files to transform: " ROIFOLDER
	[ ! -d $ROIFOLDER ] && echo "ROI folder ${ROIFOLDER} not found" && exit 1

	for ROI in $ROIFOLDER/*.nii.gz
	do
		applyDir $ROI $OUTPUT.nii.gz $WARP $AFFINE 1
	done
fi
