--#%Module############################################################
--#
--#    - ENS-TRACKER
--#
--####################################################################
--proc ModulesHelp { } {
--  puts stderr "Sets environment variables for ENS-TRACKER"
--  puts stderr "This module initializes the environment"
--  puts stderr "to build the ENS-TRACKER software at NCEP"
--}

whatis("ENS-TRACKER module for compilation")

-- Load Intel Compiler

load("PrgEnv-intel/"..os.getenv("PrgEnv_intel_ver"))
load("craype/"..os.getenv("craype_ver"))
load("intel/"..os.getenv("intel_ver"))

-- Load Supporting Software Libraries

load("g2/"..os.getenv("g2_ver"))
load("bacio/"..os.getenv("bacio_ver"))
load("jasper/"..os.getenv("jasper_ver"))
load("libpng/"..os.getenv("libpng_ver"))
load("zlib/"..os.getenv("zlib_ver"))
load("hdf5/"..os.getenv("hdf5_ver"))
load("netcdf/"..os.getenv("netcdf_ver"))
load("w3emc/"..os.getenv("w3emc_ver"))

