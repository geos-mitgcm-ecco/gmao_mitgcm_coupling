#!/bin/bash

#PBS -l walltime=2:00:00
#PBS -l select=9:ncpus=40:mpiprocs=40:model=sky_ele
#PBS -N IAU_RUN
#PBS -q devel
#PBS -W group_list=s1353
#PBS -j oe -k oed
#@BATCH_NAME -o gcm_run.o@RSTDATE

rbcs=GEOSMIT6	#expID as line 46 @readme.txt
norb=GEOSMITtmp #diff from above

ln -sf /nobackup/hzhang1/for_Fahad/IAU/ecco_iau
ln -sf /nobackup/hzhang1/for_Fahad/IAU/eccov4r4
mkdir -p output_noRBCS

#for seg in {1..73}; do
for seg in {1..2}; do

t0=$( printf "%010d" $(( (seg-1)*960  )) )
t1=$( printf "%010d" $(( (seg-0)*960  )) )

#step1
[[ -d $norb ]] && rm -r $norb
mkdir $norb
cd $norb
cp -p ../* .
ln -s ../RC
mkdir restarts
cd restarts
cp ../../restarts/MITgcm_restart_dates.txt .
ln -s ../../restarts/* .
cd ..
ln -s ../mit_input
cd mit_input
ln -sf data.pkg_noRBCS data.pkg
cd ..
sed -i "s|setenv  EXPDIR.*|setenv  EXPDIR `pwd`|" gcm_run.j
sed -i "s|setenv  HOMDIR.*|setenv  HOMDIR `pwd`|" gcm_run.j
sed -i "s|setenv  EXPID.*|setenv  EXPID ${norb}|" gcm_run.j
./gcm_run.j
cp mit_output/STDOUT.${t0} ../output_noRBCS/
cp mit_output/[TS].${t1}.data ../output_noRBCS/
cd ..

#step2
sed -i "s/${t0}/${t1}/" data.iau
./ecco_iau

#step3
mv [TS]*_5days_iau.bin mit_input
cd mit_input
ln -sf data.pkg_RBCS data.pkg
cd ..
./gcm_run.j

done
[[ -d $norb ]] && rm -r $norb 

