#!/bin/ksh
set -x

export cmodel=ukmet
export loopnum=1
export ymdh=${PDY}${cyc}

export ukmetdir=${COMINukmet}

#---- first run to get UKMET genesis vital at time=00 06 12 18Z -----------

export trkrtype=tcgen
export trkrebd=350.0
export trkrwbd=105.0
export trkrnbd=30.0
export trkrsbd=5.0
export mslpthresh=0.0015
export v850thresh=1.5000
export regtype=altg

export pert=p01
export pertdir=${DATA}/${cmodel}/${pert}
mkdir -p $pertdir

${USHens_tracker}/extrkr_tcv_g1.sh ${loopnum} ${cmodel} ${pert} ${pertdir} #2>&1 >${outfile}
export err=$?; err_chk

#### UKMET genesis tcvitals  ###########################
num_gen_vits=`cat ${COMINgenvit}/genesis.vitals.ukmet.ukx.${JYYYY} | wc -l`
if [ ${num_gen_vits} -gt 0 ]
then
  . prep_step

  # Input file
  export FORT41=${COMINgenvit}/genesis.vitals.ukmet.ukx.${JYYYY}

  # Output file
  export FORT42=gen_tc.vitals.ukmet.ukx.${JYYYY}

  ${EXECens_tracker}/tcvital_ch_ukmet
  export err=$?; err_chk

  cat $FORT42 >> ${COMOUTgenvit}/all.vitals.ukmet.ukx.${JYYYY}
else
  touch ${COMOUTgenvit}/all.vitals.ukmet.ukx.${JYYYY}
fi

#---- second run genesis ---------------------------------------

export pertdir=${DATA}/${cmodel}/${pert}
mkdir -p $pertdir

${USHens_tracker}/extrkr_gen_g1.sh ${loopnum} ${cmodel} ${pert} ${pertdir} #2>&1 >${outfile}
export err=$?; err_chk

export atcfout=ukx
export TRKDATA=${DATA}/${cmodel}/${pert}
${USHens_tracker}/sort_tracks.gen.sh  >${TRKDATA}/sort.${regtype}.${atcfout}.${ymdh}.out
export err=$?; err_chk

#cp ${pertdir}/trak.ukx.atcfunix.altg.${ymdh} ${COMOUT}/
#cp ${pertdir}/storms.ukx.atcf_gen.altg.${ymdh}  ${COMOUT}/

####filtering weak storms for TC genesis #####

. prep_step

# Input file
export FORT41=storms.ukx.atcf_gen.altg.${ymdh}
cpreq ${COMOUT}/$FORT41 .

# Output files
export FORT42=storms.ukx.atcf_gen.${ymdh}
export FORT43=trak.ukx.atcfunix.${ymdh}

${EXECens_tracker}/filter_gen_ukmet
export err=$?; err_chk

if [ "$SENDCOM" = YES ]; then
  cp $FORT42 $FORT43 ${COMOUT}/
  if [ $? -ne 0 ]; then
    echo "WARNING: Filtering did not produce any files... perhaps there were no storms to begin with."
  fi
fi
