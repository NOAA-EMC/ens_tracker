#!/bin/ksh
export PS4=' + extrkr_g2.sh line $LINENO: '

set +x
##############################################################################
echo " "
echo "------------------------------------------------"
echo "         TC Track in model GRIB2 output         "
echo "     Models:GFS, GEFS, CENS, FENS, NAVGEM       "
echo "------------J.Peng Jan.21, 2015 ----------------"
echo "Current time is: `date`"
echo " "
##############################################################################
set -x

loopnum=$1
cmodel=$2
ymdh=$3
pert=$4
TRKDATA=$5

#userid=$LOGNAME
export trkrtype=tracker
export gribver=2

USE_OPER_VITALS=YES
# USE_OPER_VITALS=NO
# USE_OPER_VITALS=INIT_ONLY

##############################################################################
#
#    FLOW OF CONTROL
#
# 1. Define data directories and file names for the input model 
# 2. Process input starting date/cycle information
# 3. Update TC Vitals file and select storms to be processed
# 4. Cut apart input GRIB files to select only the needed parms and hours
# 5. Execute the tracker
# 6. Copy the output track files to various locations
#
##############################################################################
msg="has begun for ${cmodel} ${pert} at ${cyc}z"
postmsg "$jlogfile" "$msg"

# This script runs the hurricane tracker using operational GRIB model output.  
# This script makes sure that the data files exist, it then pulls all of the 
# needed data records out of the various GRIB forecast files and puts them 
# into one, consolidated GRIB file, and then runs a program that reads the TC 
# Vitals records for the input day and updates the TC Vitals (if necessary).
# It then runs gettrk, which actually does the tracking.
# 
# Environmental variable inputs needed for this scripts:
#  PDY   -- The date for data being processed, in YYYYMMDD format
#  cyc   -- The numbers for the cycle for data being processed (00, 06, 12, 18)
#  cmodel -- Model being processed (gfs, mrf, ukmet, ecmwf, nam, ngm, ngps,
#                                   gdas, gfdl, ens (ncep ensemble))
#  envir -- 'prod' or 'test'
#  SENDCOM -- 'YES' or 'NO'
#  stormenv -- This is only needed by the tracker run for the GFDL model.
#              'stormenv' contains the name/id that is used in the input
#              grib file names.
#  pert  -- This is only needed by the tracker run for the NCEP ensemble.
#           'pert' contains the ensemble member id (e.g., n2, p4, etc.)
#           which is used as part of the grib file names.
#
# For testing script interactively in non-production set following vars:
#     gltrkdir   - Directory for output tracks
#     archsyndir - Directory with syndir scripts/exec/fix 
#

qid=$$
#----------------------------------------------#
#   Get input date information                 #
#----------------------------------------------#

export jobid=${jobid:-testjob}
export SENDCOM=${SENDCOM:-NO}
export PHASEFLAG=n
export WCORE_DEPTH=1.0
#export PHASE_SCHEME=vtt
#export PHASE_SCHEME=cps
export PHASE_SCHEME=both
export STRUCTFLAG=n
export IKEFLAG=n

# Define tracker working directory for this ensemble member

if [ ! -d $TRKDATA ]
then
   mkdir -p $TRKDATA
fi
cd $TRKDATA

if [ ${#PDY} -eq 0 -o ${#cyc} -eq 0 -o ${#cmodel} -eq 0 ]
then
  set +x
  echo " "
  echo "FATAL ERROR:  Something wrong with input parameters."
  echo "PDY= ${PDY}, cyc= ${cyc}, cmodel= ${cmodel}"
  set -x
  err_exit "FAILED ${jobid} -- BAD INPUTS AT LINE $LINENO IN TRACKER SCRIPT - ABNORMAL EXIT"
else
  set +x
  echo " "
  echo " #-----------------------------------------------------------------#"
  echo " At beginning of tracker script, the following imported variables "
  echo " are defined: "
  echo "   PDY ................................... $PDY"
  echo "   cyc ................................... $cyc"
  echo "   cmodel ................................ $cmodel"
  echo "   jobid ................................. $jobid"
  echo "   envir ................................. $envir"
  echo "   SENDCOM ............................... $SENDCOM"
  echo " "
  set -x
fi

scc=`echo ${PDY} | cut -c1-2`
syy=`echo ${PDY} | cut -c3-4`
smm=`echo ${PDY} | cut -c5-6`
sdd=`echo ${PDY} | cut -c7-8`
shh=${cyc}
symd=`echo ${PDY} | cut -c3-8`
syyyy=`echo ${PDY} | cut -c1-4`
CENT=`echo ${PDY} | cut -c1-2`

#------J.Peng----01-21-2015---------
#export COMOUTatcf=${COMOUTatcf:-${COMROOT}/nhc/${envir}/atcf}
#export archsyndir=${archsyndir:-${COMROOT}/arch/prod/syndat}
archsyndir=${archsyndir:-${COMINsyn:?}}
#export gltrkdir=${gltrkdir:-${COMROOT}/hur/${envir}/global}
gltrkdir=${gltrkdir:-${COMOUThur:?}}

#----------------------------------------------------------------#
#
#    --- Define data directories and data file names ---
#               
# Convert the input model to lowercase letters and check to see 
# if it's a valid model, and assign a model ID number to it.  
# This model ID number is passed into the Fortran program to 
# let the program know what set of forecast hours to use in the 
# ifhours array.  Also, set the directories for the operational 
# input GRIB data files and create templates for the file names.
#
#----------------------------------------------------------------#

cmodel=`echo ${cmodel} | tr "[A-Z]" "[a-z]"`

case ${cmodel} in

  gfs) set +x; echo " "                                    ;
       echo " ++ operational GFS chosen"                   ;
       echo " "; set -x                                    ;
#       gfsdir=${gfsdir:-${COMROOT}/gfs/prod/gfs.${PDY}}    ;
       gfsdir=${gfsdir:-${COMINgfs:?}/${cyc}/atmos}                     ;
       gfsgfile=gfs.t${cyc}z.pgrb2.0p25.f                  ;

       vit_incr=6                                          ;
       fcstlen=240                                         ;
       fcsthrs=$(seq -w -s' ' 0 $vit_incr $fcstlen)        ;
       atcfnum=15                                          ;
       atcfname="avnx"                                     ;
       atcfout="avnx"                                      ;
       atcffreq=600                                        ;
       mslpthresh=0.0015                                   ;
       v850thresh=1.5000                                   ;
       modtyp='global'                                     ;
       file_sequence="onebig"                              ;
       lead_time_units='hours'                             ;
       g2_jpdtn=0                                          ;
       model=1                                             ;;

  ens) set +x; echo " "                                    ;
       echo " ++ operational ensemble member ${pert} chosen";
       echo " "; set -x                                    ;
       pert=` echo ${pert} | tr '[A-Z]' '[a-z]'`           ;
       PERT=` echo ${pert} | tr '[a-z]' '[A-Z]'`           ;
       
       ensdira=${ensdira:-${COMIN:?}/pgrb2ap5}             ;
       ensgfilea=ge${pert}.t${cyc}z.pgrb2a.0p50.f          ;
       ensdirb=${ensdirb:-${COMIN:?}/pgrb2bp5}             ;
       ensgfileb=ge${pert}.t${cyc}z.pgrb2b.0p50.f          ;

       vit_incr=6                                          ;
       fcstlen=192                                         ;
       fcsthrs=$(seq -w -s' ' 0 $vit_incr $fcstlen)        ;
       atcfnum=91                                          ;
       pert_posneg=` echo "${pert}" | cut -c1-1`           ;
       pert_num=`    echo "${pert}" | cut -c2-3`           ;
       atcfname="a${pert_posneg}${pert_num}"               ;
       atcfout="a${pert_posneg}${pert_num}"                ;
       atcffreq=600                                        ;
       mslpthresh=0.0015                                   ;
       v850thresh=1.5000                                   ;
       file_sequence="onebig"                              ;
       lead_time_units='hours'                             ;
       g2_jpdtn=1                                          ;
       modtyp='global'                                     ;
       model=10                                            ;;

  cmc) set +x; echo " "                                    ;
       echo " ++ operational CMC chosen"                   ;
       echo " "; set -x                                    ;
       cmcdir=${cmcdir:-${DCOM:?}}                         ;
       cmcgfile=CMC_glb_latlon.24x.24_${PDY}${cyc}_P       ;
       cmcgfile2=_NCEP.grib2                               ;

       vit_incr=6                                          ;
       fcstlen=240                                         ;
       fcsthrs=$(seq -w -s' ' 0 $vit_incr $fcstlen)        ;

       atcfnum=39                                          ;
       atcfname="cmc "                                     ;
       atcfout="cmc"                                      ;
       atcffreq=600                                        ;
       mslpthresh=0.0015                                   ;
       v850thresh=1.5000                                   ;
       modtyp='global'                                     ;
       file_sequence="onebig"                              ;
       lead_time_units='hours'                             ;
       g2_jpdtn=0                                          ;
       model=15                                             ;;

 cens) set +x; echo " "                                    ;
       echo " ++ Canadian ensemble member ${pert} chosen"  ;
       echo " "; set -x                                    ;
       pert=` echo ${pert} | tr '[A-Z]' '[a-z]'`           ;
       PERT=` echo ${pert} | tr '[a-z]' '[A-Z]'`           ;
#       ccedir=${ccedir:-${COMROOT}/gens/prod/cmce.${PDY}/${cyc}/pgrb2a};
#       ccedir=${ccedir:-${COMIN:?}/pgrb2a}                 ;
#       ccegfile=cmc_ge${pert}.t${cyc}z.pgrb2af             ;
#  2016121200_CMC_naefs_hr_latlon0p5x0p5_P210_010.grib2   ; 
       ccedir=${ccedir:-${DCOMbase:?}/${PDY}/wgrbbul/cmcens_gb2}   ;
       pert_num=`    echo "${pert}" | cut -c2-3`           ;
       ccegfile=${PDY}${cyc}_CMC_naefs_hr_latlon0p5x0p5_P             ;
       ccegfile2=_0${pert_num}.grib2             ;

       vit_incr=6                                          ;
       fcstlen=240                                         ;
#       fcsthrs=$(seq -f%02g -s' ' 0 $vit_incr $fcstlen)    ;
       fcsthrs=$(seq -w -s' ' 0 $vit_incr $fcstlen)        ;

       atcfnum=91                                          ;
       pert_posneg=` echo "${pert}" | cut -c1-1`           ;
       pert_num=`    echo "${pert}" | cut -c2-3`           ;
       atcfname="c${pert_posneg}${pert_num}"               ;
       atcfout="c${pert_posneg}${pert_num}"                ;

       atcffreq=600                                        ;
       mslpthresh=0.0015                                   ;
       v850thresh=1.5000                                   ;
       file_sequence="onebig"                              ;
       lead_time_units='hours'                             ;
       g2_jpdtn=1                                          ;
       modtyp='global'                                     ;
       model=16                                            ;;

  fens) set +x; echo " "                                   ;
       echo " ++ FNMOC ensemble member ${pert} chosen"     ;
       echo " "; set -x                                    ;
       pert=` echo ${pert} | tr '[A-Z]' '[a-z]'`           ;
       PERT=` echo ${pert} | tr '[a-z]' '[A-Z]'`           ;

#       fensdir=${fensdir:-${DCOMbase:?}/${PDY}/wgrbbul/fnmocens_gb2};
       fensdir=${fensdir:-${DCOM:?}}                       ;
       pert_num=`    echo "${pert}" | cut -c2-3`           ;
       fensgfile=ENSEMBLE.MET.fcst_et0${pert_num}.         ;
       gensgfile=.${PDY}${cyc}                             ;

       vit_incr=6                                          ;
       fcstlen=240                                         ;
       fcsthrs=$(seq -w -s' ' 0 $vit_incr $fcstlen)        ;
       atcfnum=91                                          ;
       pert_posneg=` echo "${pert}" | cut -c1-1`           ;
#       pert_num=`    echo "${pert}" | cut -c2-3`           ;
#       atcfname="f${pert_posneg}${pert_num}"               ;
#       atcfout="f${pert_posneg}${pert_num}"                ;
       atcfname="n${pert_posneg}${pert_num}"               ;
       atcfout="n${pert_posneg}${pert_num}"                ;

       atcffreq=600                                        ;
       mslpthresh=0.0015                                   ;
       v850thresh=1.5000                                   ;
       file_sequence="onebig"                              ;
       lead_time_units='hours'                             ;
       g2_jpdtn=1                                          ;
       modtyp='global'                                     ;
       model=22                                            ;;

  ngps) set +x                                             ;
       echo " "; echo " ++ operational NAVGEM chosen"      ;
       echo " "                                            ;
       set -x                                              ;

       ngpsdir=${ngpsdir:-${DCOM:?}}                       ;
#J.Peng-05-12-2016  ngpsgfile=navgem_${PDY}${cyc}f         ;
#       ngemgfile=.grib2                                    ;
       ngpsgfile=US058GMET-OPSbd2.NAVGEM                    ;
       ngemgfile=-${PDY}${cyc}-NOAA-halfdeg.gr2             ;

       vit_incr=6                                          ;
       fcstlen=180                                         ;
#J.Peng-05-12-2016   fcsthrs='000 006 012 018 024 030 036 042 048 054 060
#                066 072 084 096 108 120 132 144 156 168 180';
       fcsthrs=$(seq -f%03g -s' ' 0 $vit_incr $fcstlen)    ;
       atcfnum=29                                          ;
       atcfname="ngx"                                      ;
       atcfout="ngx"                                       ;
       atcffreq=600                                        ;
       mslpthresh=0.0015                                   ;
       v850thresh=1.5000                                   ;
       modtyp='global'                                     ;
       file_sequence="onebig"                              ;
       lead_time_units='hours'                             ;
       g2_jpdtn=0                                          ;
       model=7                                             ;;

  *) msg="FATAL ERROR:  Model $cmodel is not recognized."  ;
     echo "$msg"; postmsg $jlogfile "$msg"                 ;
     err_exit "FAILED ${jobid} -- UNKNOWN cmodel IN TRACKER SCRIPT - ABNORMAL EXIT";;

esac

if [ ${PHASEFLAG} = 'y' ]; then
  if [ ${cmodel} = "gfs" ]; then
    wgrib_parmlist="UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV ABSV:850 ABSV:700 MSLET HGT:900 HGT:850 HGT:800 HGT:750 HGT:700 HGT:650 HGT:600 HGT:550 HGT:500 HGT:450 HGT:400 HGT:350 HGT:300 TMP:500 TMP:450 TMP:400 TMP:350 TMP:300"

  elif [ ${cmodel} = "ngps" ]; then
    wgrib_parmlist="UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV PRMSL HGT:925 HGT:850 HGT:700 HGT:500 HGT:400 HGT:300 TMP:500 TMP:400 TMP:300"

  elif [ ${cmodel} = "ens" ]; then
    wgrib_parmlist="UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV ABSV:850 ABSV:700 MSLET HGT:925 HGT:850 HGT:700 HGT:500 HGT:400 HGT:300 TMP:500 TMP:400 TMP:300"

  elif [ ${cmodel} = "cens" ]; then
    wgrib_parmlist="UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV PRMSL HGT:925 HGT:850 HGT:700 HGT:500 HGT:250 TMP:500 TMP:250"

  elif [ ${cmodel} = "fens" ]; then
    wgrib_parmlist="UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV PRMSL HGT:925 HGT:850 HGT:700 HGT:500 HGT:250 TMP:500 TMP:250"
  fi

  wgrib_ec_hires_parmlist=" GH:850 GH:700 U:850 U:700 U:500 V:850 V:700 V:500 10U:sfc 10V:sfc MSL:sfc GH:300 GH:400 GH:500 GH:925 T:300 T:400 T:500"
else
  if [ ${cmodel} = "gfs" ]; then
    wgrib_parmlist=" HGT:850 HGT:700 UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV ABSV:850 ABSV:700 MSLET"
  elif [ ${cmodel} = "ens" ]; then
    wgrib_parmlist=" HGT:850 HGT:700 UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV ABSV:850 ABSV:700 MSLET"
  else
    wgrib_parmlist=" HGT:850 HGT:700 UGRD:850 UGRD:700 UGRD:500 VGRD:850 VGRD:700 VGRD:500 SurfaceU SurfaceV ABSV:850 ABSV:700 PRMSL"
  fi  
  wgrib_ec_hires_parmlist=" GH:850 GH:700 U:850 U:700 U:500 V:850 V:700 V:500 10U:sfc 10V:sfc MSL:sfc"
fi

#---------------------------------------------------------------#
#
#      --------  TC Vitals processing   --------
#
# Check Steve Lord's operational tcvitals file to see if any 
# vitals records were processed for this time by his system.  
# If there were, then you'll find a file in /com/gfs/prod/gfs.yymmdd 
# with the vitals in it.  Also check the raw TC Vitals file in
# /com/arch/prod/syndat , since this may contain storms that Steve's 
# system ignored (Steve's system will ignore all storms that are 
# either over land or very close to land);  We still want to track 
# these inland storms, AS LONG AS THEY ARE NHC STORMS (don't 
# bother trying to track inland storms that are outside of NHC's 
# domain of responsibility -- we don't need that info).
# UPDATE 3/27/09 MARCHOK: The SREF is run at off-synoptic times
#   (03,09,15,21Z).  There are no tcvitals issued at these offtimes,
#   so the updating of the "old" tcvitals is critical for running
#   the tracker on SREF.  For updating the old tcvitals for SREF,
#   we need to look 3h back, not 6h as for the other models that
#   run at synoptic times.
#--------------------------------------------------------------#

old_ymdh=`${NDATE:?} -${vit_incr} ${PDY}${cyc}`
old_4ymd=`echo ${old_ymdh} | cut -c1-8`
old_ymd=`echo ${old_ymdh} | cut -c3-8`
old_hh=`echo ${old_ymdh} | cut -c9-10`
old_str="${old_ymd} ${old_hh}00"

future_ymdh=`${NDATE:?} ${vit_incr} ${PDY}${cyc}`
future_4ymd=`echo ${future_ymdh} | cut -c1-8`
future_ymd=`echo ${future_ymdh} | cut -c3-8`
future_hh=`echo ${future_ymdh} | cut -c9-10`
future_str="${future_ymd} ${future_hh}00"

if [ ${modtyp} = 'global' ]
then
#  synvitdir=${COMROOT}/gfs/prod/gfs.${PDY}
  synvitdir=${COMINgfs:?}/${cyc}/atmos
  synvitfile=gfs.t${cyc}z.syndata.tcvitals.tm00
#  synvitold_dir=${COMROOT}/gfs/prod/gfs.${old_4ymd}
  synvitold_dir=${synvitdir%.*}.${old_4ymd}/${old_hh}
  synvitold_file=gfs.t${old_hh}z.syndata.tcvitals.tm00
#  synvitfuture_dir=${COMROOT}/gfs/prod/gfs.${future_4ymd}
  synvitfuture_dir=${synvitdir%.*}.${future_4ymd}/${future_hh}
  synvitfuture_file=gfs.t${future_hh}z.syndata.tcvitals.tm00
else
#  synvitdir=${COMROOT}/nam/prod/nam.${PDY}
  synvitdir=${COMINnam:?}
  synvitfile=nam.t${cyc}z.syndata.tcvitals.tm00
#  synvitold_dir=${COMROOT}/nam/prod/nam.${old_4ymd}
  synvitold_dir=${synvitdir%.*}.${old_4ymd}
  synvitold_file=nam.t${old_hh}z.syndata.tcvitals.tm00
#  synvitfuture_dir=${COMROOT}/nam/prod/nam.${future_4ymd}
  synvitfuture_dir=${synvitdir%.*}.${future_4ymd}
  synvitfuture_file=nam.t${future_hh}z.syndata.tcvitals.tm00
fi

set +x
echo " "
echo "              -----------------------------"
echo " "
echo " Now sorting and updating the TC Vitals file.  Please wait...."
echo " "
set -x

current_str="${symd} ${cyc}00"

if [ -s ${synvitdir}/${synvitfile} -o\
     -s ${synvitold_dir}/${synvitold_file} -o\
     -s ${synvitfuture_dir}/${synvitfuture_file} ]
then
  grep "${old_str}" ${synvitold_dir}/${synvitold_file}        \
                  >${TRKDATA}/tmpsynvit.${atcfout}.${PDY}${cyc}
  grep "${current_str}"  ${synvitdir}/${synvitfile}                  \
                 >>${TRKDATA}/tmpsynvit.${atcfout}.${PDY}${cyc}
  grep "${future_str}" ${synvitfuture_dir}/${synvitfuture_file}  \
                 >>${TRKDATA}/tmpsynvit.${atcfout}.${PDY}${cyc}
else
  set +x
  echo " "
  echo " There is no (synthetic) TC vitals file for ${cyc}z in ${synvitdir},"
  echo " nor is there a TC vitals file for ${old_hh}z in ${synvitold_dir}."
  echo " nor is there a TC vitals file for ${future_hh}z in ${synvitfuture_dir},"
  echo " Checking the raw TC Vitals file ....."
  echo " "
  set -x
fi

# Take the vitals from Steve Lord's /com/gfs/prod tcvitals file,
# and cat them with the NHC-only vitals from the raw, original
# /com/arch/prod/synda_tcvitals file.  Do this because the nwprod
# tcvitals file is the original tcvitals file, and Steve runs a
# program that ignores the vitals for a storm that's over land or
# even just too close to land, and for tracking purposes for the
# US regional models, we need these locations.  Only include these
# "inland" storm vitals for NHC (we're not going to track inland 
# storms that are outside of NHC's domain of responsibility -- we 
# don't need that info).  
# UPDATE 5/12/98 MARCHOK: awk logic is added to screen NHC 
#   vitals such as "89E TEST", since TPC 
#   does not want tracks for such storms.

grep "${old_str}" ${archsyndir}/syndat_tcvitals.${CENT}${syy}   | \
      grep -v TEST | awk 'substr($0,6,1) !~ /8/ {print $0}' \
      >${TRKDATA}/tmprawvit.${atcfout}.${PDY}${cyc}
grep "${current_str}"  ${archsyndir}/syndat_tcvitals.${CENT}${syy}   | \
      grep -v TEST | awk 'substr($0,6,1) !~ /8/ {print $0}' \
      >>${TRKDATA}/tmprawvit.${atcfout}.${PDY}${cyc}
grep "${future_str}" ${archsyndir}/syndat_tcvitals.${CENT}${syy} | \
      grep -v TEST | awk 'substr($0,6,1) !~ /8/ {print $0}' \
      >>${TRKDATA}/tmprawvit.${atcfout}.${PDY}${cyc}


# IMPORTANT:  When "cat-ing" these files, make sure that the vitals
# files from the "raw" TC vitals files are first in order and Steve's
# TC vitals files second.  This is because Steve's vitals file has
# been error-checked, so if we have a duplicate tc vitals record in
# these 2 files (very likely), program supvit.x below will
# only take the last vitals record listed for a particular storm in
# the vitals file (all previous duplicates are ignored, and Steve's
# error-checked vitals records are kept).

cat ${TRKDATA}/tmprawvit.${atcfout}.${PDY}${cyc} ${TRKDATA}/tmpsynvit.${atcfout}.${PDY}${cyc} \
        >${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}

#--------------------------------------------------------------#
# Now run a fortran program that will read all the TC vitals
# records for the current dtg and the dtg from 6h ago, and
# sort out any duplicates.  If the program finds a storm that
# was included in the vitals file 6h ago but not for the current
# dtg, this program updates the 6h-old first guess position
# and puts these updated records as well as the records from
# the current dtg into a temporary vitals file.  It is this
# temporary vitals file that is then used as the input for the
# tracking program.
#--------------------------------------------------------------#

oldymdh=`${NDATE:?} -${vit_incr} ${PDY}${cyc}`
oldyy=`echo ${oldymdh} | cut -c3-4`
oldmm=`echo ${oldymdh} | cut -c5-6`
olddd=`echo ${oldymdh} | cut -c7-8`
oldhh=`echo ${oldymdh} | cut -c9-10`
oldymd=${oldyy}${oldmm}${olddd}

futureymdh=`${NDATE:?} 6 ${PDY}${cyc}`
futureyy=`echo ${futureymdh} | cut -c3-4`
futuremm=`echo ${futureymdh} | cut -c5-6`
futuredd=`echo ${futureymdh} | cut -c7-8`
futurehh=`echo ${futureymdh} | cut -c9-10`
futureymd=${futureyy}${futuremm}${futuredd}

echo "&datenowin   dnow%yy=${syy}, dnow%mm=${smm},"       >${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}
echo "             dnow%dd=${sdd}, dnow%hh=${cyc}/"      >>${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}
echo "&dateoldin   dold%yy=${oldyy}, dold%mm=${oldmm},"    >>${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}
echo "             dold%dd=${olddd}, dold%hh=${oldhh}/"    >>${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}
echo "&datefuturein  dfuture%yy=${futureyy}, dfuture%mm=${futuremm},"  >>${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}
echo "               dfuture%dd=${futuredd}, dfuture%hh=${futurehh}/"  >>${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}
echo "&hourinfo  vit_hr_incr=${vit_incr}/"  >>${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}

numvitrecs=`cat ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc} | wc -l`
if [ ${numvitrecs} -eq 0 ]
then

  if [ ${trkrtype} = 'tracker' ]
  then
    set +x
    echo " "
    echo "!!! WARNING -- There are no vitals records for this time period."
    echo "!!! File ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc} is empty."
    echo "!!! It could just be that there are no storms for the current"
    echo "!!! time.  You may wish to check the date and submit this job again..."
    echo " "
    set -x
    exit 0
  fi

fi

# For tcgen cases, filter to use only vitals from the ocean 
# basin of interest....

if [ ${trkrtype} = 'tcgen' ]
  then

  if [ ${numvitrecs} -gt 0 ]
  then
    
    fullvitfile=${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}
    cp $fullvitfile ${TRKDATA}/vitals.all_basins.${atcfout}.${PDY}${cyc}
    basin=` echo $regtype | cut -c1-2`

    if [ ${basin} = 'al' ]; then
      cat $fullvitfile | awk '{if (substr($0,8,1) == "L") print $0}' \
               >${TRKDATA}/vitals.tcgen_al_only.${atcfout}.${PDY}${cyc}
      cp ${TRKDATA}/vitals.tcgen_al_only.${atcfout}.${PDY}${cyc} \
         ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}
    fi
    if [ ${basin} = 'ep' ]; then
      cat $fullvitfile | awk '{if (substr($0,8,1) == "E") print $0}' \
               >${TRKDATA}/vitals.tcgen_ep_only.${atcfout}.${PDY}${cyc}
      cp ${TRKDATA}/vitals.tcgen_ep_only.${atcfout}.${PDY}${cyc} \
         ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}
    fi
    if [ ${basin} = 'wp' ]; then
      cat $fullvitfile | awk '{if (substr($0,8,1) == "W") print $0}' \
               >${TRKDATA}/vitals.tcgen_wp_only.${atcfout}.${PDY}${cyc}
      cp ${TRKDATA}/vitals.tcgen_wp_only.${atcfout}.${PDY}${cyc} \
         ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}
    fi

    cat ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}

  fi
    
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Before running the program to read, sort and update the vitals,
# first run the vitals through some awk logic, the purpose of 
# which is to convert all the 2-digit years into 4-digit years.
# We need this logic to ensure that all the vitals going
# into supvit.f have uniform, 4-digit years in their records.
#
# 1/8/2000: sed code added by Tim Marchok due to the fact that 
#       some of the vitals were getting past the syndata/qctropcy
#       error-checking with a colon in them; the colon appeared
#       in the character immediately to the left of the date, which
#       was messing up the "(length($4) == 8)" statement logic.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

sed -e "s/\:/ /g"  ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc} > ${TRKDATA}/tempvit
mv ${TRKDATA}/tempvit ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}

awk '
{
  yycheck = substr($0,20,2)
  if ((yycheck == 20 || yycheck == 19) && (length($4) == 8)) {
    printf ("%s\n",$0)
  }
  else {
    if (yycheck >= 0 && yycheck <= 50) {
      printf ("%s20%s\n",substr($0,1,19),substr($0,20))
    }
    else {
      printf ("%s19%s\n",substr($0,1,19),substr($0,20))
    }
  }
} ' ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc} >${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}.y4

mv ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}.y4 ${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}

if [ ${numvitrecs} -gt 0 ]
then

  export pgm=supvit_g2
  . prep_step

  export FORT31=${TRKDATA}/vitals.${atcfout}.${PDY}${cyc}
  export FORT51=${TRKDATA}/vitals.upd.${atcfout}.${PDY}${cyc}

  msg="$pgm start for $atcfout at ${cyc}z"
  postmsg "$jlogfile" "$msg"

  ${EXECens_tracker}/supvit_g2 <${TRKDATA}/suv_input.${atcfout}.${PDY}${cyc}
  suvrcc=$?

  if [ ${suvrcc} -eq 0 ]
  then
    msg="$pgm end for $atcfout at ${cyc}z completed normally"
    postmsg "$jlogfile" "$msg"
  else
    set +x
    echo " "
    echo "FATAL ERROR:  An error occurred while running supvit.x, "
    echo "!!! which is the program that updates the TC Vitals file."
    echo "!!! Return code from supvit.x = ${suvrcc}"
    echo "!!! model= ${atcfout}, forecast initial time = ${PDY}${cyc}"
    echo " "
    set -x
    err_exit "FAILED ${jobid} - ERROR RUNNING supvit_g2 IN TRACKER SCRIPT- ABNORMAL EXIT"
  fi

else

  touch ${TRKDATA}/vitals.upd.${atcfout}.${PDY}${cyc}

fi

#-----------------------------------------------------------------
# In this section, check to see if the user requested the use of 
# operational TC vitals records for the initial time only.  This 
# option might be used for a retrospective medium range forecast
# in which the user wants to initialize with the storms that are
# currently there, but then let the model do its own thing for 
# the next 10 or 14 days....


if [ ${USE_OPER_VITALS} = 'INIT_ONLY' ]; then

  if [ ${init_flag} = 'yes' ]; then
    set +x
    echo " "
    echo "NOTE: User has requested that operational historical TC vitals be used,"
    echo "      but only for the initial time, which we are currently at."
    echo " "
    set -x
  else
    set +x
    echo " "
    echo "NOTE: User has requested that operational historical TC vitals be used,"
    echo "      but only for the initial time, which we are now *PAST*."
    echo " "
    set -x
    >${TRKDATA}/vitals.upd.${atcfout}.${PDY}${cyc}
  fi
    
elif [ ${USE_OPER_VITALS} = 'NO' ]; then
    
  set +x
  echo " "
  echo "NOTE: User has requested that historical vitals not be used...."
  echo " "
  set -x
  >${TRKDATA}/vitals.upd.${atcfout}.${PDY}${cyc}
    
fi

#------------------------------------------------------------------#
# Now select all storms to be processed, that is, process every
# storm that's listed in the updated vitals file for the current
# forecast hour.  If there are no storms for the current time,
# then exit.
#------------------------------------------------------------------#

numvitrecs=`cat ${TRKDATA}/vitals.upd.${atcfout}.${PDY}${cyc} | wc -l`
if [ ${numvitrecs} -eq 0 ]
then
  if [ ${trkrtype} = 'tracker' ]
  then
    set +x
    echo " "
    echo "!!! WARNING -- There are no vitals records for this time period "
    echo "!!! in the UPDATED vitals file."
    echo "!!! It could just be that there are no storms for the current"
    echo "!!! time.  You may wish to check the date and submit this job again..."
    echo " "
    set -x
    exit 0
  fi
fi

set +x
echo " "
echo " *--------------------------------*"
echo " |        STORM SELECTION         |"
echo " *--------------------------------*"
echo " "
set -x

ict=1
while [ $ict -le 15 ]
do
  stormflag[${ict}]=3
  let ict=ict+1
done

dtg_current="${symd} ${cyc}00"
stormmax=` grep "${dtg_current}" ${TRKDATA}/vitals.upd.${atcfout}.${PDY}${cyc} | wc -l`

if [ ${stormmax} -gt 15 ]
then
  stormmax=15
fi

sct=1
while [ ${sct} -le ${stormmax} ]
do
  stormflag[${sct}]=1
  let sct=sct+1
done


#---------------------------------------------------------------#
#
#    --------  "Genesis" Vitals processing   --------
#
# May 2006:  This entire genesis tracking system is being
# upgraded to more comprehensively track and categorize storms.
# One thing that has been missing from the tracking system is
# the ability to keep track of storms from one analysis cycle
# to the next.  That is, the current system has been very
# effective at tracking systems within a forecast, but we have
# no methods in place for keeping track of storms across
# difference initial times.  For example, if we are running
# the tracker on today's 00z GFS analysis, we will get a
# position for various storms at the analysis time.  But then
# if we go ahead and run again at 06z, we have no way of
# telling the tracker that we know about the 00z position of
# this storm.  We now address that problem by creating
# "genesis" vitals, that is, when a storm is found at an
# analysis time, we not only produce "atcfunix" output to
# detail the track & intensity of a found storm, but we also
# produce a vitals record that will be used for the next
# run of the tracker script.  These "genesis vitals" records
# will be of the format:
#
#  YYYYMMDDHH_AAAH_LLLLX_TYP
#
#    Where:
#
#      YYYYMMDDHH = Date the storm was FIRST identified
#                   by the tracker.
#             AAA = Abs(Latitude) * 10; integer value
#               H = 'N' for norther hem, 'S' for southern hem
#            LLLL = Abs(Longitude) * 10; integer value
#               X = 'E' for eastern hem, 'W' for western hem
#             TYP = Tropical cyclone storm id if this is a
#                   tropical cyclone (e.g., "12L", or "09W", etc).
#                   If this is one that the tracker instead "Found
#                   On the Fly (FOF)", we simply put those three
#                   "FOF" characters in there.
genvitfile=${COMINgenvit}/genesis.vitals.${cmodel}.${atcfout}.${CENT}${syy}
touch ${TRKDATA}/genvitals.${cmodel}.${atcfout}.${PDY}${cyc}

if [ -f $genvitfile ]; then
  d6ago_ymdh=` ${NDATE:?} -6 ${PDY}${cyc}`
  d6ago_4ymd=` echo ${d6ago_ymdh} | cut -c1-8`
  d6ago_ymd=` echo ${d6ago_ymdh} | cut -c3-8`
  d6ago_hh=`  echo ${d6ago_ymdh} | cut -c9-10`
  d6ago_str="${d6ago_ymd} ${d6ago_hh}00"
  
  d6ahead_ymdh=` ${NDATE:?} 6 ${PDY}${cyc}`
  d6ahead_4ymd=` echo ${d6ahead_ymdh} | cut -c1-8`
  d6ahead_ymd=` echo ${d6ahead_ymdh} | cut -c3-8`
  d6ahead_hh=`  echo ${d6ahead_ymdh} | cut -c9-10`
  d6ahead_str="${d6ahead_ymd} ${d6ahead_hh}00"
  
  syyyym6=` echo ${d6ago_ymdh} | cut -c1-4`
  smmm6=`   echo ${d6ago_ymdh} | cut -c5-6`
  sddm6=`   echo ${d6ago_ymdh} | cut -c7-8`
  shhm6=`   echo ${d6ago_ymdh} | cut -c9-10`
  
  syyyyp6=` echo ${d6ahead_ymdh} | cut -c1-4`
  smmp6=`   echo ${d6ahead_ymdh} | cut -c5-6`
  sddp6=`   echo ${d6ahead_ymdh} | cut -c7-8`
  shhp6=`   echo ${d6ahead_ymdh} | cut -c9-10`
  
  set +x
  echo " "
  echo " d6ago_str=    --->${d6ago_str}<---"
  echo " current_str=  --->${current_str}<---"
  echo " d6ahead_str=  --->${d6ahead_str}<---"
  echo " "
  #echo " Listing and contents of ${genvitfile} follow "
  #echo " for the times 6h ago, current and 6h ahead:"
  #echo " "
  set -x
  
  #ls -la ${COMINgenvit}/genesis.vitals.${atcfout}.${CENT}${syy}
  #cat ${COMINgenvit}/genesis.vitals.${atcfout}.${CENT}${syy}
  
  grep "${d6ago_str}"   ${genvitfile} >>${TRKDATA}/genvitals.${cmodel}.${atcfout}.${PDY}${cyc}
  grep "${current_str}" ${genvitfile} >>${TRKDATA}/genvitals.${cmodel}.${atcfout}.${PDY}${cyc}
  grep "${d6ahead_str}" ${genvitfile} >>${TRKDATA}/genvitals.${cmodel}.${atcfout}.${PDY}${cyc}
  
  num_gen_vits=`cat ${TRKDATA}/genvitals.${cmodel}.${atcfout}.${PDY}${cyc} | wc -l`
else
  echo "WARNING: Genesis Vitals from previous run(s) not found!"
fi

echo "&datenowin   dnow%yy=${syyyy}, dnow%mm=${smm},"          >${TRKDATA}/sgv_input.${atcfout}.${PDY}${cyc}
echo "             dnow%dd=${sdd}, dnow%hh=${cyc}/"           >>${TRKDATA}/sgv_input.${atcfout}.${PDY}${cyc}
echo "&date6agoin  d6ago%yy=${syyyym6}, d6ago%mm=${smmm6},"   >>${TRKDATA}/sgv_input.${atcfout}.${PDY}${cyc}
echo "             d6ago%dd=${sddm6}, d6ago%hh=${shhm6}/"     >>${TRKDATA}/sgv_input.${atcfout}.${PDY}${cyc}
echo "&date6aheadin  d6ahead%yy=${syyyyp6}, d6ahead%mm=${smmp6}," >>${TRKDATA}/sgv_input.${atcfout}.${PDY}${cyc}
echo "               d6ahead%dd=${sddp6}, d6ahead%hh=${shhp6}/"   >>${TRKDATA}/sgv_input.${atcfout}.${PDY}${cyc}

num_gen_vits=0

if [ ${num_gen_vits} -gt 0 ]
then
  export pgm=supvit_gen
  . prep_step

  export FORT31=${TRKDATA}/genvitals.${cmodel}.${atcfout}.${PDY}${cyc}
  export FORT51=${TRKDATA}/genvitals.upd.${cmodel}.${atcfout}.${PDY}${cyc}

  msg="$pgm start for $atcfout at ${cyc}z"
  postmsg "$jlogfile" "$msg"

  ${EXECens_tracker}/supvit_gen <${TRKDATA}/sgv_input.${atcfout}.${PDY}${cyc}
  sgvrcc=$?

  if [ ${sgvrcc} -eq 0 ]
  then
    msg="$pgm end for $atcfout at ${cyc}z completed normally"
    postmsg "$jlogfile" "$msg"
  else
    set +x
    echo " "
    echo "FATAL ERROR:  An error occurred while running supvit_gen, "
    echo "!!! which is the program that updates the genesis vitals file."
    echo "!!! Return code from supvit_gen = ${sgvrcc}"
    echo "!!! model= ${atcfout}, forecast initial time = ${PDY}${cyc}"
    echo " "
    set -x
    err_exit "FAILED ${jobid} - ERROR RUNNING SUPVIT_GEN IN TRACKER SCRIPT- ABNORMAL EXIT"
  fi
    
else
   
  touch ${TRKDATA}/genvitals.upd.${cmodel}.${atcfout}.${PDY}${cyc}
    
fi


#-----------------------------------------------------------------#
#
#         ------  CUT APART INPUT GRIB FILES  -------
#
# For the selected model, cut apart the GRIB input files in order
# to pull out only the variables that we need for the tracker.  
# Put these selected variables from all forecast hours into 1 big 
# GRIB file that we'll use as input for the tracker.
# 
#-----------------------------------------------------------------#

set +x
echo " "
echo " -----------------------------------------"
echo "   NOW CUTTING APART INPUT GRIB FILES TO "
echo "   CREATE 1 BIG GRIB INPUT FILE "
echo " -----------------------------------------"
echo " "
set -x

regflag=`grep NHC ${TRKDATA}/vitals.upd.${atcfout}.${PDY}${cyc} | wc -l`

# --------------------------------------------------
#   Process GFS data
# --------------------------------------------------

if [ ${model} -eq 1 ]
then

  if [ $loopnum -eq 1 ]
  then

    if [ -s ${TRKDATA}/gfsgribfile.${PDY}${cyc} ]
    then
      rm ${TRKDATA}/gfsgribfile.${PDY}${cyc}
    fi

    rm ${TRKDATA}/master.gfsgribfile.${PDY}${cyc}.f*
    rm ${TRKDATA}/gfsgribfile.${PDY}${cyc}.f*
    >${TRKDATA}/gfsgribfile.${PDY}${cyc}

    set +x
    echo " "
    echo "Time before gfs wgrib loop is `date`"
    echo " "
    set -x
  
    for fhour in ${fcsthrs}
    do
  
      if [ ! -s ${gfsdir:?}/${gfsgfile}${fhour} ]
      then
        set +x
        echo " "
        echo "FATAL ERROR:  GFS file is missing"
        echo "!!! Check for the existence of this file:"
        echo "!!!    GFS File: ${gfsdir}/${gfsgfile}${fhour}"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo " "
        set -x
        err_exit "FAILED ${jobid} - MISSING GFS FILE ${gfsdir}/${gfsgfile}${fhour} IN TRACKER SCRIPT - ABNORMAL EXIT"
      fi

      gfile=${gfsdir}/${gfsgfile}${fhour}
      ${WGRIB2:?} -s $gfile >gfs.ix
      export err=$?; err_chk

      for parm in ${wgrib_parmlist}
      do
        case ${parm} in
          "SurfaceU")
           grep "UGRD:10 m " gfs.ix | ${WGRIB2:?} -i $gfile -append -grib \
                              ${TRKDATA}/master.gfsgribfile.${PDY}${cyc}.f${fhour} ;;
            "SurfaceV")
           grep "VGRD:10 m " gfs.ix | ${WGRIB2:?} -i $gfile -append -grib \
                              ${TRKDATA}/master.gfsgribfile.${PDY}${cyc}.f${fhour} ;;
                     *)
           grep "${parm}" gfs.ix | ${WGRIB2:?} -i $gfile -append -grib \
                              ${TRKDATA}/master.gfsgribfile.${PDY}${cyc}.f${fhour} ;;
        esac
      done

      gfs_master_file=${TRKDATA}/master.gfsgribfile.${PDY}${cyc}.f${fhour}
      gfs_cat_file=${TRKDATA}/gfsgribfile.${PDY}${cyc}
      ${GRB2INDEX:?} ${gfs_master_file} ${gfs_master_file}.ix
      export err=$?; err_chk

      g1=${gfs_master_file}
      x1=${gfs_master_file}.ix
      cat ${gfs_master_file} >>${gfs_cat_file}

    done
  
    ${GRB2INDEX:?} ${TRKDATA}/gfsgribfile.${PDY}${cyc} ${TRKDATA}/gfsixfile.${PDY}${cyc}
    export err=$?; err_chk

#   --------------------------------------------
    if [ ${PHASEFLAG} = 'y' ]; then

    catfile=${TRKDATA}/gfs.${PDY}${cyc}.catfile
    >${catfile}

    for fhour in ${fcsthrs}
    do

      set +x
      echo " "
      echo "Date in interpolation for model= $cmodel and fhour= $fhour before = `date`"
      echo " "
      set -x

      ffile=${TRKDATA}/gfsgribfile.${PDY}${cyc}
      ifile=${TRKDATA}/gfsixfile.${PDY}${cyc}
      ${GRB2INDEX:?} $ffile $ifile
      export err=$?; err_chk

#      gparm=7
#      namelist=${TRKDATA}/vint_input.${PDY}${cyc}.z
#      . prep_step
#      echo "&timein ifcsthour=${fhour},"       >${namelist}
#      echo "        iparm=${gparm},"          >>${namelist}
#      echo "        gribver=${gribver},"      >>${namelist}
#      echo "        g2_jpdtn=${g2_jpdtn}/"    >>${namelist}
#      echo "        g2_model=${model}/"       >>${namelist}
#      ln -s -f ${ffile}                                       fort.11
#      ln -s -f ${FIXens_tracker}/gfs_hgt_levs.txt             fort.16
#      ln -s -f ${ifile}                                       fort.31
#      ln -s -f ${TRKDATA}/${cmodel}.${PDY}${cyc}.z.f${fhour}     fort.51
#      ${EXECens_tracker}/vint.x <${namelist}
#      rcc1=$?
  
#      gparm=11
#      namelist=${TRKDATA}/vint_input.${PDY}${cyc}.t
#      . prep_step
#      echo "&timein ifcsthour=${fhour},"       >${namelist}
#      echo "        iparm=${gparm},"          >>${namelist}
#      echo "        gribver=${gribver},"      >>${namelist}
#      echo "        g2_jpdtn=${g2_jpdtn}/"    >>${namelist}
#      echo "        g2_model=${model}/"       >>${namelist}
#      ln -s -f ${ffile}                                       fort.11
#      ln -s -f ${FIXens_tracker}/gfs_tmp_levs.txt             fort.16
#      ln -s -f ${ifile}                                       fort.31 
#      ln -s -f ${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}     fort.51
#      ${EXECens_tracker}/vint.x <${namelist}
#      rcc2=$?
  
      namelist=${TRKDATA}/tave_input.${PDY}${cyc}
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn}/"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
  
#      ffile=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}
#      ifile=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}.i

      . prep_step

      # Input files
      export FORT11=${ffile}
      export FORT31=${ifile}

      # Output file
      export FORT51=${TRKDATA}/${cmodel}.tave.${PDY}${cyc}.f${fhour}

      ${EXECens_tracker}/tave.x <${namelist}
      export err=$?; err_chk
#      rcc3=$?

#      if [ $rcc1 -eq 0 -a $rcc2 -eq 0 -a $rcc3 -eq 0 ]; then
#        echo " "
#      else
#        mailfile=${FIXens_tracker}/errmail.${cmodel}.${PDY}${cyc}
#        echo "FATAL ERROR:  CPS/WC interp failure for $cmodel ${PDY}${cyc}" >${mailfile}
#        mail -s "GFS Failure (CPS/WC int) $cmodel ${PDY}${cyc}" ${userid} <${mailfile}
#        err_exit
#      fi
    
      tavefile=${TRKDATA}/${cmodel}.tave.${PDY}${cyc}.f${fhour}
#      zfile=${TRKDATA}/${cmodel}.${PDY}${cyc}.z.f${fhour}
#      cat ${zfile} ${tavefile} >>${catfile}

      cat ${tavefile} >>${catfile}
#      rm $tavefile $zfile
    
      set +x
      echo " "
      echo "Date in interpolation for cmodel= $cmodel and fhour= $fhour after = `date`"
      echo " "
      set -x
    
    done
    fi

  fi

  gfile=${TRKDATA}/gfsgribfile.${PDY}${cyc}
  if [ ${PHASEFLAG} = 'y' ]; then
    cat ${catfile} >>${gfile}
  fi

  ifile=${TRKDATA}/gfsixfile.${PDY}${cyc}
  ${GRB2INDEX:?} ${gfile} ${ifile}
  export err=$?; err_chk

  gribfile=${TRKDATA}/gfsgribfile.${PDY}${cyc}
  ixfile=${TRKDATA}/gfsixfile.${PDY}${cyc}

fi

# --------------------------------------------------
#   Process NCEP Ensemble perturbation, if selected
# --------------------------------------------------

if [ ${model} -eq 10 ]
then

  if [ $loopnum -eq 1 ]
  then

    if [ -s ${TRKDATA}/ens${pert}gribfile.${PDY}${cyc} ]
    then
      rm ${TRKDATA}/ens${pert}gribfile.${PDY}${cyc}
    fi

    for fhour in ${fcsthrs}
    do

      if [ ! -s ${ensdira:?}/${ensgfilea}${fhour} ]
      then
        set +x
        echo " "
        echo "FATAL ERROR:  ENSEMBLE ${PERT} File missing: ${ensdira}/${ensgfilea}${fhour}"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo " "
        set -x
        err_exit "FAILED ${jobid} - MISSING GEFS FILE ${ensdira}/${ensgfilea}${fhour} IN TRACKER SCRIPT - ABNORMAL EXIT"
      fi

      gfile=${TRKDATA}/${ensgfilea}${fhour}
      cat ${ensdira}/${ensgfilea}${fhour} ${ensdirb}/${ensgfileb}${fhour} > $gfile

      ${WGRIB2:?} -s $gfile >ens.ix
      export err=$?; err_chk

      for parm in ${wgrib_parmlist}
      do
        case ${parm} in
	  "SurfaceU")
	  grep "UGRD:10 m " ens.ix | ${WGRIB2:?} -i $gfile -append -grib \
	                   ${TRKDATA}/ens${pert}gribfile.${PDY}${cyc} ;;
	  "SurfaceV")
	  grep "VGRD:10 m " ens.ix | ${WGRIB2:?} -i $gfile -append -grib \
	                   ${TRKDATA}/ens${pert}gribfile.${PDY}${cyc} ;;
	                *)
	  grep "${parm}" ens.ix | ${WGRIB2:?} -i $gfile -append -grib  \
	                  ${TRKDATA}/ens${pert}gribfile.${PDY}${cyc} ;;
	esac
      done
    done
    ${GRB2INDEX:?} ${TRKDATA}/ens${pert}gribfile.${PDY}${cyc} ${TRKDATA}/ens${pert}ixfile.${PDY}${cyc}
    export err=$?; err_chk

#   --------------------------------------------

    if [ ${PHASEFLAG} = 'y' ]; then
      catfile=${TRKDATA}/ens${pert}.${PDY}${cyc}.catfile
       >${catfile}

      for fhour in ${fcsthrs}
      do

        set +x
        echo " "
        echo "Date in interpolation for pert= $pert and fhour= $fhour before = `date`"
        echo " "
        set -x

        gfile=${TRKDATA}/ens${pert}gribfile.${PDY}${cyc}
        ifile=${TRKDATA}/ens${pert}ixfile.${PDY}${cyc}
        ${GRB2INDEX:?} $gfile $ifile
        export err=$?; err_chk

        gparm=7
        namelist=${TRKDATA}/vint_input.${PDY}${cyc}.z
        . prep_step
        echo "&timein ifcsthour=${fhour},"       >${namelist}
        echo "        iparm=${gparm},"          >>${namelist}
        echo "        gribver=${gribver},"      >>${namelist}
        echo "        g2_jpdtn=${g2_jpdtn}/"    >>${namelist}
        echo "        g2_model=${model}/"       >>${namelist}
        export FORT11=${gfile}
        export FORT16=${FIXens_tracker}/ens_hgt_levs.txt
        export FORT31=${ifile}
        export FORT51=${TRKDATA}/${cmodel}_${pert}.${PDY}${cyc}.z.f${fhour}
        ${EXECens_tracker}/vint.x <${namelist}
        rcc1=$?

        gparm=11
        namelist=${TRKDATA}/vint_input.${PDY}${cyc}.t
        . prep_step
        echo "&timein ifcsthour=${fhour},"       >${namelist}
        echo "        iparm=${gparm},"          >>${namelist}
        echo "        gribver=${gribver},"      >>${namelist}
        echo "        g2_jpdtn=${g2_jpdtn}/"    >>${namelist}
        echo "        g2_model=${model}/"       >>${namelist}
        export FORT11=${gfile}
        export FORT16=${FIXens_tracker}/ens_tmp_levs.txt
        export FORT31=${ifile}
        export FORT51=${TRKDATA}/${cmodel}_${pert}.${PDY}${cyc}.t.f${fhour}
        ${EXECens_tracker}/vint.x <${namelist}
        rcc2=$?

        namelist=${TRKDATA}/tave_input.${PDY}${cyc}
        . prep_step
        echo "&timein ifcsthour=${fhour},"       >${namelist}
        echo "        iparm=${gparm},"          >>${namelist}
        echo "        gribver=${gribver},"      >>${namelist}
        echo "        g2_jpdtn=${g2_jpdtn}/"    >>${namelist}
        echo "        g2_model=${model}/"       >>${namelist}
        ffile=${TRKDATA}/${cmodel}_${pert}.${PDY}${cyc}.t.f${fhour}
        ifile=${TRKDATA}/${cmodel}_${pert}.${PDY}${cyc}.t.f${fhour}.i
        ${GRB2INDEX:?} ${ffile} ${ifile}
        export err=$?; err_chk
        export FORT11=${ffile}
        export FORT31=${ifile}
        export FORT51=${TRKDATA}/${cmodel}_${pert}.tave.${PDY}${cyc}.f${fhour}
        ${EXECens_tracker}/tave.x <${namelist}
        rcc3=$?

        if [ $rcc1 -eq 0 -a $rcc2 -eq 0 -a $rcc3 -eq 0 ]; then
          echo " "
        else
#          mailfile=${FIXens_tracker}/errmail.${cmodel}.${pert}.${PDY}${cyc}
#          echo "CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}" >${mailfile}
#          mail -s "GEFS Failure (CPS/WC int) $cmodel $pert ${PDY}${cyc}" ${userid} <${mailfile}
          msg="FATAL ERROR:  CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}"
          echo "$msg"; postmsg $jlogfile "$msg"
          err_exit "$msg"
        fi

        tavefile=${TRKDATA}/${cmodel}_${pert}.tave.${PDY}${cyc}.f${fhour}
        zfile=${TRKDATA}/${cmodel}_${pert}.${PDY}${cyc}.z.f${fhour}
        cat ${zfile} ${tavefile} >>${catfile}
        rm $tavefile $zfile

        set +x
        echo " "
        echo "Date in interpolation for pert= $pert and fhour= $fhour after = `date`"
        echo " "
        set -x

      done
    fi 
  fi

  gfile=${TRKDATA}/ens${pert}gribfile.${PDY}${cyc}
  if [ ${PHASEFLAG} = 'y' ]; then
    cat ${catfile} >>${gfile}
  fi

  ifile=${TRKDATA}/ens${pert}ixfile.${PDY}${cyc}
  ${GRB2INDEX:?} ${gfile} ${ifile}
  export err=$?; err_chk

  gribfile=${TRKDATA}/ens${pert}gribfile.${PDY}${cyc}
  ixfile=${TRKDATA}/ens${pert}ixfile.${PDY}${cyc}

fi

# ------------------------------------------------------
#   Process Canadian (CMC) hi-res deterministic, if selected
# ------------------------------------------------------

if [ ${model} -eq 15 ]; then

  if [ $loopnum -eq 1 ]; then
    if [ -s ${TRKDATA}/cmcgribfile.${PDY}${cyc} ]; then
      rm ${TRKDATA}/cmcgribfile.${PDY}${cyc}
    fi

    for fhour in ${fcsthrs}; do
      if [ ! -s ${cmcdir}/${cmcgfile}${fhour}${cmcgfile2} ]; then
        set +x
        echo " "
        echo "FATAL ERROR:  CMC File missing ${cmcdir}/${cmcgfile}${fhour}${cmcgfile2}"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo " "
        set -x
      fi

      gfile=${cmcdir}/${cmcgfile}${fhour}${cmcgfile2}
      ${WGRIB2:?} -s $gfile >cmc.ix
      export err=$?; err_chk

      for parm in ${wgrib_parmlist}; do
        case ${parm} in
          "SurfaceU")
             grep "UGRD:10 m above" cmc.ix | ${WGRIB2:?} -i $gfile -append -grib \
                  ${TRKDATA}/cmcgribfile.${PDY}${cyc} ;;

          "SurfaceV")
             grep "VGRD:10 m above" cmc.ix | ${WGRIB2:?} -i $gfile -append -grib \
                  ${TRKDATA}/cmcgribfile.${PDY}${cyc} ;;
          *)
             grep "${parm}" cmc.ix | ${WGRIB2:?} -i $gfile -append -grib \
                  ${TRKDATA}/cmcgribfile.${PDY}${cyc} ;;
        esac
      done
    done
# J.Peng--04-05-2017--changing grid from 180E to 0E------------
#  wgrib2 junk -small_grib 0:359.76 -90:90 junk2
# J.Peng--10-09-2019----uncomment the next 4 lines --------
    cp ${TRKDATA}/cmcgribfile.${PDY}${cyc} ${TRKDATA}/junk
    rm -f ${TRKDATA}/cmcgribfile.${PDY}${cyc}
    ${WGRIB2} ${TRKDATA}/junk -small_grib 0:359.76 -90:90 ${TRKDATA}/junk2
    cp ${TRKDATA}/junk2 ${TRKDATA}/cmcgribfile.${PDY}${cyc} 

    ${GRB2INDEX:?} ${TRKDATA}/cmcgribfile.${PDY}${cyc} ${TRKDATA}/cmcixfile.${PDY}${cyc}
    export err=$?; err_chk

    if [ ${PHASEFLAG} = 'y' ]; then
    catfile=${TRKDATA}/${cmodel}.${PDY}${cyc}.catfile
    >${catfile}

    for fhour in ${fcsthrs}; do
      set +x
      echo " "
      echo "Date in interpolation for fhour= $fhour before = `date`"
      echo " "
      set -x

      gfile=${TRKDATA}/cmcgribfile.${PDY}${cyc}
      ifile=${TRKDATA}/cmcixfile.${PDY}${cyc}
      ${GRB2INDEX:?} $gfile $ifile
      export err=$?; err_chk

#     ----------------------------------------------------
#     First, interpolate height data to get data from
#     300 to 900 mb, every 50 mb....

      gparm=7
      . prep_step

      # Input files
      namelist=${TRKDATA}/vint_input.${PDY}${cyc}.z
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
      export FORT11=${gfile}
      export FORT16=${FIXens_tracker}/cmc_hgt_levs.txt
      export FORT31=${ifile}

      # Output file
      export FORT51=${TRKDATA}/${cmodel}.${PDY}${cyc}.z.f${fhour}

      ${EXECens_tracker}/vint_g2.x <${namelist}
      rcc=$?

      if [ $rcc -ne 0 ]; then
        set +x
        echo " "
        echo "FATAL ERROR in call to vint_g2.x for GPH at fhour= $fhour"
        echo "rcc= $rcc      EXITING.... "
        echo " "
        set -x
        err_exit "vint_g2.x- ERROR for GPH AT extrkr_g2.sh LINE $LINENO"
      fi

#     ----------------------------------------------------
#     Now interpolate temperature data to get data from
#     300 to 500 mb, every 50 mb....

      gparm=11
      . prep_step

      # Input files
      namelist=${TRKDATA}/vint_input.${PDY}${cyc}
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
      export FORT11=${gfile}
      export FORT16=${FIXens_tracker}/cmc_tmp_levs.txt
      export FORT31=${ifile}

      # Output file
      export FORT51=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}

      ${EXECens_tracker}/vint_g2.x <${namelist}
      rcc=$?

      if [ $rcc -ne 0 ]; then
        set +x
        echo " "
        echo "FATAL ERROR in call to vint_g2.x for T at fhour= $fhour"
        echo "rcc= $rcc      EXITING.... "
        echo " "
        set -x
        err_exit "vint_g2.x- ERROR for T AT extrkr_g2.sh LINE $LINENO"
      fi

#     ----------------------------------------------------
#     Now average the temperature data that we just
#     interpolated to get the mean 300-500 mb temperature...

      gparm=11
      ffile=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}
      ifile=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}.i
      ${GRB2INDEX:?} ${ffile} ${ifile}
      export err=$?; err_chk

      . prep_step

      # Input files
      namelist=${TRKDATA}/tave_input.${PDY}${cyc}
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
      export FORT11=${ffile}
      export FORT31=${ifile}

      # Output file
      export FORT51=${TRKDATA}/${cmodel}_tave.${PDY}${cyc}.f${fhour}

      ${EXECens_tracker}/tave_g2.x <${namelist}
      rcc=$?

      if [ $rcc -ne 0 ]; then
        set +x
        echo " "
        echo "FATAL ERROR in call to tave_g2.x at fhour= $fhour"
        echo "rcc= $rcc      EXITING.... "
        echo " "
        set -x
        err_exit "tave_g2.x- ERROR AT extrkr_g2.sh LINE $LINENO"
      fi

      tavefile=${TRKDATA}/${cmodel}_tave.${PDY}${cyc}.f${fhour}
      zfile=${TRKDATA}/${cmodel}.${PDY}${cyc}.z.f${fhour}
      cat ${zfile} ${tavefile} >>${catfile}

#J.Peng----2012-06-04---added for U-shear-----
      gparm=33
      ffile=${gfile}
      ifile=${TRKDATA}/cmcixfile.${PDY}${cyc}

      . prep_step

      # Input files
      namelist=${TRKDATA}/ushear_input.${PDY}${cyc}
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
      export FORT11=${ffile}
      export FORT31=${ifile}

      # Output file
      export FORT51=${TRKDATA}/${cmodel}_ushear.${PDY}${cyc}.f${fhour}

      ${EXECens_tracker}/ushear_g2.x <${namelist}
      rcc=$?

      if [ $rcc -ne 0 ]; then
        set +x
        echo " "
        echo "FATAL ERROR in call to ushear_g2.x at fhour= $fhour"
        echo "rcc= $rcc      EXITING.... "
        echo " "
        set -x
        err_exit "ushear_g2.x- ERROR AT extrkr_g2.sh LINE $LINENO"
      fi

      ushearfile=${TRKDATA}/${cmodel}_ushear.${PDY}${cyc}.f${fhour}
      cat ${ushearfile} >>${catfile}
#J.Peng----2012-06-04---added for U-shear-----

      set +x
      echo " "
      echo "Date in interpolation for fhour= $fhour after = `date`"
      echo " "
      set -x
    done
    fi
  fi

  gfile=${TRKDATA}/cmcgribfile.${PDY}${cyc}
  if [ ${PHASEFLAG} = 'y' ]; then
    cat ${catfile} >>${gfile}
  fi

  ifile=${TRKDATA}/cmcixfile.${PDY}${cyc}
  ${GRB2INDEX:?} ${gfile} ${ifile}
  export err=$?; err_chk

  gribfile=${TRKDATA}/cmcgribfile.${PDY}${cyc}
  ixfile=${TRKDATA}/cmcixfile.${PDY}${cyc}

fi

# ------------------------------------------------------
#   Process Canadian Ensemble perturbation, if selected
# ------------------------------------------------------
if [ ${model} -eq 16 ]; then
  if [ $loopnum -eq 1 ]; then

    if [ -s ${TRKDATA}/cce${pert}gribfile.${PDY}${cyc} ]; then
      rm ${TRKDATA}/cce${pert}gribfile.${PDY}${cyc}
    fi

    for fhour in ${fcsthrs}; do

#      if [ ! -s ${ccedir:?}/${ccegfile}${fhour} ]; then
      if [ ! -s ${ccedir:?}/${ccegfile}${fhour}${ccegfile2} ]; then
        set +x
        echo " "
#        echo "FATAL ERROR:  CANADIAN ENSEMBLE ${PERT} missing: ${ccegfile}${fhour}"
        echo "FATAL ERROR:  CANADIAN ENSEMBLE ${PERT} missing: ${ccegfile}${fhour}${ccegfile2}"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo " "
        set -x
        err_exit "FAILED ${jobid} - MISSING CMC ENSEMBLE FILE ${ccegfile}${fhour}${ccegfile2} IN TRACKER SCRIPT - ABNORMAL EXIT"
      fi

#      gfile=${ccedir}/${ccegfile}${fhour}
      gfile=${ccedir}/${ccegfile}${fhour}${ccegfile2}
      ${WGRIB2:?} -s $gfile >ens.ix
      export err=$?; err_chk

      for parm in ${wgrib_parmlist}; do
        case ${parm} in
	      "SurfaceU")
	        grep "UGRD:10 m " ens.ix | ${WGRIB2:?} -i $gfile -append -grib \
	                ${TRKDATA}/cce${pert}gribfile.${PDY}${cyc} ;;
          "SurfaceV")
	        grep "VGRD:10 m " ens.ix | ${WGRIB2:?} -i $gfile -append -grib \
	                ${TRKDATA}/cce${pert}gribfile.${PDY}${cyc} ;;
	      *)
            grep "${parm}" ens.ix | ${WGRIB2:?} -i $gfile -append -grib \
	                ${TRKDATA}/cce${pert}gribfile.${PDY}${cyc} ;;
        esac
      done
    done   

    ${GRB2INDEX:?} ${TRKDATA}/cce${pert}gribfile.${PDY}${cyc} ${TRKDATA}/cce${pert}ixfile.${PDY}${cyc}
    export err=$?; err_chk
#   Process the cyclone phase variables, if requested

    if [ ${PHASEFLAG} = 'y' ];  then
      catfile=${TRKDATA}/${cmodel}.${PDY}${cyc}.catfile
      >${catfile}

      for fhour in ${fcsthrs}; do

      set +x
	  echo " "
	  echo "Date in interpolation for fhour= $fhour before = `date`"
	  echo " "
	  set -x

	  gfile=${TRKDATA}/cce${pert}gribfile.${PDY}${cyc}
	  ifile=${TRKDATA}/cce${pert}ixfile.${PDY}${cyc}
	  ${GRB2INDEX:?} $gfile $ifile
      export err=$?; err_chk

#     ----------------------------------------------------
#     First, interpolate height data to get data from
#     300 to 900 mb, every 50 mb....
      gparm=7
	  namelist=${TRKDATA}/vint_input.${PDY}${cyc}.z
      . prep_step
	  echo "&timein ifcsthour=${fhour},"       >${namelist}
	  echo "        iparm=${gparm},"          >>${namelist}
	  echo "        gribver=${gribver},"      >>${namelist}
	  echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
	  echo "        g2_model=${model}/"       >>${namelist}
	  export FORT11=${gfile}
	  export FORT16=${FIXens_tracker}/${cmodel}_hgt_levs.txt
	  export FORT31=${ifile}
	  export FORT51=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.z.f${fhour}
	  ${EXECens_tracker}/vint.x <${namelist}
	  rcc1=$?

#     ----------------------------------------------------
#     Now interpolate temperature data to get data from
#     300 to 500 mb, every 50 mb....
      gparm=11
	  namelist=${TRKDATA}/vint_input.${PDY}${cyc}
      . prep_step
	  echo "&timein ifcsthour=${fhour}, iparm=${gparm}/"  >${namelist}
	  echo "&timein ifcsthour=${fhour},"       >${namelist}
	  echo "        iparm=${gparm},"          >>${namelist}
	  echo "        gribver=${gribver},"      >>${namelist}
	  echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
	  echo "        g2_model=${model}/"       >>${namelist}
	  export FORT11=${gfile}
	  export FORT16=${FIXens_tracker}/${cmodel}_tmp_levs.txt
	  export FORT31=${ifile}
	  export FORT51=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.t.f${fhour}
	  ${EXECens_tracker}/vint.x <${namelist}
	  rcc2=$?

#     ----------------------------------------------------
#     Now average the temperature data that we just
#     interpolated to get the mean 300-500 mb temperature...
      namelist=${TRKDATA}/tave_input.${PDY}${cyc}
      . prep_step
	  echo "&timein ifcsthour=${fhour},"       >${namelist}
	  echo "        iparm=${gparm},"          >>${namelist}
	  echo "        gribver=${gribver},"      >>${namelist}
	  echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
	  echo "        g2_model=${model}/"       >>${namelist}
	  ffile=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.t.f${fhour}
	  ifile=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.t.f${fhour}.i
	  ${GRB2INDEX:?} ${ffile} ${ifile}
      export err=$?; err_chk
	  export FORT11=${ffile}
	  export FORT31=${ifile}
	  export FORT51=${TRKDATA}/${cmodel}_tave.${pert}.${PDY}${cyc}.f${fhour}
	  ${EXECens_tracker}/tave.x <${namelist}
	  rcc3=$?

      if [ $rcc1 -eq 0 -a $rcc2 -eq 0 -a $rcc3 -eq 0 ]; then
	    echo " "
	  else
#        mailfile=${FIXens_tracker}/errmail.${cmodel}.${pert}.${PDY}${cyc}
#        echo "CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}" >${mailfile}
#        mail -s "ENS Failure (CPS/WC int) $cmodel $pert ${PDY}${cyc}" jiayi.peng@noaa.gov <${mailfile}
        msg="FATAL ERROR:  CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}"
        echo "$msg"; postmsg $jlogfile "$msg"
        err_exit "$msg"
	  fi

	  tavefile=${TRKDATA}/${cmodel}_tave.${pert}.${PDY}${cyc}.f${fhour}
	  zfile=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.z.f${fhour}
	  cat ${zfile} ${tavefile} >>${catfile}
#      rm $tavefile $zfile	

      set +x
      echo " "
      echo "Date in interpolation for fhour= $fhour after = `date`"
      echo " "
      set -x

      done
    fi  
  fi
  gfile=${TRKDATA}/cce${pert}gribfile.${PDY}${cyc}
  if [ ${PHASEFLAG} = 'y' ]; then
    cat ${catfile} >>${gfile}
  fi

  ifile=${TRKDATA}/cce${pert}ixfile.${PDY}${cyc}
  ${GRB2INDEX:?} ${gfile} ${ifile}
  export err=$?; err_chk
  gribfile=${TRKDATA}/cce${pert}gribfile.${PDY}${cyc}
  ixfile=${TRKDATA}/cce${pert}ixfile.${PDY}${cyc}

fi

# ------------------------------
#   Process FNMOC Ensemble, if selected
# ------------------------------
if [ ${model} -eq 22 ]
then
  if [ $loopnum -eq 1 ]
  then
    if [ -s ${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc} ]
    then
      rm ${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc}
    fi

    for fhour in ${fcsthrs}
    do

      fensfile=${fensdir}/${fensgfile}${fhour}${gensgfile}

      let attempts=1
      while [ $attempts -le 30 ]; do
        if [ -s $fensfile ]; then
           break
        else
          sleep 60
          let attempts=attempts+1
        fi
      done
      if [ $attempts -gt 30 ] && [ ! -s $fensfile ]; then
        if [ "$DCOM_STATUS" = "data of opportunity" ]; then
          echo "$fensfile" >> ${DATA}/missing_fens.txt
          exit
        else
          err_exit "$fensfile still not available after waiting 30 minutes... exiting"
        fi
      fi

      export pgm=wgrib2
      #${WGRIB2:?} -set_byte 1 11 1 -s $fensfile >fens.ix  # set_byte resets local table to 1 to remove error messages
      ${WGRIB2:?} -s $fensfile >fens.ix
      err=$?
      if [ $err -ne 0 ]; then
        err_exit "Error reading $fensfile"
      fi

      for parm in ${wgrib_parmlist}
      do
        case ${parm} in
	      "SurfaceU")
	          grep "UGRD:10 m " fens.ix | ${WGRIB2:?} -i $fensfile -append -grib \
	                    ${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc} ;;

          "SurfaceV")
	          grep "VGRD:10 m " fens.ix | ${WGRIB2:?} -i $fensfile -append -grib \
	                   ${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc} ;;
	      *)
              grep "${parm}" fens.ix | ${WGRIB2:?} -i $fensfile -append -grib \
	                    ${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc} ;;
        esac
      done
      unset pgm
    done

    ${GRB2INDEX:?} ${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc} ${TRKDATA}/fensixfile.${pert}.${PDY}${cyc}
    export err=$?; err_chk
#   --------------------------------------------
    if [ ${PHASEFLAG} = 'y' ]; then
    catfile=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.catfile
    >${catfile}

    for fhour in ${fcsthrs}
    do
      set +x
      echo " "
      echo "Date in interpolation for fhour= $fhour before = `date`"
      echo " "
      set -x

      gfile=${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc}
      ifile=${TRKDATA}/fensixfile.${pert}.${PDY}${cyc}
      ${GRB2INDEX:?} $gfile $ifile
      export err=$?; err_chk

#     ----------------------------------------------------
#     First, interpolate height data to get data from
#     300 to 900 mb, every 50 mb....
      gparm=7
      namelist=${TRKDATA}/vint_input.${pert}.${PDY}${cyc}.z
      . prep_step
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
      export FORT11=${gfile}
      export FORT16=${FIXens_tracker}/fens_hgt_levs.txt
      export FORT31=${ifile}
      export FORT51=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.z.f${fhour}
      ${EXECens_tracker}/vint.x <${namelist}
      rcc1=$?

#     ----------------------------------------------------
#     Now interpolate temperature data to get data from
#     300 to 500 mb, every 50 mb....
      gparm=11
      namelist=${TRKDATA}/vint_input.${pert}.${PDY}${cyc}
      . prep_step
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
      export FORT11=${gfile}
      export FORT16=${FIXens_tracker}/fens_tmp_levs.txt
      export FORT31=${ifile}
      export FORT51=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.t.f${fhour}
      ${EXECens_tracker}/vint.x <${namelist}
      rcc2=$?

#     ----------------------------------------------------
#     Now average the temperature data that we just
#     interpolated to get the mean 300-500 mb temperature...
      namelist=${TRKDATA}/tave_input.${PDY}${cyc}
      . prep_step
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}
      ffile=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.t.f${fhour}
      ifile=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.t.f${fhour}.i
      ${GRB2INDEX:?} ${ffile} ${ifile}
      export err=$?; err_chk
      export FORT11=${ffile}
      export FORT31=${ifile}
      export FORT51=${TRKDATA}/${cmodel}_tave.${pert}.${PDY}${cyc}.f${fhour}
      ${EXECens_tracker}/tave.x <${namelist}
      rcc3=$?

      if [ $rcc1 -eq 0 -a $rcc2 -eq 0 -a $rcc3 -eq 0 ]; then
        echo " "
      else
#        mailfile=${FIXens_tracker}/errmail.${cmodel}.${pert}.${PDY}${cyc}
#        echo "CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}" >${mailfile}
#        mail -s "ENS Failure (CPS/WC int) $cmodel $pert ${PDY}${cyc}" jiayi.peng@noaa.gov <${mailfile}
        msg="FATAL ERROR:  CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}"
        echo "$msg"; postmsg $jlogfile "$msg"
        err_exit "$msg"
      fi

      tavefile=${TRKDATA}/${cmodel}_tave.${pert}.${PDY}${cyc}.f${fhour}
      zfile=${TRKDATA}/${cmodel}.${pert}.${PDY}${cyc}.z.f${fhour}
      cat ${zfile} ${tavefile} >>${catfile}
#      rm $tavefile $zfile
      set +x
      echo " "
      echo "Date in interpolation for fhour= $fhour after = `date`"
      echo " "
      set -x
    done
    fi  
  fi

  gfile=${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc}
  if [ ${PHASEFLAG} = 'y' ]; then
    cat ${catfile} >>${gfile}
  fi
  ifile=${TRKDATA}/fensixfile.${pert}.${PDY}${cyc}
  ${GRB2INDEX:?} ${gfile} ${ifile}
  export err=$?; err_chk

  gribfile=${TRKDATA}/fensgribfile.${pert}.${PDY}${cyc}
  ixfile=${TRKDATA}/fensixfile.${pert}.${PDY}${cyc}
fi    

# ------------------------------
#   Process NAVGEM, if selected
# ------------------------------
if [ ${model} -eq 7 ]
then

  if [ $loopnum -eq 1 ]
  then

    if [ -s ${TRKDATA}/ngpsgribfile.${PDY}${cyc} ]
    then
      rm ${TRKDATA}/ngpsgribfile.${PDY}${cyc}
    fi
  
    for fhour in ${fcsthrs}
    do

      if [ ! -s ${ngpsdir}/${ngpsgfile}${fhour}${ngemgfile} ]
      then
        set +x
        echo " "
        echo "FATAL ERROR:  NAVGEM File missing ${ngpsdir}/${ngpsgfile}${fhour}${ngemgfile}"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo " "
        set -x
        if [ "$DCOM_STATUS" = "data of opportunity" ]; then
          echo "${ngpsdir}/${ngpsgfile}${fhour}${ngemgfile}" >> ${DATA}/missing_ngps.txt
          exit
        else
          err_exit "MISSING NAVGEM FILE at $0:$LINENO"
        fi
      fi

      gfile=${ngpsdir}/${ngpsgfile}${fhour}${ngemgfile}
      ${WGRIB2:?} -s $gfile >ngps.ix
      export err=$?; err_chk

      for parm in ${wgrib_parmlist}
      do
        case ${parm} in
           "SurfaceU")
              grep "UGRD:10 m above" ngps.ix | ${WGRIB2:?} -i $gfile -append -grib \
                             ${TRKDATA}/ngpsgribfile.${PDY}${cyc} ;; 

           "SurfaceV")
              grep "VGRD:10 m above" ngps.ix | ${WGRIB2:?} -i $gfile -append -grib \
                             ${TRKDATA}/ngpsgribfile.${PDY}${cyc} ;;
           *)
              grep "${parm}" ngps.ix | ${WGRIB2:?} -i $gfile -append -grib \
                             ${TRKDATA}/ngpsgribfile.${PDY}${cyc} ;;
        esac
      done
    done

    ${GRB2INDEX:?} ${TRKDATA}/ngpsgribfile.${PDY}${cyc} ${TRKDATA}/ngpsixfile.${PDY}${cyc}
    export err=$?; err_chk

    if [ ${PHASEFLAG} = 'y' ]; then
    catfile=${TRKDATA}/${cmodel}.${PDY}${cyc}.catfile
    >${catfile}

    for fhour in ${fcsthrs}
    do

      set +x
      echo " "
      echo "Date in interpolation for fhour= $fhour before = `date`"
      echo " "
      set -x

      gfile=${TRKDATA}/ngpsgribfile.${PDY}${cyc}
      ifile=${TRKDATA}/ngpsixfile.${PDY}${cyc}
      ${GRB2INDEX:?} $gfile $ifile
      export err=$?; err_chk

#     ----------------------------------------------------
#     First, interpolate height data to get data from
#     300 to 900 mb, every 50 mb....
      gparm=7
      namelist=${TRKDATA}/vint_input.${PDY}${cyc}.z
      . prep_step
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}

      export FORT11=${gfile}
      export FORT16=${FIXens_tracker}/ngem_hgt_levs.txt
      export FORT31=${ifile}
      export FORT51=${TRKDATA}/${cmodel}.${PDY}${cyc}.z.f${fhour}
      ${EXECens_tracker}/vint.x <${namelist}
      rcc1=$?

#     ----------------------------------------------------
#     Now interpolate temperature data to get data from
#     300 to 500 mb, every 50 mb....
      gparm=11
      namelist=${TRKDATA}/vint_input.${PDY}${cyc}
      . prep_step
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}

      export FORT11=${gfile}
      export FORT16=${FIXens_tracker}/ngem_tmp_levs.txt
      export FORT31=${ifile}
      export FORT51=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}
      ${EXECens_tracker}/vint.x <${namelist}
      rcc2=$?

#     ----------------------------------------------------
#     Now average the temperature data that we just
#     interpolated to get the mean 300-500 mb temperature...
      gparm=11
      namelist=${TRKDATA}/tave_input.${PDY}${cyc}
      . prep_step
      echo "&timein ifcsthour=${fhour},"       >${namelist}
      echo "        iparm=${gparm},"          >>${namelist}
      echo "        gribver=${gribver},"      >>${namelist}
      echo "        g2_jpdtn=${g2_jpdtn},"    >>${namelist}
      echo "        g2_model=${model}/"       >>${namelist}

      ffile=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}
      ifile=${TRKDATA}/${cmodel}.${PDY}${cyc}.t.f${fhour}.i
      ${GRB2INDEX:?} ${ffile} ${ifile}
      export err=$?; err_chk
      export FORT11=${ffile}
      export FORT31=${ifile}
      export FORT51=${TRKDATA}/${cmodel}_tave.${PDY}${cyc}.f${fhour}
      ${EXECens_tracker}/tave.x <${namelist}
      rcc3=$?

      if [ $rcc1 -eq 0 -a $rcc2 -eq 0 -a $rcc3 -eq 0 ]; then
        echo " "
      else
#        mailfile=${FIXens_tracker}/errmail.${cmodel}.${pert}.${PDY}${cyc}
#        echo "CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}" >${mailfile}
#        mail -s "ENS Failure (CPS/WC int) $cmodel $pert ${PDY}${cyc}" jiayi.peng@noaa.gov <${mailfile}
        msg="FATAL ERROR:  CPS/WC interp failure for $cmodel $pert ${PDY}${cyc}"
        echo "$msg"; postmsg $jlogfile "$msg"
        err_exit "$msg"
      fi

      tavefile=${TRKDATA}/${cmodel}_tave.${PDY}${cyc}.f${fhour}
      zfile=${TRKDATA}/${cmodel}.${PDY}${cyc}.z.f${fhour}
      cat ${zfile} ${tavefile} >>${catfile}

      set +x
      echo " "
      echo "Date in interpolation for fhour= $fhour after = `date`"
      echo " "
      set -x
    done
    fi
  fi

  gfile=${TRKDATA}/ngpsgribfile.${PDY}${cyc}
  if [ ${PHASEFLAG} = 'y' ]; then
    cat ${catfile} >>${gfile}
  fi

  ifile=${TRKDATA}/ngpsixfile.${PDY}${cyc}
  ${GRB2INDEX:?} ${gfile} ${ifile}
  export err=$?; err_chk

  gribfile=${TRKDATA}/ngpsgribfile.${PDY}${cyc}
  ixfile=${TRKDATA}/ngpsixfile.${PDY}${cyc}
fi

#------------------------------------------------------------------------#
#                         Now run the tracker                            #
#------------------------------------------------------------------------#
set +x
echo " "
echo " -----------------------------------------------"
echo "           NOW EXECUTING TRACKER......"
echo " -----------------------------------------------"
echo " "
set -x

ist=1
while [ $ist -le 15 ]
do
  if [ ${stormflag[${ist}]} -ne 1 ]
  then
    set +x; echo "Storm number $ist NOT selected for processing"; set -x
  else
    set +x; echo "Storm number $ist IS selected for processing...."; set -x
  fi
  let ist=ist+1
done

namelist=${TRKDATA}/input.${atcfout}.${PDY}${cyc}
ATCFNAME=` echo "${atcfname}" | tr '[a-z]' '[A-Z]'`

if [ ${cmodel} = 'sref' ]; then
  export atcfymdh=` ${NDATE:?} -3 ${scc}${syy}${smm}${sdd}${shh}`
else
  export atcfymdh=${scc}${syy}${smm}${sdd}${shh}
fi

contour_interval=100.0
write_vit=n
want_oci=.TRUE.

echo "&datein inp%bcc=${scc},inp%byy=${syy},inp%bmm=${smm},"      >${namelist}
echo "        inp%bdd=${sdd},inp%bhh=${shh},inp%model=${model}," >>${namelist}
echo "        inp%modtyp='${modtyp}',"                           >>${namelist}
echo "        inp%lt_units='${lead_time_units}',"                >>${namelist}
echo "        inp%file_seq='${file_sequence}',"                  >>${namelist}
echo "        inp%nesttyp='${nest_type}'/"                       >>${namelist}
echo "&atcfinfo atcfnum=${atcfnum},atcfname='${ATCFNAME}',"      >>${namelist}
echo "          atcfymdh=${atcfymdh},atcffreq=${atcffreq}/"      >>${namelist}
echo "&trackerinfo trkrinfo%westbd=${trkrwbd},"                  >>${namelist}
echo "      trkrinfo%eastbd=${trkrebd},"                         >>${namelist}
echo "      trkrinfo%northbd=${trkrnbd},"                        >>${namelist}
echo "      trkrinfo%southbd=${trkrsbd},"                        >>${namelist}
echo "      trkrinfo%type='${trkrtype}',"                        >>${namelist}
echo "      trkrinfo%mslpthresh=${mslpthresh},"                  >>${namelist}
echo "      trkrinfo%v850thresh=${v850thresh},"                  >>${namelist}
echo "      trkrinfo%gridtype='${modtyp}',"                      >>${namelist}
echo "      trkrinfo%contint=${contour_interval},"               >>${namelist}
echo "      trkrinfo%want_oci=${want_oci},"                      >>${namelist}
echo "      trkrinfo%out_vit='${write_vit}',"                    >>${namelist}
echo "      trkrinfo%gribver=${gribver},"                        >>${namelist}
echo "      trkrinfo%g2_jpdtn=${g2_jpdtn}/"                      >>${namelist}
echo "&phaseinfo phaseflag='${PHASEFLAG}',"                      >>${namelist}
echo "           phasescheme='${PHASE_SCHEME}',"                 >>${namelist}
echo "           wcore_depth=${WCORE_DEPTH}/"                    >>${namelist}
echo "&structinfo structflag='${STRUCTFLAG}',"                   >>${namelist}
echo "            ikeflag='${IKEFLAG}'/"                         >>${namelist}
echo "&fnameinfo  gmodname='${atcfname}',"                       >>${namelist}
echo "            rundescr='${rundescr}',"                       >>${namelist}
echo "            atcfdescr='${atcfdescr}'/"                     >>${namelist}
echo "&verbose verb=3/"                                          >>${namelist}
echo "&waitinfo use_waitfor='n',"                                >>${namelist}
echo "          wait_min_age=10,"                                >>${namelist}
echo "          wait_min_size=100,"                              >>${namelist}
echo "          wait_max_wait=1800,"                             >>${namelist}
echo "          wait_sleeptime=5,"                               >>${namelist}
echo "          per_fcst_command=''/"                            >>${namelist}

export pgm=gettrk_g2
. prep_step

export FORT11=${gribfile}
export FORT12=${TRKDATA}/vitals.upd.${atcfout}.${PDY}${shh}
export FORT14=${TRKDATA}/genvitals.upd.${cmodel}.${atcfout}.${PDY}${cyc}
export FORT15=${FIXens_tracker}/${cmodel}.tracker_leadtimes
export FORT31=${ixfile}

if [ ${trkrtype} = 'tracker' ]; then
  if [ ${atcfout} = 'gfdt' -o ${atcfout} = 'gfdl' -o \
       ${atcfout} = 'hwrf' -o ${atcfout} = 'hwft' ]; then
    export FORT61=${TRKDATA}/trak.${atcfout}.all.${stormenv}.${PDY}${cyc}
    export FORT62=${TRKDATA}/trak.${atcfout}.atcf.${stormenv}.${PDY}${cyc}
    export FORT63=${TRKDATA}/trak.${atcfout}.radii.${stormenv}.${PDY}${cyc}
    export FORT64=${TRKDATA}/trak.${atcfout}.atcfunix.${stormenv}.${PDY}${cyc}
    export FORT66=${TRKDATA}/trak.${atcfout}.atcf_gen.${stormenv}.${PDY}${cyc}
    export FORT68=${TRKDATA}/trak.${atcfout}.atcf_sink.${stormenv}.${PDY}${cyc}
    export FORT69=${TRKDATA}/trak.${atcfout}.atcf_hfip.${stormenv}.${PDY}${cyc}
  else
    export FORT61=${TRKDATA}/trak.${atcfout}.all.${PDY}${cyc}
    export FORT62=${TRKDATA}/trak.${atcfout}.atcf.${PDY}${cyc}
    export FORT63=${TRKDATA}/trak.${atcfout}.radii.${PDY}${cyc}
    export FORT64=${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${cyc}
    export FORT66=${TRKDATA}/trak.${atcfout}.atcf_gen.${PDY}${cyc}
    export FORT68=${TRKDATA}/trak.${atcfout}.atcf_sink.${PDY}${cyc}
    export FORT69=${TRKDATA}/trak.${atcfout}.atcf_hfip.${PDY}${cyc}
  fi
else
  export FORT61=${TRKDATA}/trak.${atcfout}.all.${regtype}.${PDY}${cyc}
  export FORT62=${TRKDATA}/trak.${atcfout}.atcf.${regtype}.${PDY}${cyc}
  export FORT63=${TRKDATA}/trak.${atcfout}.radii.${regtype}.${PDY}${cyc}
  export FORT64=${TRKDATA}/trak.${atcfout}.atcfunix.${regtype}.${PDY}${cyc}
  export FORT66=${TRKDATA}/trak.${atcfout}.atcf_gen.${regtype}.${PDY}${cyc}
  export FORT68=${TRKDATA}/trak.${atcfout}.atcf_sink.${regtype}.${PDY}${cyc}
  export FORT69=${TRKDATA}/trak.${atcfout}.atcf_hfip.${regtype}.${PDY}${cyc}
fi

if [ ${atcfname} = 'aear' ]
then
  export FORT65=${TRKDATA}/trak.${atcfout}.initvitl.${PDY}${cyc}
fi

if [ ${write_vit} = 'y' ]
then
  export FORT67=${TRKDATA}/output_genvitals.${atcfout}.${PDY}${shh}
fi

if [ ${PHASEFLAG} = 'y' ]; then
  if [ ${atcfout} = 'gfdt' -o ${atcfout} = 'gfdl' -o \
       ${atcfout} = 'hwrf' -o ${atcfout} = 'hwft' ]; then
    export FORT71=${TRKDATA}/trak.${atcfout}.cps_parms.${stormenv}.${PDY}${cyc}
  else
    export FORT71=${TRKDATA}/trak.${atcfout}.cps_parms.${PDY}${cyc}
  fi
fi

if [ ${STRUCTFLAG} = 'y' ]; then
  if [ ${atcfout} = 'gfdt' -o ${atcfout} = 'gfdl' -o \
       ${atcfout} = 'hwrf' -o ${atcfout} = 'hwft' ]; then
    export FORT72=${TRKDATA}/trak.${atcfout}.structure.${stormenv}.${PDY}${cyc}
    export FORT73=${TRKDATA}/trak.${atcfout}.fractwind.${stormenv}.${PDY}${cyc}
    export FORT76=${TRKDATA}/trak.${atcfout}.pdfwind.${stormenv}.${PDY}${cyc}
  else
    export FORT72=${TRKDATA}/trak.${atcfout}.structure.${PDY}${cyc}
    export FORT73=${TRKDATA}/trak.${atcfout}.fractwind.${PDY}${cyc}
    export FORT76=${TRKDATA}/trak.${atcfout}.pdfwind.${PDY}${cyc}
  fi
fi

if [ ${IKEFLAG} = 'y' ]; then
  if [ ${atcfout} = 'gfdt' -o ${atcfout} = 'gfdl' -o \
       ${atcfout} = 'hwrf' -o ${atcfout} = 'hwft' ]; then
    export FORT74=${TRKDATA}/trak.${atcfout}.ike.${stormenv}.${PDY}${cyc}
  else
    export FORT74=${TRKDATA}/trak.${atcfout}.ike.${PDY}${cyc}
  fi
fi

if [ ${trkrtype} = 'midlat' -o ${trkrtype} = 'tcgen' ]; then
  export FORT77=${TRKDATA}/trkrmask.${atcfout}.${regtype}.${PDY}${cyc}
fi

msg="$pgm start for $atcfout at ${cyc}z"
postmsg "$jlogfile" "$msg"

set +x
echo "+++ TIMING: BEFORE gettrk  ---> `date`"
set -x

set +x
echo " "
echo "TIMING: Before call to gettrk at `date`"
echo " "
set -x

${EXECens_tracker}/gettrk_g2 <${namelist}
gettrk_rcc=$?
if [ ${gettrk_rcc} -ne 0 ]; then
  set +x
  echo " "
  echo "FATAL ERROR:  An error occurred while running gettrk.x, "
  echo "!!! which is the program that actually gets the track."
  echo "!!! Return code from gettrk.x = ${gettrk_rcc}"
  echo "!!! model= ${atcfout}, forecast initial time = ${PDY}${cyc}"
  echo " "
  set -x
  err_exit "FAILED ${jobid} - ERROR RUNNING gettrk_g2 IN TRACKER SCRIPT- ABNORMAL EXIT"
fi

set +x
echo " "
echo "TIMING: After call to gettrk at `date`"
echo " "
set -x

set +x
echo "+++ TIMING: AFTER  gettrk  ---> `date`"
set -x

#--------------------------------------------------------------#
# Now copy the output track files to different directories
#--------------------------------------------------------------#

set +x
echo " "
echo " -----------------------------------------------"
echo "    NOW COPYING OUTPUT TRACK FILES TO COM  "
echo " -----------------------------------------------"
echo " "
set -x


if [ -s ${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${shh} ]; then
  cat ${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${shh}|cut -c1-95 > ${TRKDATA}/short.${atcfout}.atcfunix.${PDY}${shh}
  cp ${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${shh} ${TRKDATA}/long.${atcfout}.atcfunix.${PDY}${shh}
  cp ${TRKDATA}/short.${atcfout}.atcfunix.${PDY}${shh} ${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${shh}
fi  

msg="$pgm end for $atcfout at ${cyc}z completed normally"
postmsg "$jlogfile" "$msg"

# Copy atcf files to NHC archives. We'll use Steve Lord's original script,
# distatcf.sh, to do this, and that script requires the input atcf file to
# have the name "attk126", so first copy the file to that name, then call
# the distatcf.sh script.  After that's done, then copy the full 0-72h
# track into the /com/hur/prod/global track archive file.

if [ "$SENDCOM" = 'YES' ]
then

  glatuxarch=${glatuxarch:-${gltrkdir}/tracks.atcfunix.${syy}}
  cat ${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${cyc}  >>${glatuxarch}

  if [ ${cmodel} = 'gfdl' ]
  then
    cp ${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${cyc} ${COMOUT}/${stormenv}.${PDY}${cyc}.trackeratcfunix
  else
    cp ${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${cyc} ${COMOUT}/${atcfout}.t${cyc}z.cyclone.trackatcfunix
  fi

  if [ "$SENDDBN" = 'YES' ]
  then
    if [ ${cmodel} != 'gfdl' ]
    then
      $DBNROOT/bin/dbn_alert MODEL ENS_TRACKER $job ${COMOUT}/${atcfout}.t${cyc}z.cyclone.trackatcfunix
    fi
  fi

# ------------------------------------------
# Cat atcfunix files to storm trackers files
# ------------------------------------------
#
# We need to parse apart the atcfunix file and distribute the forecasts to
# the necessary directories.  To do this, first sort the atcfunix records
# by forecast hour (k6), then sort again by ocean basin (k1), storm number (k2)
# and then quadrant radii wind threshold (k12).  Once you've got that organized
# file, break the file up by putting all the forecast records for each storm
# into a separate file.  Then, for each file, find the corresponding atcfunix
# file in the storm trackers directory and dump the atcfunix records for that storm
# in there.  NOTE: Only do this if the model run is NOT for the CMC or
# ECMWF ensemble.  The reason is that we do NOT want to write out the individual
# member tracks to the atcfunix file.  We only want to write out the ensemble
# mean track to the atcfunix file, and the mean track is calculated and written
# out in a separate script.

  if [ ${cmodel} = 'gfdl' ]
  then
    auxfile=${COMOUT}/${stormenv}.${PDY}${cyc}.trackeratcfunix
  else
    auxfile=${TRKDATA}/trak.${atcfout}.atcfunix.${PDY}${cyc}
  fi

  sort -k6 ${auxfile} | sort -k1 -k2 -k12  >atcfunix.sorted
  old_string="XX, XX"
  
  ict=0
  while read unixrec
  do
    storm_string=` echo "${unixrec}" | cut -c1-6`
    if [ "${storm_string}" = "${old_string}" ]
    then
      echo "${unixrec}" >>atcfunix_file.${ict}
    else
      let ict=ict+1
      echo "${unixrec}"  >atcfunix_file.${ict}
      old_string="${storm_string}"
    fi
  done <atcfunix.sorted

  if [ $ict -gt 0 ]
  then
    mct=0
    while [ $mct -lt $ict ]
    do
      let mct=mct+1
      at=` head -1 atcfunix_file.$mct | cut -c1-2 | tr '[A-Z]' '[a-z]'`
      NO=` head -1 atcfunix_file.$mct | cut -c5-6`

      if [ ! -d ${COMOUTatcf:?}/${at}${NO}${syyyy} ]
      then
        mkdir -p $COMOUTatcf/${at}${NO}${syyyy}
      fi
      cat atcfunix_file.$mct >>$COMOUTatcf/${at}${NO}${syyyy}/ncep_a${at}${NO}${syyyy}.dat
      set +x
      echo " "
      echo "+++ Adding records to  TPC ATCFUNIX directory: $COMOUTatcf/${at}${NO}${syyyy}/ncep_${at}${NO}${syyyy}"
      echo " "
      set -x
    done
  fi
fi
