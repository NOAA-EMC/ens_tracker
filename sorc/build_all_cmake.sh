#!/bin/sh

set -eux
source ./machine-setup.sh > /dev/null 2>&1

#Supports Debug or Release modes for the build
BUILD_MODE=${BUILD_MODE:-Release}

cwd=$(pwd)

if [ "${BUILD_MODE}" = Release ]; then
  export BUILD_TYPE=RELEASE
else
  export BUILD_TYPE=DEBUG
fi

#module use /lfs/h2/emc/ens/noscrub/hananeh.jafary/ens_update_src/modulefiles
module use /lfs/h2/emc/ens/noscrub/hananeh.jafary/ens_package_08042025/modulefiles
module load $target.lua
module list

if [ $target = hera ]; then
  export FC=ifort
  export F90=ifort
  export CC=icc
elif [ $target = orion ]; then
  export FC=ifort
  export F90=ifort
  export CC=icc
elif [ $target = hercules ]; then
  export FC=ifort
  export F90=ifort
  export CC=icc
elif [ $target = jet ]; then
  export FC=ifort
  export F90=ifort
  export CC=icc
elif [ $target = wcoss2 ] ; then
  export FC=ftn
  export F90=ftn
  export CC=icc
else
  echo "Unknown machine = $target"
  exit 1
fi

echo $(pwd)

cd ..
if [ -d "build" ]; then
   rm -rf build
fi
mkdir build
cd build
cmake .. -DCMAKE_Fortran_COMPILER=ifort -DCMAKE_C_COMPILER=icc -DCMAKE_BUILD_TYPE=${BUILD_TYPE}
make -j 8 VERBOSE=1
make install


#cd sorc/gfdl_tracker/
#./build_gfdl_tracker.sh

exit
