set-up and run compare_bulkformulae with GEOS bulk formulae on Apple silicon
============================================================================

# Define a working directory
 WORKDIR=~/mitgcm

# Get code GEOS bulk formulae, ecco-darwin, and MITgcm checkpoint68n
 cd $WORKDIR
 git clone git@github.com:geos-mitgcm-ecco/gmao_mitgcm_coupling.git
 git clone --depth 1 git@github.com:MITgcm-contrib/ecco_darwin.git
 git clone --depth 1 --branch checkpoint68n git@github.com:MITgcm/MITgcm.git
 mv MITgcm MITgcm_68n

# Build executables
 mkdir $WORKDIR/MITgcm_68n/build
 cd $WORKDIR/MITgcm_68n/build
 TOOLDIR=$WORKDIR/gmao_mitgcm_coupling/geos_bulkformulae/tools
 GEOSDIR=$WORKDIR/gmao_mitgcm_coupling/geos_bulkformulae/compare_bulkformulae
 cp $WORKDIR/MITgcm_68n/pkg/exf/EXF_OPTIONS.h .
 $TOOLDIR/genmake2 -mods $GEOSDIR/code -of $TOOLDIR/darwin_arm64_gfortran
 make depend
 make -j
 mv mitgcmuv mitgcmuv_large_pond
 cp $GEOSDIR/code/EXF_OPTIONS.h_yeager04 EXF_OPTIONS.h
 make clean
 make -j
 mv mitgcmuv mitgcmuv_yeager04
 cp $GEOSDIR/code/EXF_OPTIONS.h_yeager09 EXF_OPTIONS.h
 make clean
 make -j
 mv mitgcmuv mitgcmuv_yeager09
 cp $GEOSDIR/code/EXF_OPTIONS.h_GEOS EXF_OPTIONS.h
 make clean
 make -j
 mv mitgcmuv mitgcmuv_GEOS

# Run the experiment
 mkdir $WORKDIR/MITgcm_68n/run
 cd $WORKDIR/MITgcm_68n/run
 ln -sf ../build/mitgcmuv* .
 cp $GEOSDIR/input/* .
# Use matlab to execute gendata.m
 ./mitgcmuv_large_pond > output_large_pond.txt
 mv bulk_fluxes.0000000001.data bulk_large_pond
 ./mitgcmuv_yeager04 > output_yeager04.txt
 mv bulk_fluxes.0000000001.data bulk_yeager04
 ./mitgcmuv_yeager09 > output_yeager09.txt
 mv bulk_fluxes.0000000001.data bulk_yeager09
 ./mitgcmuv_GEOS > output_bulk_GEOS.txt
 mv bulk_fluxes.0000000001.data bulk_GEOS
