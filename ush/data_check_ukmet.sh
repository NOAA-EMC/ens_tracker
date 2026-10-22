#!/bin/ksh
export PS4=' + data_check_ukmet.sh line $LINENO: '
set -x

####################################
#------ data checking for each hour--------------------------
export SLEEP_TIME=3600
export SLEEP_INT=60
SLEEP_LOOP_MAX=`expr $SLEEP_TIME / $SLEEP_INT`

if [ ${cmodel} = "ukmet" ]; then
  datdir=${ukmetdir}
  vit_incr=${FHOUT_CYCLONE:-6}
  fcstlen=${FHMAX_CYCLONE:-144}
  fcsthrs=$(seq -f%03g -s' ' 0 $vit_incr $fcstlen)
fi

ic=0
while [ $ic -lt $SLEEP_LOOP_MAX ]; do
  echo "Check for the existence of the files in ${datdir}"

  ic1=0
  for fhour in ${fcsthrs}; do
    datfile=ukmet.t${cyc}z.0p25.f${fhour}.grib
    if [ ! -s ${datdir}/${datfile} ]; then
      set +x
      echo " "
      echo "UKMET file missing: ${datdir}/${datfile}"
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      echo " "
      set -x
      ic1=`expr $ic1 + 1`
    fi
  done

  if [ $ic1 -eq 0 ]; then
    echo " !!!  $ic1 files missing in ${datdir} after waiting $ic minutes"
    break
  else
    sleep $SLEEP_INT
  fi
  ic=`expr $ic + 1`
###############################
# After we wait for 60 minutes, no data is available, Job will be quit.
###############################
  if [ $ic -eq $SLEEP_LOOP_MAX ]; then
    msg="FATAL ERROR: $ic1 files missing in ${datdir}"
    echo "$msg"; postmsg "$jlogfile" "$msg"
    exit 6
  fi
done
