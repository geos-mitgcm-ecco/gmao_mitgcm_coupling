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
