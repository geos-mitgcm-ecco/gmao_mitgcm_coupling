restarts   restart and configuration files for each segment

holding    GEOS atmospheric model output collections

mit_output MITgcm oceanic model output files

figs       figures, including the MITgcm MONITOR collection and
           examination of some model issues

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Visualizations:
https://portal.nccs.nasa.gov/datashare/g6dev/WebGL/geos_dyamondv2.html
https://data.nas.nasa.gov/viz/vizdata/DYAMOND_c1440_llc2160/GEOS/index.html
https://data.nas.nasa.gov/viz/vizdata/DYAMOND_c1440_llc2160/MITgcm/index.html
https://data.nas.nasa.gov/viz/data.php?dir=/vizdata/nmccurdy/DYAMOND_c1440_llc2160/native_grid

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Surface currents in netcdf format are also available in folder:
/nobackup/htorresg/air_sea/ocean-atmos/NCFILES/geosgcm_surf_tides_4km/

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Description of simulation segments:

/nobackupp11/dmenemen/DYAMOND/geos5/TEST_69/scratch
   passive-ocean spin-up, with tides, non-hydrostatic
   1-day integration: 20200119_2100z to 20200120_2100z
   Start: Jan 30 04:43, First_prs: 07:33, End: 18:37, Wallclock: 13:54
   followed compilation and set-up instructions in
   gmao_mitgcm_couplng/experiments/c1440_llc2160_02/Heracles-5_4onPleiades.txt
   20200119_2100z atmospheric initial conditions from Atanas/Bin
      /nobackupp11/dmenemen/DYAMOND/c1440_IC/IC_from_merra2/*_rst.20200119_21z.bin
      /nobackupp11/dmenemen/DYAMOND/c1440_IC/IC_from_S2S/fvcore_internal_rst_c1440_072L
      /nobackupp11/dmenemen/DYAMOND/c1440_IC/IC_from_S2S/gocart_internal_rst_c1440_072L
      /nobackupp11/dmenemen/DYAMOND/c1440_IC/IC_from_S2S/moist_internal_rst_c1440_072L
      /nobackupp11/dmenemen/DYAMOND/c1440_IC/SaltWater/saltwater_internal_rst-mit_inserted-llc2160
   20200119_2100z ocean initial conditions from llc2160
      /nobackupp11/dmenemen/DYAMOND/llc2160_IC/*.0000706320.data
   fvcore_layout: Make_NH: .true.
   AGCM.rc: LAKE_INTERNAL_RESTART_TYPE:    binary
            LANDICE_INTERNAL_RESTART_TYPE: binary
            CATCH_INTERNAL_RESTART_TYPE:   binary
            STEADY_STATE_OCEAN: 0

restarts/e20200119_21z
   active ocean, with tides, non-hydrostatic
   1-day integration: 20200119_2100z to 20200120_2100z (0000000000 to 0000001920)
   ~Start: Jan 30 21:21, First_prs: Jan 31 00:11, End: 11:55, ~Wallclock: 14:34
   followed instructions in /nobackupp11/dmenemen/DYAMOND/geos5/readme.txt
   20200119_2100z atmospheric initial conditions from Atanas
      except for saltwater, solar, irrad from TEST_69:
      cp ../TEST_69/scratch/saltwater_internal_checkpoint saltwater_internal_rst
      cp ../TEST_69/scratch/solar_internal_checkpoint solar_internal_rst
      cp ../TEST_69/scratch/irrad_internal_checkpoint irrad_internal_rst
   20200119_2100z ocean initial conditions from llc2160
      /nobackupp11/dmenemen/DYAMOND/llc2160_IC/*.0000706320.data
   forgot to set "Make_NH: .true." in fvcore_layout

restarts/e20200120_21z
   1-day integration: 20200120_2100z to 20200121_2100z (0000001920 to 0000003840)
   ~Start: Jan 31 19:12, First_prs: 21:20, End: Feb 1 08:19, ~Wallclock: 13:07

restarts/e20200121_21z
   2-day integration: 20200121_2100z to 20200123_2100z (0000003840 to 0000007680)
   ~Start: Feb 1 9:42, First_prs: 11:50, End: Feb 2 09:34, ~Wallclock: 23:52
   CAP.rc and data changed to 2-day segments
   HISTORY.rc add vertically integrated TQR/TQS and hourly 3D QV/QL/QI

restarts/e20200123_21z
   2-day integration: 20200123_2100z to 20200125_2100z (0000007680 to 0000011520)
   ~Start: Feb 2 9:56, First_prs: 12:04, End: Feb 3 09:40, ~Wallclock: 23:44
   HISTORY.rc add tavg2d_aer_x, tavg_01hr_3d_P_Mv, and inst_01hr_3d_U/V/W/H
              remove const_2d_asm_Mx, tavg_01hr_3d_U/V/W/H

restarts/e20200125_21z
   4-day integration: 20200125_2100z to 20200129_2100z (0000011520 to 0000019200)
   ~Start: Feb 3 10:53, First_prs: 13:01, End: Feb 5 09:19, ~Wallclock: 47:44
   CAP.rc, AGCM.rc, and data changed to 4-day segments with 2-day restarts

restarts/e20200129_21z
   4-day integration: 20200129_2100z to 20200202_2100z (0000019200 to 0000026880)
   ~Start: Feb 5 9:53, First_prs: 12:01, End:  Feb 7 10:04, ~Wallclock: 48:11
   data.seaice SEAICElinearIterMax=300 still does not fully converge to 1e-5
   KPP_OPTIONS.h #define KPP_SMOOTH_DIFF reduces Arctic oceQnet grid-scale noise
   AGCM.rc SOLAR_DT=IRRAD_DT=450 does not reduce oceFWflx sea ice patches
   HISTORY.rc add geosgcm_pressure

restarts/e20200202_21z
   4-day integration: 20200202_2100z to 20200206_2100z (0000026880 to 0000034560)
   ~Start: Feb 7 10:12, First_prs: 12:20, End: Feb 10 02:06, ~Wallclock: 63:54
   AGCM.rc SOLAR_DT=IRRAD_DT=45 does not remove oceFWflx sea ice patches

restarts/e20200206_21z
   4-day integration: 20200206_2100z to 20200210_2100z (0000034560 to 0000042240)
   Start: Feb 10 03:22, First_prs: 05:30, End: Feb 12 02:37, Wallclock: 47:15
   data.seaice SEAICElinearIterMax=400 still does not fully converge to 1e-5
   AGCM.rc SOLAR_DT=IRRAD_DT=900
   HISTORY.rc add geosgcm_saltwatercube, geosgcm_saltwater, and geosgcm_guest

restarts/e20200210_21z
   4-day integration: 20200210_2100z to 20200214_2100z (0000042240 to 0000049920)
   GEOSgcm: fix for CICE_Thermo profile to remove oceFWflx patches
   Start: Feb 12 08:06, First_prs: 10:12, Hung: Feb 14 09:32
   Job hung while writing e20200214_21z fvcore_internal_checkpoint

restarts/e20200212_21z
   8-day integration: 20200212_2100z to 20200220_2100z (0000046080 to 0000061440)
   Start: Feb 15 10:40, First_prs: 12:39, Crashed: Feb 20 00:45
   History.rc remove geosgcm_saltwatercube, geosgcm_saltwater, and geosgcm_guest
   Job crashed on 2020/02/20  Time: 16:12:45
   MPT: #6  0x0000000002d7f49d in wscale_ ()
   MPT: #7  0x0000000002d7e21e in bldepth_ ()
   MPT: #8  0x0000000002d7d92e in kppmix_ ()

restarts/e20200218_21z
   2-day integration: 20200218_2100z to 202002200_2100z (0000057600 to 0000061440)
   Start: Feb 20 08:06, First_prs: 10:15, End: Feb 21 13:17, Wallclock: 29:11
   Cap sea-ice velocity at +/- 10 m/s

restarts/e20200220_21z
   4-day integration: 20200220_2100z to 20200224_2100z (0000061440 to 0000069120)
   Start: Feb 21 16:56, First_prs: 19:05, Stopped: Feb 22 21:20
   Adding optimized GEOS restart
   Job stopped after writing checkpoint.20200222_2100z

restarts/e20200222_21z
   4-day integration: 20200222_2100z to 20200226_2100z (0000065280 to 0000072960)
   Start: Feb 22 21:34, First_prs: 23:52, End: Feb 25 05:21, Wallclock: 55:47
   Adding "INTERPOLATE_ATMTAU: 1" And 1E-5 areaS/W SEAICEscaleSurfStress mask
   *rst files accidentally deleted

restarts/e20200226_21z
   4-day integration: 20200226_2100z to 20200301_2100z (0000072960 to 0000080640)
   Start: Feb 26 1:32, logfile: 1:35, First_prs: 03:40, End: Feb 28 09:12, Wallclock: 55:40
   Removing 1E-5 areaS/W SEAICEscaleSurfStress mask
   Adding "if Heff < 1.e-5: area = 0, heff = 0, hsnow = 0" in dynsolver
   data.seaice: SEAICElinearIterMax=200, SEAICE_maskRHS=.TRUE.,

restarts/e20200301_21z
   4-day integration: 20200301_2100z to 20200305_2100z (0000080640 to 0000088320)
   Start: Feb 28 9:38, logfile: 9:47, First_prs: 11:47, End: Mar 2 12:49, Wallclock: 51:11
   *rst files accidentally deleted

restarts/e20200305_21z
   8-day integration: 20200305_2100z to 20200313_2100z (0000088320 to 0000103680)
   Start: Mar 2 13:11, logfile: 13:15, First_prs: 15:07, End: Mar 6 10:06, Wallclock: 92:55

restarts/e20200313_21z
   8-day integration: 20200313_2100z to 20200313_2100z (0000103680 to 0000119040)
   Start: Mar 6 10:55, logfile: 10:57, First_prs: 12:41, End: Mar 10 3:32, Wallclock: 88:37
   HISTORY.rc remove WU and WV collections

restarts/e20200321_21z
   8-day integration: 20200313_2100z to 20200321_2100z (0000119040 to 0000134400)
   Start: Mar 10 7:31, logfile: 7:33, First_prs: 9:15, Stopped: Mar 11 6:40
   Job stopped after writing checkpoint.20200323_2100z (0000122880)

restarts/e20200323_21z
   8-day integration: 20200323_2100z to 20200331_2100z (0000122880 to 0000138240)
   Start: Mar 11 7:09, logfile: 7:11, First_prs: 8:57, End: Mar 15 1:34, Wallclock: 90:25
   Adding new sea-ice regularization

restarts/e20200331_21z
   8-day integration: 20200331_2100z to 20200408_2100z (0000138240 to 0000153600)
   ~Start: Mar 15 2:21, logfile: 2:23, First_prs: 4:02, End: Mar 18 3:08, Wallclock: 72:47
   data.seaice: SEAICE_maskRHS=.FALSE.,
   compiling without -ieee and with -Ofast

restarts/e20200408_21z
   8-day integration: 20200408_2100z to 20200416_2100z (0000153600 to 0000168960)
   Start: Mar 18 4:49, logfile: 4:52, First_prs: 6:30, End: Mar 21 4:10, Wallclock: 71:21

restarts/e20200416_21z
   8-day integration: 20200416_2100z to 20200424_2100z (0000168960 to 0000184320)
   Start: Mar 21 4:45, logfile: 4:47, First_prs: 6:23, End: Mar 24 4:46, Wallclock: 72:01

restarts/e20200424_21z
   8-day integration: 20200424_2100z to 20200502_2100z (0000184320 to 0000199680)
   Start: Mar 24 5:56, logfile: 5:58, First_prs: 7:39, End: Mar 27 9:00, Wallclock: 75:04

restarts/e20200502_21z
   8-day integration: 20200502_2100z to 20200510_2100z (0000199680 to 0000215040)
   Start: Mar 27 9:50, logfile: 9:52, First_prs: 11:33, End: Mar 30 10:26, Wallclock: 72:36

restarts/e20200510_21z
   8-day integration: 20200510_2100z to 20200518_2100z (0000215040 to 0000230400)
   Start: Mar 30 11:05, logfile: 11:07, First_prs: 12:52, End: Mar 31 6:47
   Job stopped after writing checkpoint.20200512_2100z (0000218880)

restarts/e20200512_21z
   8-day integration: 20200512_2100z to 20200520_2100z (0000218880 to 0000234240)
   Start: Apr 2 14:17, logfile: 14:19, First_prs: 15:59, End: Apr 5 12:37, Wallclock: 70:20

restarts/e20200520_21z
   8-day integration: 20200520_2100z to 20200528_2100z (0000234240 to 0000249600)
   Start: Apr 5 12:53, logfile: 12:55, First_prs: 14:38, End: Apr 8 11:47, Wallclock: 70:54

restarts/e20200528_21z
   8-day integration: 20200528_2100z to 20200605_2100z (0000249600 to 0000264960)
   Start: Apr 21 17:10, logfile: 17:14, First_prs: 20:04, End: Apr 22 20:35
   Integration on rome nodes with bug fix for gad_fluxlimit_*.F
   CAP.rc: NASYNC: 3, NUM_CORES_ON_ROOT_NODE: 16
   Job stopped after writing checkpoint.20200530_2100z (0000253440)

restarts/e20200530_21z
   8-day integration: 20200530_2100z to 20200607_2100z (0000253440 to 0000268800)
   Start: Apr 23 12:26, logfile: 12:36, First_prs: 15:20, End: Apr 24 16:35
   MAX_WORK_REQUESTS = 200 in GEOSodas/src/GMAO_Shared/MAPL_Base/MAPL_CFIOServer.F90
   qsub -I -q R10734631 -l select=70:ncpus=128:model=rom_ait:aoe=sles15
   Job stopped after writing checkpoint.20200601_2100z (0000257280)
   Crashed due to Arctic sea-ice issue on 2020/06/02  Time: 20:03:45

restarts/e20200601_21z
   8-day integration: 20200601_2100z to 20200609_2100z (0000257280 to 0000272640)
   Start: Apr 28 2:33, logfile: 2:43, First_prs: 5:28, End: Apr 29 14:50
   new zap_small_areas in GEOSodas/src/GMAO_Shared/LANL_Shared/LANL_cice/source/ice_itd.F90
   added max(sIceLoad)=10 in seaice_model.F
   qsub select=65:ncpus=128+3:ncpus=24
   Job stopped after writing checkpoint.20200603_2100z (0000261120)
   Crashed while writing orad_import_checkpoint.20200605_2100z.bin

restarts/e20200603_21z
   24-day integration: 20200603_2100z to 20200627_2100z (0000261120 to 0000307200)
   Start: Apr 29 17:24, logfile: 17:35, First_prs: 20:24, End: May 1 14:01
   CAP.rc  -> JOB_SGMT: 00000024 000000, NUM_CORES_ON_ROOT_NODE: 8
   AGCM.rc -> RECORD_FREQUENCY: 720000
   Job stopped after writing checkpoint.20200605_2100z (0000264960)
   Crashed while writing orad_import_checkpoint.20200608_2100z.bin

restarts/e20200605_21z
   24-day integration: 20200605_2100z to 20200629_2100z (0000264960 to 0000311040)
   output on /nobackupnfs2/dmenemen/TEST/scratch
   Start: May 4 9:39, logfile: 9:45, First_prs: 12:21, End: May 10 6:14
   Job stopped after writing checkpoint.20200617_2100z.bin (0000288000)
   Crashed due to fvdycore on 2020/06/23  Time: 14:02:15

restarts/e20200617_21z
   24-day integration: 20200617_2100z to 20200711_2100z (0000288000 to 0000334080)
   data pChkptFreq/chkptFreq=259200.0
   revert to gad_fluxlimit_*.F from core MITgcm, after bug fix there
   Start: May 10 14:42, logfile: 14:48, First_prs: 17:13, End: May 12 7:01
   Job stopped after writing checkpoint.20200620_2100z (0000293760)
   Stopped due to system shutdown on 2020/06/22  Time: 17:53:15

restarts/e20200620_21z
   24-day integration: 20200620_2100z to 20200714_2100z (0000293760 to 0000339840)
   Start: May 26 9:46, logfile: 9:48, First_prs: 11:54, End: May 28 14:04
   Job stopped after writing checkpoint.20200623_2100z (0000299520)
   Crashed while writing orad_import_checkpoint.20200626_2100z.bin

restarts/e20200623_21z
   24-day integration: 20200623_2100z to 20200717_2100z (0000299520 to 0000345600)
   Start: May 28 15:16, logfile: 15:18, First_prs: 17:26, End: May 31 15:21
   Job stopped after writing checkpoint.20200629_2100z (0000311040)
   Crashed while writing orad_import_checkpoint.20200702_2100z.bin

restarts/e20200629_21z
   24-day integration: 20200629_2100z to 20200723_2100z (0000311040 to 0000357120)
   Start: Jun 1 4:35, logfile: 4:36, First_prs: 6:44, End: Jun 3 6:17
   Job stopped after writing checkpoint.20200702_2100z (0000316800)
   Crashed while writing orad_import_checkpoint.20200705_2100z.bin

restarts/e20200702_21z
   9-day integration: 20200702_2100z to 20200711_2100z (0000316800 to 0000334080)
   data nTimeSteps=17280, pChkptFreq=777600.0, remove chkptFreq
   CAP.rc  -> JOB_SGMT: 00000009 000000
   AGCM.rc -> comment out RECORD_*
   Start: Jun 07 16:04:24, logfile: 16:07, First_prs: 18:11, End: Jun 10 13:55:59, Wallclock: 69:50:00

restarts/e20200711_21z
   9-day integration: 20200711_2100z to 20200720_2100z (0000334080 to 0000351360)
   data pChkptFreq=259200.0
   Start: Jun 11 03:19:16, logfile: 03:23, First_prs: 05:30, End: Jun 14 00:06:34, Wallclock: 68:45:23

restarts/e20200720_21z
   9-day integration: 20200720_2100z to 20200729_2100z (0000351360 to 0000368640)
   Start: Jun 14 05:18:35, logfile: 05:22, First_prs: 07:29, End: Jun 17 02:03:28, Wallclock: 68:42:55

restarts/e20200729_21z
   9-day integration: 20200729_2100z to 20200807_2100z (0000368640 to 0000385920)
   Start: Jun 17 09:06:00, logfile: 09:09, First_prs: 20:12, End: Jun 20 14:07:04, Wallclock: 68:03:13

restarts/e20200807_21z
   9-day integration: 20200807_2100z to 20200816_2100z (0000385920 to 0000403200)
   Start: Jun 24 14:05:46, logfile: 14:09, First_prs: 16:16, End: Jun 27 11:45:02, Wallclock: 69:37:18

restarts/e20200816_21z
   12-day integration: 20200816_2100z to 20200828_2100z (0000403200 to 0000426240)
   data -> nTimeSteps=23040; CAP.rc -> JOB_SGMT: 00000012 000000
   Start: Jul 02 12:42:28, logfile: 13:15, First_prs: 15:26, End: Jul 6 11:10:46, Wallclock: 94:26:26

restarts/e20200828_21z
   6-day integration: 20200828_2100z to 20200903_2100z (0000426240 to 0000437760)
   data -> nTimeSteps=11520, pChkptFreq=518400.0; CAP.rc -> JOB_SGMT: 00000006 000000
   Start: Jul 06 12:19:14, logfile: 12:22, First_prs: 14:35, End: Jul 8 15:52:36, Wallclock: 51:31:36

restarts/e20200903_21z
   12-day integration: 20200903_2100z to 20200915_2100z (0000437760 to 0000460800)
   data -> nTimeSteps=23040, pChkptFreq=1036800.0; CAP.rc -> JOB_SGMT: 00000012 000000
   Start: Jul 08 18:40:33, logfile: 18:44, First_prs: 20:57, End: Jul 12 18:13:58, Wallclock: 95:31:30

restarts/e20200915_21z
   12-day integration: 20200915_2100z to 20200927_2100z (0000460800 to 0000483840)
   Start: Jul 13 08:12:53, logfile: 8:16, First_prs: 10:34, End: Jul 17 11:50:02, Wallclock: 99:35:05

restarts/e20200927_21z
   12-day integration: 20200927_2100z to 20201009_2100z (0000483840 to 0000506880)
   mitocean_run/data pChkptFreq=259200.0
   Start: Jul 18 15:04:12, logfile: 15:07, First_prs: 17:35, End: Jul 22 19:22:40, Wallclock: 100:16:34

restarts/e20201009_21z
   12-day integration: 20201009_2100 to 20201021_2100z (0000506880 to 0000529920)
   Start: Jul 26 14:30:37, logfile: 14:49, First_prs: 17:09, End: Jul 30 12:13:02, Wallclock: 93:40:22

restarts/e20201021_21z
   12-day integration: 20201021_2100 to 20201102_2100z (0000529920 to 0000552960)
   moving to /nobackupp18
   Start: Jul 30 14:24:53, logfile: 14:49, First_prs: 16:58, End: Aug 3 13:57:51, Wallclock: 95:32:23

restarts/e20201102_21z
   12-day integration: 20201102_2100 to 20201114_2100z (0000552960 to 0000576000)
   moving back to /nobackupnfs2
   Start: Aug 5 18:50:47, logfile: 18:54, First_prs: 21:00, End: Aug 9 14:55:47, Wallclock: 92:02:58

restarts/e20201114_21z
   12-day integration: 20201114_2100 to 20201126_2100z (0000576000 to 0000599040)
   Start: Aug 9 20:19:56, logfile: 20:23, First_prs: 22:30, End: Aug 9 14:55:47, Wallclock: 98:09:38

restarts/e20201126_21z
   12-day integration: 20201126_2100 to 20201208_2100z (0000599040 to 0000622080)
   Start: Aug 19 03:23:40, logfile: 20:23, First_prs: 22:30, End: Aug 22 23:51:45, Wallclock: 92:25:58

restarts/e20201208_21z
   12-day integration: 20201208_2100 to 20201220_2100z (0000622080 to 0000645120)
   Start: Aug 25 06:01:00, logfile: 6:05, First_prs: 8:09, End: Aug 29 00:09:52, Wallclock: 90:06:33

restarts/e20201220_21z
   12-day integration: 20201220_2100 to 20210101_2100z (0000645120 to 0000668160)
   Start: Sep 4 06:24:21, logfile: 6:28, First_prs: 8:33, End: Sep 8 04:05:08, Wallclock: 93:39:35

restarts/e20210101_21z
   12-day integration: 20210101_2100 to 20210113_2100z (0000668160 to ...)
   Crashed after 2021/01/09 06:52:30 with SIGFPE(8)
   MPT: #6  0x00000000034bc095 in chem_utilmod_mp_chem_utiltroppfixer_ ()
   MPT: #7  0x0000000001e9e295 in cfc_gridcompmod_mp_cfc_gridcomprun_ ()
   MPT: #8  0x0000000001e9a9ee in aero_gridcompmod_mp_aero_gridcomprun_ ()
   MPT: #9  0x0000000001dff470 in gocart_gridcompmod_mp_run__ ()

restarts/e20210101_21z
   6-day integration: 20210101_2100 to 20210107_2100z (0000668160 to 0000679680)
   CAP.rc -> JOB_SGMT: 00000006 000000
   Start: Sep 13 20:08:58, logfile: 20:12, First_prs: 22:18, End: Sep 15 21:34:46, Wallclock: 49:23:52

restarts/e20210107_21z
   3-day integration: 20210107_2100 to 20210110_2100z (0000679680 to )
   CAP.rc -> JOB_SGMT: 00000003 000000; mitocean_run/eedata debugMode=.TRUE., data viscAr= 5.66141e-04,
   Crashed after 2021/01/09 06:27:45 with SIGFPE(8)
   MPT: #6  0x00000000034bc095 in chem_utilmod_mp_chem_utiltroppfixer_ ()

restarts/e20210107_21z
   6-day integration: 20210107_2100 to 20210113_2100z (0000679680 to 0000691200)
   CAP.rc -> JOB_SGMT: 00000006 000000; Chem_Registry.rc doing_CFC: no
   mitocean_run/eedata #debugMode=.TRUE., data viscAr= 5.6614e-04,
   Start: Sep 17 12:46:56, logfile: 12:50, First_prs: 14:55, End: Sep 19 18:19:49, Wallclock: 53:30:56

restarts/e20210113_21z
   12-day integration: 20210113_2100 to 20210125_2100z (0000691200 to 0000714240)
   CAP.rc -> JOB_SGMT: 00000012 000000
   Start: Sep 28 15:53:41, logfile: 16:05, First_prs: 18:17, End: Oct 2 08:21:09, Wallclock: 88:25:22

restarts/e20210125_21z
   12-day integration: 20210125_2100 to 20210206_2100z (0000714240 to 0000737280)
   Start: Oct 2 08:46:52, logfile: 8:50, First_prs: 10:57, End: Oct 6 06:36:21, Wallclock: 93:47:18

restarts/e20210206_21z
   12-day integration: 20210206_2100 to 20210218_2100z (0000737280 to 0000760320)
   Start: Oct 6 08:55:21, logfile: 8:59, First_prs: 11:06, End: Oct 10 15:28:5, Wallclock: 102:31:28

restarts/e20210218_21z
   6-day integration: 20210218_2100 to 20210224_2100z (0000760320 to 0000771840)
   CAP.rc -> JOB_SGMT: 00000006 000000
   Start: Oct 10 17:59:21, logfile: 18:02, First_prs: 20:10, End: Oct 12 21:36:26, Wallclock: 62:00:00

restarts/e20210224_21z
   12-day integration: 20210224_2100 to 20210308_2100z (0000771840 to 0000794880)
   CAP.rc -> JOB_SGMT: 00000012 000000
   Start: Oct 13 7:18:22, logfile: 7:22, First_prs: 9:28, End: Oct 17 10:35:06, Wallclock: 87:46:58

restarts/e20210206_21z
   12-day integration: 20210308_2100 to 20210320_2100z (0000794880 to 0000817920)
   Start: Oct 18 11:25:50, logfile: 11:29, First_prs: 13:35, End: Oct 22 5:50:22, Wallclock:90:22:34

restarts/e20210206_21z
   12-day integration: 20210320_2100 to 20210326_1815z (0000817920 to 0000829200)
   Start: Oct 22 8:50:10, logfile: 8:54, First_prs: 11:01, End: Oct 24 06:02:05, Wallclock:45:09:57
   INCOMPLETE because reservation expired
