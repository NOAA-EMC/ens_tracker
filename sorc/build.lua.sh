#!/bin/bash

source ../versions/build.ver
module reset
module use `pwd`
module load build-ens_tracker.module.lua
module list

if [[ ! -d ../exec ]] ; then mkdir ../exec ; fi

export INC="${G2_INCd} -I${NETCDF_INCLUDES}"
export LIBS="${W3EMC_LIBd} ${BACIO_LIB4} ${G2_LIBd} ${PNG_LIB} ${JASPER_LIB} ${Z_LIB} -L${NETCDF_LIBRARIES} -lnetcdff -lnetcdf"
export LIBS_SUP="${W3EMC_LIBd}"
export LIBS_UK="${W3EMC_LIBd} ${BACIO_LIB4}"

for dir in *.fd; do
  cd $dir
  make clean
  make -f makefile
  make install
  cd ..
done


