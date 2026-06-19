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

# Build executable
 mkdir $WORKDIR/MITgcm_68n/build
 cd $WORKDIR/MITgcm_68n/build
 TOOLDIR=$WORKDIR/gmao_mitgcm_coupling/geos_bulkformulae/tools
 GEOSDIR=$WORKDIR/gmao_mitgcm_coupling/geos_bulkformulae/compare_bulkformulae
 $TOOLDIR/genmake2 -mods $GEOSDIR/code -of $TOOLDIR/darwin_arm64_gfortran
 make depend
 make -j

# Run the experiment
 mkdir $WORKDIR/MITgcm_68n/run
 cd $WORKDIR/MITgcm_68n/run
 ln -sf ../build/mitgcmuv .
 cp $GEOSDIR/input/* .
# Use matlab to execute gendata.m
 ./mitgcmuv > output.txt
