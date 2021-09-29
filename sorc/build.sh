#!/bin/bash
set -x -e
if [[ ! -d ../exec ]] ; then mkdir ../exec ; fi

if [[ -d /lfs/h1 ]] ; then
  # We are on NOAA wcoss2
  machine=wcoss2
  module purge
  source ../versions/build.ver

  export INC="${G2_INCd} -I${NETCDF_INC}"
  export LIBS="${W3EMC_LIBd} ${W3NCO_LIBd} ${BACIO_LIB4} ${G2_LIBd} ${PNG_LIB} ${JASPER_LIB} ${Z_LIB} -L${NETCDF_LIB} -lnetcdff -lnetcdf"
  export LIBS_SUP="${W3EMC_LIBd} ${W3NCO_LIBd}"
  export LIBS_UK="${W3NCO_LIB4} ${BACIO_LIB4}"

  for dir in *.fd; do
    cd $dir
    make clean
    make -f makefile
    make install
    cd ..
  done

else
  export machine=unknown
  echo Compile failed: unknown platform 1>&2
fi

