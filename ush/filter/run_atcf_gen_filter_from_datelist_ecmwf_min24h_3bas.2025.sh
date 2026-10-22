#!/usr/bin/ksh

# This is the driver for the script that filters the atcf_gen files
# to keep only storms that are truly TCs that live for a minimum,
# specified period of time and meet CPS thresholds.
#
# Written by Tim Marchok, 8/11/2023
#

model=ecmwf
model_id=emxt
basin=nhtg

export scrdir=/lfs/h2/emc/hur/save/timothy.marchok/trak/para/scripts/hana/filter
export rawdir=/lfs/h2/emc/ptmp/timothy.marchok/filterout/raw_tracks/${model}
export stormdir=/lfs/h2/emc/ptmp/timothy.marchok/filterout/storms/24h/${model}

datelist_file=${scrdir}/model_common_gen_dates.2025.txt

ndate=/lfs/h2/emc/hur/save/timothy.marchok/bin/ndate.x

if [ ! -d ${stormdir} ]; then
  mkdir -p ${stormdir}
fi

while read iymdh
do

  # ---------------------------------------
  # Process the storm tracks....
  # ---------------------------------------

  cd ${rawdir}

  if [ -s trak.${model_id}.atcf_gen.${basin}.${iymdh} ]; then
    set +x
    echo "+++ Processing tracks for ${iymdh}...."
    set -x
    ${scrdir}/filter_tracks_6h_min24h.sh trak.${model_id}.atcf_gen.${basin}.${iymdh}
    if [ -s storms_filtered ]; then
      set +x
      echo "  ---> A-Okay: Moving processed storm file for ${iymdh} to stormdir...."
      set -x
      mv storms_filtered ${stormdir}/storms.${model_id}.atcf_gen.${basin}.${iymdh}
    else
      set +x
      echo "  xxxx There is no processed storm file to move for ${iymdh}...."
      set -x
    fi
  else
    set +x
    echo "  xxxx There is no original trak file to process & filter for ${iymdh}...."
    set -x
  fi    

#  iymdh=` ${ndate} 6 ${iymdh}`

done <${datelist_file}
