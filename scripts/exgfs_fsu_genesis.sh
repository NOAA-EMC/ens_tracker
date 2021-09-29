#!/bin/ksh 
set -x

export cmodel=gfs
export ymdh=${PDY}${cyc}

export pert="p01"
pertdir=${DATA}/${cmodel}/${pert}
mkdir -p $pertdir

#-----------input data checking -----------------
#${USHens_tracker}/data_check.sh 
#${USHens_tracker}/data_check_gfs.sh
${USHens_tracker}/data_check_gfs_180hr.sh
## exit code 6 = missing data of opportunity
if [ $? -eq 6 ]; then exit; fi
#------------------------------------------------

outfile=${pertdir}/fsugenesis.${cmodel}.${pert}.${ymdh}.out
if [[ -d /lfs/h1 ]] ; then
  # We are on NOAA wcoss2
  machine=wcoss2
  ${USHens_tracker}/extrkr_fsu.sh ${cmodel} ${ymdh} ${pertdir} ${COMINgfs}  #2>&1 >${outfile}
else
  echo Job failed: unknown platform 1>&2
  err_exit "FAILED ${jobid} - ERROR IN unknown platform - ABNORMAL EXIT"
fi
export err=$?; err_chk

if [ "$SENDCOM" = 'YES' ]; then
  cp -r ${pertdir}/tracker/${cmodel}/* ${COMOUT}
fi
