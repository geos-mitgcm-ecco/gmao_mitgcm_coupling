set-up and run global_ocean.cs32x15 with GEOS bulk formulae on Apple silicon
============================================================================

# Define a working directory
 WORKDIR=~/mitgcm

# Get code GEOS bulk formulae, ecco-darwin, and MITgcm checkpoint68n
 cd $WORKDIR
 git clone git@github.com:geos-mitgcm-ecco/gmao_mitgcm_coupling.git
 git clone --depth 1 git@github.com:MITgcm-contrib/ecco_darwin.git
 git clone --depth 1 --branch checkpoint68n git@github.com:MITgcm/MITgcm.git
 mv MITgcm MITgcm_68n

# Build executable
 cd $WORKDIR/MITgcm_68n/verification/1D_ocean_ice_column
 mkdir build_tst run_tst
 cd build_tst
 TOOLDIR=$WORKDIR/gmao_mitgcm_coupling/geos_bulkformulae/tools
 GEOSDIR=$WORKDIR/gmao_mitgcm_coupling/geos_bulkformulae/1D_ocean_ice_column
 $TOOLDIR/genmake2 -mods $GEOSDIR/code -of $TOOLDIR/darwin_arm64_gfortran
 make depend
 make -j

# Run the experiment
 cd $WORKDIR/MITgcm_68n/verification/1D_ocean_ice_column/run_tst
 ln -sf ../build_tst/mitgcmuv .
 cp ../input/* .
 cp $GEOSDIR/input/* .
 ./mitgcmuv
