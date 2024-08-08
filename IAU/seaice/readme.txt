Algorithm for IAU for CICE variables

1. Run GEOS/ECCO for N (e.g., 5) days
  On day N we dump:
  HEFFITD_N(i,j,n)
  HSNOWITD_N(i,j,n)
  SImeltPd_N(i,j,n)
  SIqIce_N(i,j,l,n)
  SIqSnow_N(i,j,l,n)

2. Offline, the volume of frozen water:
  HEFF_GEOS_N(i,j)=0
  HSNOW_GEOS_N(i,j)=0
  DO n=1,nITD
   DO j=1-OLy,sNy+OLy
    DO i=1-OLx,sNx+OLx
     HEFF_GEOS_N(i,j)=HEFF_GEOS_N(i,j)+HEFFITD_N(i,j,n)
     HSNOW_GEOS_N(i,j)=HSNOW_GEOS_N(i,j)+HSNOWITD_N(i,j,n)
    ENDDO
   ENDDO
  ENDDO

3. Offline use ceaice ice and snow density to convert from m^3/m^2 to kg/m^2
   of total equivalent water
   then compute the difference for the ECCO estimate of that value (ie, sea-ice load)

  ICESNO_ANALYSIS_INC(i,j) =
  ( HEFF_GEOS_N * VOLICE_DENSITY + HSNOW_GEOS_N * VOLSNO_DENSITY ) - SICEload_N
  and GEOS_frozen_load_N(i,j) =
  ( HEFF_GEOS_N * VOLICE_DENSITY + HSNOW_GEOS_N * VOLSNO_DENSITY )

  SCALING_FACTOR(i,j) = ICESNO_ANALYSIS_INC(i,j) / GEOS_frozen_load_N(i,j)

  The increments that we want to apply are, where M can equal N or not:
  HEFFITD_INC(i,j,n)  = SCALING_FACTOR(i,j) * HEFFITD_N(i,j,n)  * deltat / Mdays
  HSNOWITD_INC(i,j,n) = SCALING_FACTOR(i,j) * HSNOWITD_N(i,j,n) * deltat / Mdays
  SImeltPd_INC(i,j,n) = SCALING_FACTOR(i,j) * SImeltPd_N(i,j,n) * deltat / Mdays
  SIqIce_INC(i,j,l,n) = SCALING_FACTOR(i,j) * SIqIce_N(i,j,l,n) * deltat / Mdays
  SIqSnow_INC(i,j,l,n)= SCALING_FACTOR(i,j) * SIqSnow_N(i,j,l,n)* deltat / Mdays

>>>> ADD A TRAP ON ABOVE to make sure that all fields and categories remain positive

  For locations where GEOS_frozen_load_N(i,j) < SICEload_threshold
             and ICESNO_ANALYSIS_INC(i,j) < SICEload_threshold
  set SCALING_FACTOR(i,j) = 0

  For locations where GEOS_frozen_load_N(i,j) < SICEload_threshold
              and ICESNO_ANALYSIS_INC(i,j) > SICEload_threshold
  find a nearby location where:
              GEOS_frozen_load_N(i_donor,j_donor) ~= SICEload_N(i,j)
  and compute the SCALING_FACTOR and *_INC fields based on that nearby location.

  Initially, we can try: SICEload_threshold = 100 kg/m^2

4. Run GEOS/ECCO for N days adding increments computed in 1-3 above during the first M days.
  - read in the *_INC fields computed above
  - add these increments in
    MIT_GEOS5PlugMod/configs/c90_llc90_02/code/seaice_save4gmao.F

>>>> double-check category/levels of snow and ice

              SIadv_Heff  (i,j,n,bi,bj) = HEFFITD (i,j,n,bi,bj)
     &                              - SIadv_Heff  (i,j,n,bi,bj)
     &                              - HEFFITD_INC(i,j,n,bi,bj) 
              SIadv_Hsnow (i,j,n,bi,bj) = HSNOWITD(i,j,n,bi,bj)
     &                              - SIadv_Hsnow (i,j,n,bi,bj)
     &                              - HSNOWITD_INC(i,j,n,bi,bj) 
              SIadv_meltPd(i,j,n,bi,bj) = SImeltPd(i,j,n,bi,bj)
     &                              - SIadv_meltPd(i,j,n,bi,bj)
     &                              - SImeltPd_INC(i,j,n,bi,bj) 
              SIadv_qIce (i,j,l,n,bi,bj) = SIqIce (i,j,l,n,bi,bj)
     &                               - SIadv_qIce (i,j,l,n,bi,bj)
     &                              - SIqIce_INC(i,j,l,n,bi,bj) 
              SIadv_qSnow(i,j,l,n,bi,bj) = SIqSnow(i,j,l,n,bi,bj)
     &                               - SIadv_qSnow(i,j,l,n,bi,bj)
     &                              - SIqSnow_INC(i,j,l,n,bi,bj) 


>>>>>>>>>>>>>>>>>>>>>>>>>

MITgcm receives from GEOS:
 AREAITD (i,j,n)
 HEFFITD (i,j,n)
 HSNOWITD(i,j,n)
 SImeltPd(i,j,n)
 SIiceAge(i,j,n)
 TICES   (i,j,n)
 SIqIce  (i,j,l,n)
 SIqSnow (i,j,l,n)

from
MIT_GEOS5PlugMod/mitgcm_setup/code_split_driver/state/import/import_state_fill_mod.FOR
!     seaice and snow volume per grid-cell area [m]
            HEFFITD (i,j,n,bi,bj) = p%VOLICE(iSLo+i,jSLo+j,n)
            HSNOWITD(i,j,n,bi,bj) = p%VOLSNO(iSLo+i,jSLo+j,n)

>>>>>>>>>>>>>>>>>>>>>>>>>

In GEOS_OceanGridComp/MIT_GEOS5PlugMod/MIT_GEOS5PlugMod.F90
we send the following variables to GEOS:
    CALL MAPL_GetPointer(exportSI, DEL_FRACICE,'DEL_FRACICE', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_TI,   'DEL_TI', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_SI,   'DEL_SI', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_VOLICE, 'DEL_VOLICE', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_VOLSNO, 'DEL_VOLSNO', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_ERGICE, 'DEL_ERGICE', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_ERGSNO, 'DEL_ERGSNO', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_MPOND, 'DEL_MPOND', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_TAUAGE, 'DEL_TAUAGE', alloc=.true., __RC__)
    CALL MAPL_GetPointer(exportSI, DEL_HI, 'DEL_HI', alloc=.true., __RC__)

These are assigned in
GEOS_OceanGridComp/MIT_GEOS5PlugMod/mitgcm_setup/code_split_driver/state/export/export_state_fill_mod.FOR
            p%DELFRAICE(iSLo+i,jSLo+j,n) = SIadv_Area (i,j,n,bi,bj)
            p%DELTI    (iSLo+i,jSLo+j,n) = SIadv_tIces(i,j,n,bi,bj)
            p%DELSI(iSLo+i,jSLo+j) = SIadv_skinS(i,j,bi,bj)
            p%DELVOLICE(iSLo+i,jSLo+j,n) = SIadv_Heff (i,j,n,bi,bj)
            p%DELVOLSNO(iSLo+i,jSLo+j,n) = SIadv_Hsnow(i,j,n,bi,bj)
            p%DELERGICE(iSLo+i,jSLo+j,k) = SIadv_qIce(i,j,l,n,bi,bj)
            p%DELERGSNO(iSLo+i,jSLo+j,k) = SIadv_qSnow(i,j,l,n,bi,bj)
            p%DELMPOND (iSLo+i,jSLo+j,n) = SIadv_meltPd(i,j,n,bi,bj)
            p%DELTAUAGE(iSLo+i,jSLo+j,n) = SIadv_iceAge(i,j,n,bi,bj)
            p%DELHI(iSLo+i,jSLo+j) = SIadv_skinH(i,j,bi,bj)

after being define in:
GEOS_OceanGridComp/MIT_GEOS5PlugMod/configs/c90_llc90_02/code/seaice_save4gmao.F
SEAICE_LAYERS.h:C     SIadv_Area    :: advection increment of Seaice fraction  [-]
SEAICE_LAYERS.h:C     SIadv_Heff    :: advection increment of Seaice thickness [m]
SEAICE_LAYERS.h:C     SIadv_Hsnow   :: advection increment of snow thickness   [m]
SEAICE_LAYERS.h:C     SIadv_tIces   :: advection increment of ice surface temperature
SEAICE_LAYERS.h:C     SIadv_qIce    :: advection increment of Seaice enthalpy [J/m^2]
SEAICE_LAYERS.h:C     SIadv_qSnow   :: advection increment of Snow  enthalpy  [J/m^2]
SEAICE_LAYERS.h:C     SIadv_meltPd  :: advection increment of Melt Pond volume [m]
SEAICE_LAYERS.h:C     SIadv_iceAge  :: advection increment of Seaice Age       [s]
SEAICE_LAYERS.h:C     SIadv_skinS   :: advection increment of seaice skin salinity [psu]
SEAICE_LAYERS.h:C     SIadv_skinH   :: advection increment of seaice skin-layer depth [m]

I think what we need is to add the sea-ice IAU correction here:

              SIadv_Area  (i,j,n,bi,bj) = AREAITD (i,j,n,bi,bj)
     &                              - SIadv_Area  (i,j,n,bi,bj)
              SIadv_Heff  (i,j,n,bi,bj) = HEFFITD (i,j,n,bi,bj)
     &                              - SIadv_Heff  (i,j,n,bi,bj)
              SIadv_Hsnow (i,j,n,bi,bj) = HSNOWITD(i,j,n,bi,bj)
     &                              - SIadv_Hsnow (i,j,n,bi,bj)
              SIadv_meltPd(i,j,n,bi,bj) = SImeltPd(i,j,n,bi,bj)
     &                              - SIadv_meltPd(i,j,n,bi,bj)
              SIadv_iceAge(i,j,n,bi,bj) = SIiceAge(i,j,n,bi,bj)
     &                              - SIadv_iceAge(i,j,n,bi,bj)
              SIadv_tIces (i,j,n,bi,bj) = TICES   (i,j,n,bi,bj)
     &                              - SIadv_tIces (i,j,n,bi,bj)
              SIadv_qIce (i,j,l,n,bi,bj) = SIqIce (i,j,l,n,bi,bj)
     &                               - SIadv_qIce (i,j,l,n,bi,bj)
              SIadv_qSnow(i,j,l,n,bi,bj) = SIqSnow(i,j,l,n,bi,bj)
     &                               - SIadv_qSnow(i,j,l,n,bi,bj)

SIadv_skinS and SIadv_skinH are commented out

From ECCO we have available SIarea, SIheff, SIhsnow
How do we assign values for ITD distributions and for meltPd, iceAge, tIces,
qIce, and qSnow

One way might be a statistical attribution.  Find out the value of the missing
variables given the available ECCO variables over Fahad's 20-year simulation?

Other suggestions?
