set-up and run global_ocean.cs32x15 with GEOS bulk formulae on Apple silicon
============================================================================

# Define a working directory
 WORKDIR=~/mitgcm

# Get code GEOS bulk formulae, ecco-darwin, and MITgcm checkpoint68n
 cd $WORKDIR
 git clone git@github.com:geos-mitgcm-ecco/gmao_mitgcm_coupling.git
 git clone --depth 1 git@github.com:MITgcm-contrib/ecco_darwin.git
 git clone --depth 1 --branch checkpoint68n git@github.com:MITgcm/MITgcm.git

# Build executable
 cd $WORKDIR/MITgcm/verification/global_ocean.cs32x15
 mkdir build_tst run_tst
 cd build_tst
 GEOSDIR=$WORKDIR/gmao_mitgcm_coupling/geos_bulkformulae/global_ocean.cs32x15
 $GEOSDIR/genmake2 -devel -mods "$GEOSDIR/geos_blkf $GEOSDIR/cod_tst" -of $GEOSDIR/darwin_arm64_gfortran
 make depend
 make -j

# Run the experiment
 cd $WORKDIR/MITgcm/verification/global_ocean.cs32x15/run_tst
 ln -s ../../tutorial_held_suarez_cs/input/grid_cs32* .
 ln -s $WORKDIR/ecco_darwin/v04/3deg/data/EIG* .
 ln -sf ../build_tst/mitgcmuv .
 cp $GEOSDIR/inp_tst_af/* .
 ./mitgcmuv
