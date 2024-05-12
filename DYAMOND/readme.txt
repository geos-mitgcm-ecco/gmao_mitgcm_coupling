This directory contains some deprecated folders that pertain to code used to run the DYAMOND c1440_llc2160 simulation as well as experimental code to split the MITgcm and sea ice code in two executables.

commit dd8a34d029441aad80c72e57f05876356cbf5a62
Author: Dimitris Menemenlis <dmenemen@kirke.local>
Date:   Sat Mar 30 14:52:02 2024 -0700
    moving GNUmakefile, MIT_GEOS5PlugMod.F90, experiments, mitgcm_setup,
    and split_seaice to subdirectory DYAMOND since newer versions of
    these files now exist under subdirectory MIT_GEOS5PlugMod

commit 83cb39b76c66db9fe4a1bb02426252c291c1da65 (HEAD -> master, origin/master, origin/HEAD)
Author: Dimitris Menemenlis <dmenemenlis@gmail.com>
Date:   Fri May 3 17:48:28 2024 -0700
moving the old gmao_mitgcm_coupling/notes subdirectory to gmao_mitgcm_coupling/DYAMOND

>>>>>>>>>>>>>>>>>>>>>>>

What follows are some notes from Hong Zhang pertaining to commits that were removed when moving from https://github.com/christophernhill/gmao_mitgcm_couplng to https://github.com/geos-mitgcm-ecco/gmao_mitgcm_coupling

From: "Zhang, Hong (US 398K)" <hong.zhang@jpl.nasa.gov>
Subject: Re: can you help with GEOS-ECCO github
Date: May 2, 2024 at 2:35:35 PM PDT
To: "Menemenlis, Dimitris (US 329B)" <dimitris.menemenlis@jpl.nasa.gov>

Hi Dimitris,
If I understand correctly, we want to focus on 
https://github.com/geos-mitgcm-ecco/gmao_mitgcm_coupling
instead of 
https://github.com/christophernhill/gmao_mitgcm_couplng
though the former is a a fork of the latter.

Now we want to sync the former with latter by pressing “Sync fork”  button.
But there are “4 commit ahead” warning.
So we need to take a deep look at the differences before we force the sync.
Here are the detail differences of 4 ahead-of commits, reflected in 3 files

1.  running_jason_20220622.txt
CH=gmao_mitgcm_couplng
DM=gmao_mitgcm_coupling
f='notes/running_jason_20220622.txt'
diff $CH/$f $DM/$f
14c14,25
<    git checkout feature/atrayano/MITgcm-DYAMOND-dso
---
  git remote add devel_repo git@github.com:geos-mitgcm-ecco/GEOSgcm_GridComp.git
  git fetch devel_repo cnh/prints-and-returns:cnh/prints-and-returns
  git checkout cnh/prints-and-returns
 (note: to leave this branch & to go back to main branch:
   git checkout develop
 (note: to use instead Atanas' reference branch:
   git checkout feature/atrayano/MITgcm-DYAMOND-dso
 )
 ( when coming back after first time:
   git checkout cnh/prints-and-returns
   git pull
 )

“DM” has some more lines but I guess they are not used anymore.

2.  SEAICE_SIZE.h
CH=gmao_mitgcm_couplng/DYAMOND
DM=gmao_mitgcm_coupling
f='split_seaice/configs/c90_llc90_try/cod_icedyn/SEAICE_SIZE.h'
diff $A/$f $B/$f
26a27,33
#ifdef HACK_FOR_GMAO_CPL
C   nIceLayers  :: number of Ice  layers (in each category)
C   nSnowLayers :: number of snow layers (in each category)
     INTEGER nIceLayers, nSnowLayers
     PARAMETER( nIceLayers = 4 , nSnowLayers = 1 )
#endif /* HACK_FOR_GMAO_CPL */

3. seaice_diag_init_add.h
CH=gmao_mitgcm_couplng/DYAMOND
DM=gmao_mitgcm_coupling
f='split_seaice/configs/c90_llc90_try/cod_icedyn/seaice_diag_init_add.h'
ls $CH/$f #no
ls $DM/$f #yes

I guess this file was mis-copied?

All these change were made in year 2022. 
So I guess it’s OK to discard the change.
(Plus we have a “note" to keep record of the change).

Hope it’s clear
Hong
