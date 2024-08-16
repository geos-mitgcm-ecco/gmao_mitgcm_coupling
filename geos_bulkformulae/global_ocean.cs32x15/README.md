Global Ocean coupled with GEOS
==============================

### Get  MITgcm
```
git clone git@github.com:MITgcm/MITgcm.git
cd MITgcm
```

### Get code for bulk formulae
```
git clone git@github.com:geos-mitgcm-ecco/gmao_mitgcm_coupling.git
cd verification/global_ocean.cs32x15/
cp -r ../../gmao_mitgcm_couplng/geos_bulkformulae/global_ocean.cs32x15/* .
```

## Forward model
### Set-up
```
mkdir build_tst
cd build_tst
cp ../build/genmake_local .
```

### Compile
**NOTE:** update the opt file as needed
```
../../../tools/genmake2 -mods '../geos_blkf ../cod_tst' -mpi -of ../../../tools/build_options/linux_amd64_ifort+mpi_ice_nas


make depend
make -j 4
```

### Run the experiment
```
cd ..

#\cp -r ../../gmao_mitgcm_couplng/geos_bulkformulae/global_ocean.cs32x15/input_BF/ .
#\cp ../../gmao_mitgcm_couplng/geos_bulkformulae/global_ocean.cs32x15/job_cs32_nc12 .


mkdir input_forcingEIG_monthly
cd input_forcingEIG_monthly

svn checkout https://github.com/MITgcm-contrib/ecco_darwin/trunk/v04/3deg/data .

cd ..
```
Modify the job script: `job_cs32_nc1`, change the dirbase to yours, similar to following
```
#set dirbase=/nobackupp11/afahad/MITgcm/verification/global_ocean.cs32x15
```
Run job script
```
./job_cs32_nc1 
```
or,  
```
qsub job_cs32_nc1
```

## Adjoint model
### Set-up
```
mkdir build_tst_ad
cd build_tst_ad
```

Generate `genamke_local` in the build directory containing the following lines:
```
TAF_FORTRAN_VERS='F95'
USE_EXTENDED_SRC='t'
```

### Compile
**NOTE:** update the opt file as needed
```
../../../tools/genmake2 -ncad -mods '../geos_blkf ../cod_geos_ad'


make depend
make -j 4 adall
```

### Run the experiment
```
cd ../run

ln -s ../input_ad/* .
./prepare_run

./mitgcmuv_ad > out.adj
```
