#!/bin/bash
#title		:segment_desinkan.sh
#description	:Segments the desinkan atlas into the main cortical areas plus the thalamus
#author		:Monica Keith
#usage		:./segment_desinkan.sh <desinkan_atlas_path> <output_dir>
#bash_version	:4.4.20(1)-release

set -e

# ARGUMENTS
# $1 SEG: Desinkan atlas
# $2 OUTDIR: Folder where all the outputs of this program will be saved

Help(){
	printf "%s\n\n" "Segments the Desinkan atlas into the main cortical areas plus the thalamus"
	printf "%s\n\n" "./segment_desinkan.sh <desinkan_atlas_path> <output_dir>"
	printf "%s" "If you find errors in the code please send them to mgiralch7@alumnes.ub.edu"
}

# VARIABLES
SEG=$1
[ ! -f "${SEG}" ] && printf "%s\n\n" "Segmentation file not found: ${SEG}" && Help && exit 1
OUTDIR=$2
LUT=$3
[ ! -f "${LUT}" ] && printf "%s\n\n" "LUT file not found: ${LUT}" && Help && exit 1 

mkdir -p $OUTDIR $OUTDIR/LH $OUTDIR/RH $OUTDIR/LR

# LTC: Lateral Temporal Cortex
echo "Segmenting the lateral temporal cortex..."
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/LTC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/LTC.nii.gz -expr 'amongst(a"
for ROI in transversetemporal superiortemporal inferiortemporal middletemporal temporalpole bankssts
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
eval $cmd_l && fslmaths "${OUTDIR}"/LH/LTC -bin "${OUTDIR}"/LH/LTC
eval $cmd_r && fslmaths "${OUTDIR}"/RH/LTC -bin "${OUTDIR}"/RH/LTC
fslmaths "${OUTDIR}"/LH/LTC -add "${OUTDIR}"/RH/LTC "${OUTDIR}"/LR/LTC

# SMC: Sensorimotor Cortex
echo "Segmenting the sensorimotor cortex..."
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/SMC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/SMC.nii.gz -expr 'amongst(a"
for ROI in precentral caudalmiddlefrontal postcentral paracentral
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
eval $cmd_l && fslmaths "${OUTDIR}"/LH/SMC -bin -mul 2 "${OUTDIR}"/LH/SMC
eval $cmd_r && fslmaths "${OUTDIR}"/RH/SMC -bin -mul 2 "${OUTDIR}"/RH/SMC
fslmaths "${OUTDIR}"/LH/SMC -add "${OUTDIR}"/RH/SMC "${OUTDIR}"/LR/SMC

# Insula Cortex
echo "Segmenting the insular cortex..."
eval "3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/Ins.nii.gz -expr 'amongst(a,"$(awk '/lh-insula/ {print $1}' "${LUT}")")'" && fslmaths "${OUTDIR}"/LH/Ins -bin -mul 3 "${OUTDIR}"/LH/Ins
eval "3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/Ins.nii.gz -expr 'amongst(a,"$(awk '/rh-insula/ {print $1}' "${LUT}")")'" && fslmaths "${OUTDIR}"/RH/Ins -bin -mul 3 "${OUTDIR}"/RH/Ins
fslmaths "${OUTDIR}"/LH/Ins -add "${OUTDIR}"/RH/Ins "${OUTDIR}"/LR/Ins

# MTC: Medial Temporal Cortex
echo "Segmenting medial temporal cortex..."
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/MTC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/MTC.nii.gz -expr 'amongst(a"
for ROI in entorhinal parahippocampal fusiform
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
eval $cmd_l && fslmaths "${OUTDIR}"/LH/MTC -bin -mul 4 "${OUTDIR}"/LH/MTC
eval $cmd_r && fslmaths "${OUTDIR}"/RH/MTC -bin -mul 4 "${OUTDIR}"/RH/MTC
fslmaths "${OUTDIR}"/LH/MTC.nii.gz -add "${OUTDIR}"/RH/MTC "${OUTDIR}"/LR/MTC

# OCC: Occipital Cortex
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/OCC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/OCC.nii.gz -expr 'amongst(a"
for ROI in pericalcarine lingual lateraloccipital cuneus
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
[ ! -f $OUTDIR/LH/OCC.nii.gz ] && eval $cmd_l && fslmaths $OUTDIR/LH/OCC -bin -mul 5 $OUTDIR/LH/OCC
[ ! -f $OUTDIR/RH/OCC.nii.gz ] && eval $cmd_r && fslmaths $OUTDIR/RH/OCC -bin -mul 5 $OUTDIR/RH/OCC
[ ! -f $OUTDIR/LR/OCC.nii.gz ] && fslmaths $OUTDIR/LH/OCC -add $OUTDIR/RH/OCC $OUTDIR/LR/OCC

# OFC: Orbitofrontal Cortex
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/OFC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/OFC.nii.gz -expr 'amongst(a"
for ROI in parsorbitalis medialorbitofrontal lateralorbitofrontal
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
[ ! -f $OUTDIR/LH/OFC.nii.gz ] && eval $cmd_l && fslmaths $OUTDIR/LH/OFC -bin -mul 6 $OUTDIR/LH/OFC
[ ! -f $OUTDIR/RH/OFC.nii.gz ] && eval $cmd_r && fslmaths $OUTDIR/RH/OFC -bin -mul 6 $OUTDIR/RH/OFC
[ ! -f $OUTDIR/LR/OFC.nii.gz ] && fslmaths $OUTDIR/LH/OFC -add $OUTDIR/RH/OFC $OUTDIR/LR/OFC

# LPFC: Lateral Prefrontal Cortex
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/LPFC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/LPFC.nii.gz -expr 'amongst(a"
for ROI in parstriangularis frontalpole rostralmiddlefrontal parsopercularis
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
[ ! -f $OUTDIR/LH/LPFC.nii.gz ] && eval $cmd_l && fslmaths $OUTDIR/LH/LPFC -bin -mul 7 $OUTDIR/LH/LPFC
[ ! -f $OUTDIR/RH/LPFC.nii.gz ] && eval $cmd_r && fslmaths $OUTDIR/RH/LPFC -bin -mul 7 $OUTDIR/RH/LPFC
[ ! -f $OUTDIR/LR/LPFC.nii.gz ] && fslmaths $OUTDIR/LH/LPFC -add $OUTDIR/RH/LPFC $OUTDIR/LR/LPFC

# PC: Parietal Cortex
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/PC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/PC.nii.gz -expr 'amongst(a"
for ROI in inferiorparietal supramarginal precuneus posteriorcingulate isthmuscingulate superiorparietal
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
[ ! -f $OUTDIR/LH/PC.nii.gz ] && eval $cmd_l && fslmaths $OUTDIR/LH/PC -bin -mul 8 $OUTDIR/LH/PC
[ ! -f $OUTDIR/RH/PC.nii.gz ] && eval $cmd_r && fslmaths $OUTDIR/RH/PC -bin -mul 8 $OUTDIR/RH/PC
[ ! -f $OUTDIR/LR/PC.nii.gz ] && fslmaths $OUTDIR/LH/PC -add $OUTDIR/RH/PC $OUTDIR/LR/PC

# MPFC: Medial Prefrontal Cortex
cmd_l="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/LH/MPFC.nii.gz -expr 'amongst(a"
cmd_r="3dcalc -a "${SEG}" -prefix "${OUTDIR}"/RH/MPFC.nii.gz -expr 'amongst(a"
for ROI in caudalanteriorcingulate rostralanteriorcingulate superiorfrontal
do
    cmd_l="${cmd_l},"$(awk -v var="lh-${ROI}" '$0~var {print $1}' "${LUT}")
    cmd_r="${cmd_r},"$(awk -v var="rh-${ROI}" '$0~var {print $1}' "${LUT}")
done
cmd_l="${cmd_l})'"
cmd_r="${cmd_r})'"
[ ! -f $OUTDIR/LH/MPFC.nii.gz ] && eval $cmd_l && fslmaths $OUTDIR/LH/MPFC -bin -mul 9 $OUTDIR/LH/MPFC
[ ! -f $OUTDIR/RH/MPFC.nii.gz ] && eval $cmd_r && fslmaths $OUTDIR/RH/MPFC -bin -mul 9 $OUTDIR/RH/MPFC
[ ! -f $OUTDIR/LR/MPFC.nii.gz ] && fslmaths $OUTDIR/LH/MPFC -add $OUTDIR/RH/MPFC $OUTDIR/LR/MPFC

# Full atlas with all the segmented cortical regions
[ ! -f $OUTDIR/LH/ALL.nii.gz ] && fslmaths $OUTDIR/LH/Ins -add $OUTDIR/LH/LPFC -add $OUTDIR/LH/LTC -add $OUTDIR/LH/MPFC -add $OUTDIR/LH/MTC -add $OUTDIR/LH/OCC -add $OUTDIR/LH/OFC -add $OUTDIR/LH/PC -add $OUTDIR/LH/SMC $OUTDIR/LH/ALL
[ ! -f $OUTDIR/RH/ALL.nii.gz ] && fslmaths $OUTDIR/RH/Ins -add $OUTDIR/RH/LPFC -add $OUTDIR/RH/LTC -add $OUTDIR/RH/MPFC -add $OUTDIR/RH/MTC -add $OUTDIR/RH/OCC -add $OUTDIR/RH/OFC -add $OUTDIR/RH/PC -add $OUTDIR/RH/SMC $OUTDIR/RH/ALL
[ ! -f $OUTDIR/LR/ALL.nii.gz ] && fslmaths $OUTDIR/LR/Ins -add $OUTDIR/LR/LPFC -add $OUTDIR/LR/LTC -add $OUTDIR/LR/MPFC -add $OUTDIR/LR/MTC -add $OUTDIR/LR/OCC -add $OUTDIR/LR/OFC -add $OUTDIR/LR/PC -add $OUTDIR/LR/SMC $OUTDIR/LR/ALL

# Thalamus
[ ! -f $OUTDIR/LH/Thalamus.nii.gz ] && fslmaths ${SEG} -thr $(awk '/Left-Thalamus/ {print $1}' "${LUT}") -uthr $(awk '/Left-Thalamus/ {print $1}' "${LUT}") $OUTDIR/LH/Thalamus
[ ! -f $OUTDIR/RH/Thalamus.nii.gz ] && fslmaths ${SEG} -thr $(awk '/Right-Thalamus/ {print $1}' "${LUT}") -uthr $(awk '/Right-Thalamus/ {print $1}' "${LUT}") $OUTDIR/RH/Thalamus
[ ! -f $OUTDIR/LR/Thalamus.nii.gz ] && fslmaths $OUTDIR/LH/Thalamus -add $OUTDIR/RH/Thalamus $OUTDIR/LR/Thalamus
