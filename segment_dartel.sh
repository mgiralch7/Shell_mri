#!/bin/bash
#title		:segment_dartel.sh
#description	:Segments the Dartel atlas into the main cortical areas plus the thalamus
#author		:Monica Keith
#usage		:./segment_dartel.sh <dartel_atlas_path> <output_dir>
#bash_version	:4.4.20(1)-release

set -e

# ARGUMENTS
# $1 SEG: Dartel atlas
# $2 OUTDIR: Folder where all the outputs of this program will be saved

Help(){
	printf "%s\n\n" "Segments the Dartel atlas into the main cortical areas plus the thalamus"
	printf "%s\n\n" "./segment_dartel.sh <dartel_atlas_path> <output_dir>"
	printf "%s" "If you find errors in the code please send them to mgiralch7@alumnes.ub.edu"
}

# VARIABLES
SEG=$1
[ ! -f "${SEG}" ] && "Segmentation file not found: ${SEG}" && Help && exit 1
OUTDIR=$2
mkdir -p $OUTDIR

# 1. SEPARATE EACH BRAIN REGION ACCORDING TO ITS INTENSITIY VALUE

# PRE-FRONTAL CORTEX:
echo "Segmenting the pre-frontal cortex..."
fslmaths "${SEG}" -thr 100 -uthr 100 "${OUTDIR}"/RightACgGanteriorcingulategyrus
fslmaths "${SEG}" -thr 101 -uthr 101 "${OUTDIR}"/LeftACgGanteriorcingulategyrus
fslmaths "${SEG}" -thr 104 -uthr 104 "${OUTDIR}"/RightAOrGanteriororbitalgyrus
fslmaths "${SEG}" -thr 105 -uthr 105 "${OUTDIR}"/LeftAOrGanteriororbitalgyrus
fslmaths "${SEG}" -thr 118 -uthr 118 "${OUTDIR}"/RightFOfrontaloperculum
fslmaths "${SEG}" -thr 119 -uthr 119 "${OUTDIR}"/LeftFOfrontaloperculum
fslmaths "${SEG}" -thr 120 -uthr 120 "${OUTDIR}"/RightFRPfrontalpole
fslmaths "${SEG}" -thr 121 -uthr 121 "${OUTDIR}"/LeftFRPfrontalpole
fslmaths "${SEG}" -thr 124 -uthr 124 "${OUTDIR}"/RightGRegyrusrectus
fslmaths "${SEG}" -thr 125 -uthr 125 "${OUTDIR}"/LeftGRegyrusrectus
fslmaths "${SEG}" -thr 136 -uthr 136 "${OUTDIR}"/RightLOrGlateralorbitalgyrus
fslmaths "${SEG}" -thr 137 -uthr 137 "${OUTDIR}"/LeftLOrGlateralorbitalgyrus
fslmaths "${SEG}" -thr 140 -uthr 140 "${OUTDIR}"/RightMFCmedialfrontalcortex
fslmaths "${SEG}" -thr 141 -uthr 141 "${OUTDIR}"/LeftMFCmedialfrontalcortex
fslmaths "${SEG}" -thr 142 -uthr 142 "${OUTDIR}"/RightMFGmiddlefrontalgyrus
fslmaths "${SEG}" -thr 143 -uthr 143 "${OUTDIR}"/LeftMFGmiddlefrontalgyrus
fslmaths "${SEG}" -thr 146 -uthr 146 "${OUTDIR}"/RightMOrGmedialorbitalgyrus
fslmaths "${SEG}" -thr 147 -uthr 147 "${OUTDIR}"/LeftMOrGmedialorbitalgyrus
fslmaths "${SEG}" -thr 152 -uthr 152 "${OUTDIR}"/RightMSFGsuperiorfrontalgyrusmedialsegment
fslmaths "${SEG}" -thr 153 -uthr 153 "${OUTDIR}"/LeftMSFGsuperiorfrontalgyrusmedialsegment
fslmaths "${SEG}" -thr 162 -uthr 162 "${OUTDIR}"/RightOpIFGopercularpartoftheinferiorfrontalgyrus
fslmaths "${SEG}" -thr 163 -uthr 163 "${OUTDIR}"/LeftOpIFGopercularpartoftheinferiorfrontalgyrus
fslmaths "${SEG}" -thr 164 -uthr 164 "${OUTDIR}"/RightOrIFGorbitalpartoftheinferiorfrontalgyrus
fslmaths "${SEG}" -thr 165 -uthr 165 "${OUTDIR}"/LeftOrIFGorbitalpartoftheinferiorfrontalgyrus
fslmaths "${SEG}" -thr 178 -uthr 178 "${OUTDIR}"/RightPOrGposteriororbitalgyrus
fslmaths "${SEG}" -thr 179 -uthr 179 "${OUTDIR}"/LeftPOrGposteriororbitalgyrus
fslmaths "${SEG}" -thr 186 -uthr 186 "${OUTDIR}"/RightSCAsubcallosalarea
fslmaths "${SEG}" -thr 187 -uthr 187 "${OUTDIR}"/LeftSCAsubcallosalarea
fslmaths "${SEG}" -thr 190 -uthr 190 "${OUTDIR}"/RightSFGsuperiorfrontalgyrus
fslmaths "${SEG}" -thr 191 -uthr 191 "${OUTDIR}"/LeftSFGsuperiorfrontalgyrus
fslmaths "${SEG}" -thr 204 -uthr 204 "${OUTDIR}"/RightTrIFGtriangularpartoftheinferiorfrontalgyrus
fslmaths "${SEG}" -thr 205 -uthr 205 "${OUTDIR}"/LeftTrIFGtriangularpartoftheinferiorfrontalgyrus

fslmaths "${OUTDIR}"/RightACgGanteriorcingulategyrus -add "${OUTDIR}"/RightAOrGanteriororbitalgyrus -add "${OUTDIR}"/RightFOfrontaloperculum -add "${OUTDIR}"/RightFRPfrontalpole -add "${OUTDIR}"/RightGRegyrusrectus -add "${OUTDIR}"/RightLOrGlateralorbitalgyrus -add "${OUTDIR}"/RightMFCmedialfrontalcortex -add "${OUTDIR}"/RightMFGmiddlefrontalgyrus -add "${OUTDIR}"/RightMOrGmedialorbitalgyrus -add "${OUTDIR}"/RightMSFGsuperiorfrontalgyrusmedialsegment -add "${OUTDIR}"/RightOpIFGopercularpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/RightOrIFGorbitalpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/RightPOrGposteriororbitalgyrus -add "${OUTDIR}"/RightSCAsubcallosalarea -add "${OUTDIR}"/RightSFGsuperiorfrontalgyrus -add "${OUTDIR}"/RightTrIFGtriangularpartoftheinferiorfrontalgyrus "${OUTDIR}"/RightPFC

fslmaths "${OUTDIR}"/LeftACgGanteriorcingulategyrus -add "${OUTDIR}"/LeftAOrGanteriororbitalgyrus -add "${OUTDIR}"/LeftFOfrontaloperculum -add "${OUTDIR}"/LeftFRPfrontalpole -add "${OUTDIR}"/LeftGRegyrusrectus -add "${OUTDIR}"/LeftLOrGlateralorbitalgyrus -add "${OUTDIR}"/LeftMFCmedialfrontalcortex -add "${OUTDIR}"/LeftMFGmiddlefrontalgyrus -add "${OUTDIR}"/LeftMOrGmedialorbitalgyrus -add "${OUTDIR}"/LeftMSFGsuperiorfrontalgyrusmedialsegment -add "${OUTDIR}"/LeftOpIFGopercularpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/LeftOrIFGorbitalpartoftheinferiorfrontalgyrus -add  "${OUTDIR}"/LeftPOrGposteriororbitalgyrus -add "${OUTDIR}"/LeftSCAsubcallosalarea -add "${OUTDIR}"/LeftSFGsuperiorfrontalgyrus -add "${OUTDIR}"/LeftTrIFGtriangularpartoftheinferiorfrontalgyrus "${OUTDIR}"/LeftPFC

# PARIETAL CORTEX:
echo "Segmenting the parietal cortex..."
fslmaths "${SEG}" -thr 106 -uthr 106 "${OUTDIR}"/RightAnGangulargyrus
fslmaths "${SEG}" -thr 107 -uthr 107 "${OUTDIR}"/LeftAnGangulargyrus
fslmaths "${SEG}" -thr 166 -uthr 166 "${OUTDIR}"/RightPCgGposteriorcingulategyrus
fslmaths "${SEG}" -thr 167 -uthr 167 "${OUTDIR}"/LeftPCgGposteriorcingulategyrus
fslmaths "${SEG}" -thr 168 -uthr 168 "${OUTDIR}"/RightPCuprecuneus
fslmaths "${SEG}" -thr 169 -uthr 169 "${OUTDIR}"/LeftPCuprecuneus
fslmaths "${SEG}" -thr 174 -uthr 174 "${OUTDIR}"/RightPOparietaloperculum
fslmaths "${SEG}" -thr 175 -uthr 175 "${OUTDIR}"/LeftPOparietaloperculum
fslmaths "${SEG}" -thr 194 -uthr 194 "${OUTDIR}"/RightSMGsupramarginalgyrus
fslmaths "${SEG}" -thr 195 -uthr 195 "${OUTDIR}"/LeftSMGsupramarginalgyrus
fslmaths "${SEG}" -thr 198 -uthr 198 "${OUTDIR}"/RightSPLsuperiorparietallobule
fslmaths "${SEG}" -thr 199 -uthr 199 "${OUTDIR}"/LeftSPLsuperiorparietallobule

fslmaths "${OUTDIR}"/RightAnGangulargyrus -add "${OUTDIR}"/RightPCgGposteriorcingulategyrus -add "${OUTDIR}"/RightPCuprecuneus -add "${OUTDIR}"/RightPOparietaloperculum -add "${OUTDIR}"/RightSMGsupramarginalgyrus -add "${OUTDIR}"/RightSPLsuperiorparietallobule  "${OUTDIR}"/RightPAR

fslmaths "${OUTDIR}"/LeftAnGangulargyrus -add "${OUTDIR}"/LeftPCgGposteriorcingulategyrus -add "${OUTDIR}"/LeftPCuprecuneus -add "${OUTDIR}"/LeftPOparietaloperculum -add "${OUTDIR}"/LeftSMGsupramarginalgyrus -add "${OUTDIR}"/LeftSPLsuperiorparietallobule  "${OUTDIR}"/LeftPAR

# OCCIPITAL CORTEX:
echo "Segmenting the occipital cortex..."
fslmaths "${SEG}" -thr 108 -uthr 108 "${OUTDIR}"/RightCalccalcarinecortex
fslmaths "${SEG}" -thr 109 -uthr 109 "${OUTDIR}"/LeftCalccalcarinecortex
fslmaths "${SEG}" -thr 114 -uthr 114 "${OUTDIR}"/RightCuncuneus
fslmaths "${SEG}" -thr 115 -uthr 115 "${OUTDIR}"/LeftCuncuneus
fslmaths "${SEG}" -thr 128 -uthr 128 "${OUTDIR}"/RightIOGinferioroccipitalgyrus
fslmaths "${SEG}" -thr 129 -uthr 129 "${OUTDIR}"/LeftIOGinferioroccipitalgyrus
fslmaths "${SEG}" -thr 134 -uthr 134 "${OUTDIR}"/RightLiGlingualgyrus
fslmaths "${SEG}" -thr 135 -uthr 135 "${OUTDIR}"/LeftLiGlingualgyrus
fslmaths "${SEG}" -thr 144 -uthr 144 "${OUTDIR}"/RightMOGmiddleoccipitalgyrus
fslmaths "${SEG}" -thr 145 -uthr 145 "${OUTDIR}"/LeftMOGmiddleoccipitalgyrus
fslmaths "${SEG}" -thr 156 -uthr 156 "${OUTDIR}"/RightOCPoccipitalpole
fslmaths "${SEG}" -thr 157 -uthr 157 "${OUTDIR}"/LeftOCPoccipitalpole
fslmaths "${SEG}" -thr 160 -uthr 160 "${OUTDIR}"/RightOFuGoccipitalfusiformgyrus
fslmaths "${SEG}" -thr 161 -uthr 161 "${OUTDIR}"/LeftOFuGoccipitalfusiformgyrus
fslmaths "${SEG}" -thr 196 -uthr 196 "${OUTDIR}"/RightSOGsuperioroccipitalgyrus
fslmaths "${SEG}" -thr 197 -uthr 197 "${OUTDIR}"/LeftSOGsuperioroccipitalgyrus

fslmaths "${OUTDIR}"/RightCalccalcarinecortex -add "${OUTDIR}"/RightCuncuneus -add "${OUTDIR}"/RightIOGinferioroccipitalgyrus -add "${OUTDIR}"/RightLiGlingualgyrus -add "${OUTDIR}"/RightMOGmiddleoccipitalgyrus -add "${OUTDIR}"/RightOCPoccipitalpole -add "${OUTDIR}"/RightOFuGoccipitalfusiformgyrus -add "${OUTDIR}"/RightSOGsuperioroccipitalgyrus "${OUTDIR}"/RightOCC

fslmaths "${OUTDIR}"/LeftCalccalcarinecortex -add "${OUTDIR}"/LeftCuncuneus -add "${OUTDIR}"/LeftIOGinferioroccipitalgyrus -add "${OUTDIR}"/LeftLiGlingualgyrus -add "${OUTDIR}"/LeftMOGmiddleoccipitalgyrus -add "${OUTDIR}"/LeftOCPoccipitalpole -add "${OUTDIR}"/LeftOFuGoccipitalfusiformgyrus -add "${OUTDIR}"/LeftSOGsuperioroccipitalgyrus "${OUTDIR}"/LeftOCC

# TEMPORAL CORTEX:
echo "Segmenting the pariental cortex..."
fslmaths "${SEG}" -thr 116 -uthr 116 "${OUTDIR}"/RightEntentorhinalarea
fslmaths "${SEG}" -thr 117 -uthr 117 "${OUTDIR}"/LeftEntentorhinalarea
fslmaths "${SEG}" -thr 122 -uthr 122 "${OUTDIR}"/RightFuGfusiformgyrus
fslmaths "${SEG}" -thr 123 -uthr 123 "${OUTDIR}"/LeftFuGfusiformgyrus
fslmaths "${SEG}" -thr 132 -uthr 132 "${OUTDIR}"/RightITGinferiortemporalgyrus
fslmaths "${SEG}" -thr 133 -uthr 133 "${OUTDIR}"/LeftITGinferiortemporalgyrus
fslmaths "${SEG}" -thr 154 -uthr 154 "${OUTDIR}"/RightMTGmiddletemporalgyrus
fslmaths "${SEG}" -thr 155 -uthr 155 "${OUTDIR}"/LeftMTGmiddletemporalgyrus
fslmaths "${SEG}" -thr 170 -uthr 170 "${OUTDIR}"/RightPHGparahippocampalgyrus
fslmaths "${SEG}" -thr 171 -uthr 171 "${OUTDIR}"/LeftPHGparahippocampalgyrus
fslmaths "${SEG}" -thr 180 -uthr 180 "${OUTDIR}"/RightPPplanumpolare
fslmaths "${SEG}" -thr 181 -uthr 181 "${OUTDIR}"/LeftPPplanumpolare
fslmaths "${SEG}" -thr 184 -uthr 184 "${OUTDIR}"/RightPTplanumtemporale
fslmaths "${SEG}" -thr 185 -uthr 185 "${OUTDIR}"/LeftPTplanumtemporale
fslmaths "${SEG}" -thr 200 -uthr 200 "${OUTDIR}"/RightSTGsuperiortemporalgyrus
fslmaths "${SEG}" -thr 201 -uthr 201 "${OUTDIR}"/LeftSTGsuperiortemporalgyrus
fslmaths "${SEG}" -thr 202 -uthr 202 "${OUTDIR}"/RightTMPtemporalpole
fslmaths "${SEG}" -thr 203 -uthr 203 "${OUTDIR}"/LeftTMPtemporalpole
fslmaths "${SEG}" -thr 206 -uthr 206 "${OUTDIR}"/RightTTGtransversetemporalgyrus
fslmaths "${SEG}" -thr 207 -uthr 207 "${OUTDIR}"/LeftTTGtransversetemporalgyrus

fslmaths "${OUTDIR}"/RightEntentorhinalarea -add "${OUTDIR}"/RightFuGfusiformgyrus -add "${OUTDIR}"/RightITGinferiortemporalgyrus -add "${OUTDIR}"/RightMTGmiddletemporalgyrus -add "${OUTDIR}"/RightPHGparahippocampalgyrus -add "${OUTDIR}"/RightPPplanumpolare -add "${OUTDIR}"/RightPTplanumtemporale -add "${OUTDIR}"/RightSTGsuperiortemporalgyrus -add "${OUTDIR}"/RightTMPtemporalpole -add "${OUTDIR}"/RightTTGtransversetemporalgyrus "${OUTDIR}"/RightTMP

fslmaths "${OUTDIR}"/LeftEntentorhinalarea -add "${OUTDIR}"/LeftFuGfusiformgyrus -add "${OUTDIR}"/LeftITGinferiortemporalgyrus -add "${OUTDIR}"/LeftMTGmiddletemporalgyrus -add "${OUTDIR}"/LeftPHGparahippocampalgyrus -add "${OUTDIR}"/LeftPPplanumpolare -add "${OUTDIR}"/LeftPTplanumtemporale -add "${OUTDIR}"/LeftSTGsuperiortemporalgyrus -add "${OUTDIR}"/LeftTMPtemporalpole -add "${OUTDIR}"/LeftTTGtransversetemporalgyrus "${OUTDIR}"/LeftTMP

# SOMATO-SENSORY CORTEX:
echo "Segmenting somato-sensory cortex..."
fslmaths "${SEG}" -thr 148 -uthr 148 "${OUTDIR}"/RightMPoGpostcentralgyrusmedialsegment
fslmaths "${SEG}" -thr 149 -uthr 149 "${OUTDIR}"/LeftMPoGpostcentralgyrusmedialsegment
fslmaths "${SEG}" -thr 176 -uthr 176 "${OUTDIR}"/RightPoGpostcentralgyrus
fslmaths "${SEG}" -thr 177 -uthr 177 "${OUTDIR}"/LeftPoGpostcentralgyrus

fslmaths "${OUTDIR}"/RightPoGpostcentralgyrus -add "${OUTDIR}"/RightMPoGpostcentralgyrusmedialsegment "${OUTDIR}"/RightSS

fslmaths "${OUTDIR}"/LeftPoGpostcentralgyrus -add "${OUTDIR}"/LeftMPoGpostcentralgyrusmedialsegment  "${OUTDIR}"/LeftSS

# MOTOR CORTEX:
echo "Segmenting motor cortex..."
fslmaths "${SEG}" -thr 150 -uthr 150 "${OUTDIR}"/RightMPrGprecentralgyrusmedialsegment
fslmaths "${SEG}" -thr 151 -uthr 151 "${OUTDIR}"/LeftMPrGprecentralgyrusmedialsegment
fslmaths "${SEG}" -thr 182 -uthr 182 "${OUTDIR}"/RightPrGprecentralgyrus
fslmaths "${SEG}" -thr 183 -uthr 183 "${OUTDIR}"/LeftPrGprecentralgyrus
fslmaths "${SEG}" -thr 192 -uthr 192 "${OUTDIR}"/RightSMCsupplementarymotorcortex
fslmaths "${SEG}" -thr 193 -uthr 193 "${OUTDIR}"/LeftSMCsupplementarymotorcortex

fslmaths "${OUTDIR}"/RightPrGprecentralgyrus -add "${OUTDIR}"/RightSMCsupplementarymotorcortex -add "${OUTDIR}"/RightMPrGprecentralgyrusmedialsegment "${OUTDIR}"/RightMT

fslmaths "${OUTDIR}"/LeftPrGprecentralgyrus -add "${OUTDIR}"/LeftSMCsupplementarymotorcortex -add "${OUTDIR}"/LeftMPrGprecentralgyrusmedialsegment "${OUTDIR}"/LeftMT

# SUBCORTICAL:
echo "Segmenting subcortical regions..."
fslmaths "${SEG}" -thr 31 -uthr 31 "${OUTDIR}"/RightAmygdala
fslmaths "${SEG}" -thr 32 -uthr 32 "${OUTDIR}"/LeftAmygdala
fslmaths "${SEG}" -thr 47 -uthr 47 "${OUTDIR}"/RightHippocampus
fslmaths "${SEG}" -thr 48 -uthr 48 "${OUTDIR}"/LeftHippocampus
fslmaths "${SEG}" -thr 57 -uthr 57 "${OUTDIR}"/RightPutamen
fslmaths "${SEG}" -thr 58 -uthr 58 "${OUTDIR}"/LeftPutamen
fslmaths "${SEG}" -thr 59 -uthr 59 "${OUTDIR}"/RightThalamusProper
fslmaths "${SEG}" -thr 60 -uthr 60 "${OUTDIR}"/LeftThalamusProper
fslmaths "${SEG}" -thr 102 -uthr 102 "${OUTDIR}"/RightAInsanteriorinsula
fslmaths "${SEG}" -thr 103 -uthr 103 "${OUTDIR}"/LeftAInsanteriorinsula
fslmaths "${SEG}" -thr 172 -uthr 172 "${OUTDIR}"/RightPInsposteriorinsula
fslmaths "${SEG}" -thr 173 -uthr 173 "${OUTDIR}"/LeftPInsposteriorinsula
fslmaths "${SEG}" -thr 75 -uthr 75 "${OUTDIR}"/LeftBasalForebrain
fslmaths "${SEG}" -thr 76 -uthr 76 "${OUTDIR}"/RightBasalForebrain
fslmaths "${SEG}" -thr 36 -uthr 36 "${OUTDIR}"/RightCaudate
fslmaths "${SEG}" -thr 37 -uthr 37 "${OUTDIR}"/LeftCaudate
fslmaths "${SEG}" -thr 23 -uthr 23 "${OUTDIR}"/RightAccumbensArea
fslmaths "${SEG}" -thr 30 -uthr 30 "${OUTDIR}"/LeftAccumbensArea
fslmaths "${SEG}" -thr 55 -uthr 55 "${OUTDIR}"/RightPallidum
fslmaths "${SEG}" -thr 56 -uthr 56 "${OUTDIR}"/LeftPallidum

# OTHER CORTICAL:
echo "Segmenting other cortical areas..."
fslmaths "${SEG}" -thr 138 -uthr 138 "${OUTDIR}"/RightMCgGmiddlecingulategyrus
fslmaths "${SEG}" -thr 139 -uthr 139 "${OUTDIR}"/LeftMCgGmiddlecingulategyrus
fslmaths "${SEG}" -thr 112 -uthr 112 "${OUTDIR}"/RightCOcentraloperculum
fslmaths "${SEG}" -thr 113 -uthr 113 "${OUTDIR}"/LeftCOcentraloperculum

# OTHERS:
echo "Segmenting cerebellum and CSF..."
fslmaths "${SEG}" -thr 4 -uthr 4 "${OUTDIR}"/3rdVentricle
fslmaths "${SEG}" -thr 11 -uthr 11 "${OUTDIR}"/4thVentricle
fslmaths "${SEG}" -thr 35 -uthr 35 "${OUTDIR}"/BrainStem
fslmaths "${SEG}" -thr 38 -uthr 38 "${OUTDIR}"/RightCerebellumExterior
fslmaths "${SEG}" -thr 39 -uthr 39 "${OUTDIR}"/LeftCerebellumExterior
fslmaths "${SEG}" -thr 40 -uthr 40 "${OUTDIR}"/RightCerebellumWhiteMatter
fslmaths "${SEG}" -thr 41 -uthr 41 "${OUTDIR}"/LeftCerebellumWhiteMatter
fslmaths "${SEG}" -thr 44 -uthr 44 "${OUTDIR}"/RightCerebralWhiteMatter
fslmaths "${SEG}" -thr 45 -uthr 45 "${OUTDIR}"/LeftCerebralWhiteMatter
fslmaths "${SEG}" -thr 49 -uthr 49 "${OUTDIR}"/RightInfLatVent
fslmaths "${SEG}" -thr 50 -uthr 50 "${OUTDIR}"/LeftInfLatVent
fslmaths "${SEG}" -thr 51 -uthr 51 "${OUTDIR}"/RightLateralVentricle
fslmaths "${SEG}" -thr 52 -uthr 52 "${OUTDIR}"/LeftLateralVentricle
fslmaths "${SEG}" -thr 61 -uthr 61 "${OUTDIR}"/RightVentralDC
fslmaths "${SEG}" -thr 62 -uthr 62 "${OUTDIR}"/LeftVentralDC
fslmaths "${SEG}" -thr 71 -uthr 71 "${OUTDIR}"/CerebellarVermalLobulesI-V
fslmaths "${SEG}" -thr 72 -uthr 72 "${OUTDIR}"/CerebellarVermalLobulesVI-VII
fslmaths "${SEG}" -thr 73 -uthr 73 "${OUTDIR}"/CerebellarVermalLobulesVIII-X

# 2. GENERATE A MASK FOR THE RIGHT AND LEFT HEMISPHERE
fslmaths "${OUTDIR}"/LeftACgGanteriorcingulategyrus -add "${OUTDIR}"/LeftAInsanteriorinsula -add "${OUTDIR}"/LeftAOrGanteriororbitalgyrus -add "${OUTDIR}"/LeftAccumbensArea -add "${OUTDIR}"/LeftAmygdala -add "${OUTDIR}"/LeftAnGangulargyrus -add "${OUTDIR}"/LeftBasalForebrain -add "${OUTDIR}"/LeftCOcentraloperculum -add "${OUTDIR}"/LeftCalccalcarinecortex -add "${OUTDIR}"/LeftCaudate -add "${OUTDIR}"/LeftCerebellumExterior -add "${OUTDIR}"/LeftCerebellumWhiteMatter -add "${OUTDIR}"/LeftCerebralWhiteMatter -add "${OUTDIR}"/LeftCuncuneus -add "${OUTDIR}"/LeftEntentorhinalarea -add "${OUTDIR}"/LeftFOfrontaloperculum -add "${OUTDIR}"/LeftFRPfrontalpole -add "${OUTDIR}"/LeftFuGfusiformgyrus -add "${OUTDIR}"/LeftGRegyrusrectus -add "${OUTDIR}"/LeftHippocampus -add "${OUTDIR}"/LeftIOGinferioroccipitalgyrus -add "${OUTDIR}"/LeftITGinferiortemporalgyrus -add "${OUTDIR}"/LeftInfLatVent -add "${OUTDIR}"/LeftLOrGlateralorbitalgyrus -add "${OUTDIR}"/LeftLateralVentricle -add "${OUTDIR}"/LeftLiGlingualgyrus -add "${OUTDIR}"/LeftMCgGmiddlecingulategyrus -add "${OUTDIR}"/LeftMFCmedialfrontalcortex -add "${OUTDIR}"/LeftMFGmiddlefrontalgyrus -add "${OUTDIR}"/LeftMOGmiddleoccipitalgyrus -add "${OUTDIR}"/LeftMOrGmedialorbitalgyrus -add "${OUTDIR}"/LeftMPoGpostcentralgyrusmedialsegment -add "${OUTDIR}"/LeftMPrGprecentralgyrusmedialsegment -add "${OUTDIR}"/LeftMSFGsuperiorfrontalgyrusmedialsegment -add "${OUTDIR}"/LeftMTGmiddletemporalgyrus -add "${OUTDIR}"/LeftOCPoccipitalpole -add "${OUTDIR}"/LeftOFuGoccipitalfusiformgyrus -add "${OUTDIR}"/LeftOpIFGopercularpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/LeftOrIFGorbitalpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/LeftPCgGposteriorcingulategyrus -add "${OUTDIR}"/LeftPCuprecuneus -add "${OUTDIR}"/LeftPHGparahippocampalgyrus -add "${OUTDIR}"/LeftPInsposteriorinsula -add "${OUTDIR}"/LeftPOparietaloperculum -add "${OUTDIR}"/LeftPOrGposteriororbitalgyrus -add "${OUTDIR}"/LeftPPplanumpolare -add "${OUTDIR}"/LeftPTplanumtemporale -add "${OUTDIR}"/LeftPallidum -add "${OUTDIR}"/LeftPoGpostcentralgyrus -add "${OUTDIR}"/LeftPrGprecentralgyrus -add "${OUTDIR}"/LeftPutamen -add "${OUTDIR}"/LeftSCAsubcallosalarea -add "${OUTDIR}"/LeftSFGsuperiorfrontalgyrus -add "${OUTDIR}"/LeftSMCsupplementarymotorcortex -add "${OUTDIR}"/LeftSMGsupramarginalgyrus -add "${OUTDIR}"/LeftSOGsuperioroccipitalgyrus -add "${OUTDIR}"/LeftSPLsuperiorparietallobule -add "${OUTDIR}"/LeftSTGsuperiortemporalgyrus -add "${OUTDIR}"/LeftTMPtemporalpole -add "${OUTDIR}"/LeftTTGtransversetemporalgyrus -add "${OUTDIR}"/LeftThalamusProper -add "${OUTDIR}"/LeftTrIFGtriangularpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/LeftVentralDC "${OUTDIR}"/LeftHemisphere

fslmaths "${OUTDIR}"/RightACgGanteriorcingulategyrus -add "${OUTDIR}"/RightAInsanteriorinsula -add "${OUTDIR}"/RightAOrGanteriororbitalgyrus -add "${OUTDIR}"/RightAccumbensArea -add "${OUTDIR}"/RightAmygdala -add "${OUTDIR}"/RightAnGangulargyrus -add "${OUTDIR}"/RightBasalForebrain -add "${OUTDIR}"/RightCOcentraloperculum -add "${OUTDIR}"/RightCalccalcarinecortex -add "${OUTDIR}"/RightCaudate -add "${OUTDIR}"/RightCerebellumExterior -add "${OUTDIR}"/RightCerebellumWhiteMatter -add "${OUTDIR}"/RightCerebralWhiteMatter -add "${OUTDIR}"/RightCuncuneus -add "${OUTDIR}"/RightEntentorhinalarea -add "${OUTDIR}"/RightFOfrontaloperculum -add "${OUTDIR}"/RightFRPfrontalpole -add "${OUTDIR}"/RightFuGfusiformgyrus -add "${OUTDIR}"/RightGRegyrusrectus -add "${OUTDIR}"/RightHippocampus -add "${OUTDIR}"/RightIOGinferioroccipitalgyrus -add "${OUTDIR}"/RightITGinferiortemporalgyrus -add "${OUTDIR}"/RightInfLatVent -add "${OUTDIR}"/RightLOrGlateralorbitalgyrus -add "${OUTDIR}"/RightLateralVentricle -add "${OUTDIR}"/RightLiGlingualgyrus -add "${OUTDIR}"/RightMCgGmiddlecingulategyrus -add "${OUTDIR}"/RightMFCmedialfrontalcortex -add "${OUTDIR}"/RightMFGmiddlefrontalgyrus -add "${OUTDIR}"/RightMOGmiddleoccipitalgyrus -add "${OUTDIR}"/RightMOrGmedialorbitalgyrus -add "${OUTDIR}"/RightMPoGpostcentralgyrusmedialsegment -add "${OUTDIR}"/RightMPrGprecentralgyrusmedialsegment -add "${OUTDIR}"/RightMSFGsuperiorfrontalgyrusmedialsegment -add "${OUTDIR}"/RightMTGmiddletemporalgyrus -add "${OUTDIR}"/RightOCPoccipitalpole -add "${OUTDIR}"/RightOFuGoccipitalfusiformgyrus -add "${OUTDIR}"/RightOpIFGopercularpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/RightOrIFGorbitalpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/RightPCgGposteriorcingulategyrus -add "${OUTDIR}"/RightPCuprecuneus -add "${OUTDIR}"/RightPHGparahippocampalgyrus -add "${OUTDIR}"/RightPInsposteriorinsula -add "${OUTDIR}"/RightPOparietaloperculum -add "${OUTDIR}"/RightPOrGposteriororbitalgyrus -add "${OUTDIR}"/RightPPplanumpolare -add "${OUTDIR}"/RightPTplanumtemporale -add "${OUTDIR}"/RightPallidum -add "${OUTDIR}"/RightPoGpostcentralgyrus -add "${OUTDIR}"/RightPrGprecentralgyrus -add "${OUTDIR}"/RightPutamen -add "${OUTDIR}"/RightSCAsubcallosalarea -add "${OUTDIR}"/RightSFGsuperiorfrontalgyrus -add "${OUTDIR}"/RightSMCsupplementarymotorcortex -add "${OUTDIR}"/RightSMGsupramarginalgyrus -add "${OUTDIR}"/RightSOGsuperioroccipitalgyrus -add "${OUTDIR}"/RightSPLsuperiorparietallobule -add "${OUTDIR}"/RightSTGsuperiortemporalgyrus -add "${OUTDIR}"/RightTMPtemporalpole -add "${OUTDIR}"/RightTTGtransversetemporalgyrus -add "${OUTDIR}"/RightThalamusProper -add "${OUTDIR}"/RightTrIFGtriangularpartoftheinferiorfrontalgyrus -add "${OUTDIR}"/RightVentralDC "${OUTDIR}"/RightHemisphere

fslmaths "${OUTDIR}"/LeftHemisphere -sub "${OUTDIR}"/LeftThalamusProper -sub "${OUTDIR}"/LeftCerebralWhiteMatter "${OUTDIR}"/LeftGMcortex

fslmaths "${OUTDIR}"/RightHemisphere -sub "${OUTDIR}"/RightThalamusProper -sub "${OUTDIR}"/RightCerebralWhiteMatter "${OUTDIR}"/RightGMcortex
