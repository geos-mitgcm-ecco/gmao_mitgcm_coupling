	program ecco_iau_seaice

	implicit none
	integer*4 nx,ny, siz2d, siz3d, siz4d
	integer*4 nSnowLayers, nIceLayers, nITD
	parameter (nx=90, ny=nx*13)
	parameter (nSnowLayers=1,nIceLayers=4,nITD=5)
	parameter (siz2d=nx*ny, siz3d=nx*ny*nITD)
	parameter (siz4d=nx*ny*nIceLayers*nITD)
c	
c	iceNcat	
c	fldList = 'SIheffN ' 'SIhsnowN' 'SImeltPd' 'SIqSnow ' 'SIareaN '
c	dimList = [90 1170 5 5]
c	iceNcat_ice	
c	fldList = 'SIqIce  '
c	dimList = [90 1170 4*5]
c
	real*4 VOLICE_DENSITY, VOLSNO_DENSITY
	parameter (VOLICE_DENSITY=917, VOLSNO_DENSITY=330)
	real*4 deltat, SICEload_threshold
	parameter (deltat=450, SICEload_threshold=100)

	real*4 analysis4d1(nx,ny,nITD, 5)         ![nx ny 5 5Flds]
	real*4 analysis4d2(nx,ny,nIceLayers*nITD) ![nx ny 4*5]
	real*4 ecco2d1(nx,ny), ecco2d2(nx,ny), ecco2d3(nx,ny)
	real*4 HEFF_GEOS5(nx,ny), HSNOW_GEOS5(nx,ny), AREA_GEOS5(nx,ny)
	real*4 GEOS_frozen_load(nx,ny)
	real*4 ICESNO_ANALYSIS_INC(nx,ny), SCALING_FACTOR(nx,ny)
	real*4 ICESNO_ANALYSIS_INC1(nx,ny),SCALING_FACTOR1(nx,ny)
	real*4 ICESNO_ANALYSIS_INC2(nx,ny),SCALING_FACTOR2(nx,ny)
	real*4 ICESNO_ANALYSIS_INC3(nx,ny),SCALING_FACTOR3(nx,ny)
	real*4 snow_inc(nx,ny), area_inc(nx,ny)

	real*4 HEFFITD5(nx,ny,nITD), HSNOWITD5(nx,ny,nITD)
	real*4 AREAITD5(nx,ny,nITD)
	real*4 output(nx,ny,50)
	real*4 vmax, vmin, vmmn
	
	real*4 Mdays
	character*80 analysisFile(2), eccoFile(3), iauFile

C     === Local variables ===
        INTEGER  i,j,l,n
	LOGICAL  exst
	character*80 data_file

      NAMELIST /IAU_PARMS/
     & analysisFile, eccoFile, iauFile,
     & Mdays

C--   Default values
	data_file='data.iau_seaice'
        analysisFile = ' '
        eccoFile = ' '

        Mdays = 5.
        iauFile = 'SI_5days_iau.bin'

C--   Check for parameter file
      INQUIRE( FILE=data_file, EXIST=exst )
      IF (exst) THEN
       print *,
     &   ' opening file ',data_file
      ELSE
       print *,
     &  'File ',data_file,' does not exist!'
       STOP 'ABNORMAL END:  OPEN_DATA_FILE'
      ENDIF

C--   Open the parameter file
      OPEN( UNIT=99, FILE=data_file)
      READ( UNIT=99, NML=IAU_PARMS)
      CLOSE(99)

        IF ( analysisFile(1).NE.' ' .and. analysisFile(2).NE.' ' 
     &     .and. eccoFile(1).NE.' ' .and. eccoFile(2).NE.' ') THEN
        open(101,
     $          file    = analysisFile(1),
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
        open(102,
     $          file    = analysisFile(2),
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
        open(103,
     $          file    = eccoFile(1),
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
        open(104,
     $          file    = eccoFile(2),
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
        open(105,
     $          file    = eccoFile(3),
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')

	read(101) analysis4d1
	read(102) analysis4d2
	read(103) ecco2d1
	read(104) ecco2d2
	read(105) ecco2d3
	close(101)
	close(102)
	close(103)
	close(104)
	close(105)

c	fldList = 'SIheffN ' 'SIhsnowN' 'SImeltPd' 'SIqSnow ' 'SIareaN '
c distribute
	HEFFITD5 =analysis4d1(:,:,:,1)
	HSNOWITD5=analysis4d1(:,:,:,2)
	AREAITD5 =analysis4d1(:,:,:,5)
c ini
	  HEFF_GEOS5=0
	  HSNOW_GEOS5=0
	  AREA_GEOS5=0
c sum	
	DO n=1,nITD
	   HEFF_GEOS5 =HEFF_GEOS5 +HEFFITD5(:,:,n)
	   HSNOW_GEOS5=HSNOW_GEOS5+HSNOWITD5(:,:,n)
	   AREA_GEOS5 =AREA_GEOS5 +AREAITD5(:,:,n)
	ENDDO
c diff	
  	GEOS_frozen_load =
     &     HEFF_GEOS5 * VOLICE_DENSITY + HSNOW_GEOS5* VOLSNO_DENSITY
c  	ICESNO_ANALYSIS_INC = GEOS_frozen_load - ecco2d
  	ICESNO_ANALYSIS_INC1 = HEFF_GEOS5 - ecco2d1
  	ICESNO_ANALYSIS_INC2 = HSNOW_GEOS5- ecco2d2
  	ICESNO_ANALYSIS_INC3 = AREA_GEOS5 - ecco2d3

c scaling
	SCALING_FACTOR1=0
	vmax=-100
	vmin= 100
	vmmn= 0
	n   = 0
	DO j=1,ny
	DO i=1,nx
	  IF (GEOS_frozen_load(i,j) .GE. SICEload_threshold .AND.
     &              HEFF_GEOS5(i,j) .GT. 0         ) THEN
	  SCALING_FACTOR1(i,j) = ICESNO_ANALYSIS_INC1(i,j) /
     &                 HEFF_GEOS5(i,j)
     		vmax = MAX(vmax, SCALING_FACTOR1(i,j))
     		vmin = MIN(vmin, SCALING_FACTOR1(i,j))
		vmmn = vmmn + SCALING_FACTOR1(i,j)
		n = n + 1
	  ENDIF
	ENDDO
	ENDDO
	print *, 'max1=', vmax
	print *, 'min1=', vmin
	print *, 'mean1=', vmmn/real(n)

	SCALING_FACTOR2=0
	snow_inc=0
	vmax=-100
	vmin= 100
	vmmn= 0
	n   = 0
	DO j=1,ny
	DO i=1,nx
	  IF (GEOS_frozen_load(i,j) .GE. SICEload_threshold .AND.
     &             HSNOW_GEOS5(i,j) .GT. 0.1       ) THEN
	  SCALING_FACTOR2(i,j) = ICESNO_ANALYSIS_INC2(i,j) /
     &                 HSNOW_GEOS5(i,j)
     		vmax = MAX(vmax, SCALING_FACTOR2(i,j))
     		vmin = MIN(vmin, SCALING_FACTOR2(i,j))
		vmmn = vmmn + SCALING_FACTOR2(i,j)
		n = n + 1
	  ELSE
	  snow_inc(i,j) = ICESNO_ANALYSIS_INC2(i,j) / real(nITD)
	  ENDIF
	ENDDO
	ENDDO
	print *, 'max2=', vmax
	print *, 'min2=', vmin
	print *, 'mean2=', vmmn/real(n)

	SCALING_FACTOR3=0
	area_inc=0
	vmax=-100
	vmin= 100
	vmmn= 0
	n   = 0
	DO j=1,ny
	DO i=1,nx
	  IF (GEOS_frozen_load(i,j) .GE. SICEload_threshold .AND.
     &              AREA_GEOS5(i,j) .GT. 0.15      ) THEN
chzh: 0.1 BAD; 0.15 OK     
	  SCALING_FACTOR3(i,j) = ICESNO_ANALYSIS_INC3(i,j) /
     &                  AREA_GEOS5(i,j)
     		vmax = MAX(vmax, SCALING_FACTOR3(i,j))
     		vmin = MIN(vmin, SCALING_FACTOR3(i,j))
		vmmn = vmmn + SCALING_FACTOR3(i,j)
		n = n + 1
	  ELSE
	  area_inc(i,j) = ICESNO_ANALYSIS_INC3(i,j) / real(nITD)
	  ENDIF
	ENDDO
	ENDDO
	print *, 'max3=', vmax
	print *, 'min3=', vmin
	print *, 'mean3=', vmmn/real(n)

c output factor
	  IF ( .FALSE. ) THEN
c	  IF ( .TRUE. ) THEN
        open(103,
     $          file    = 'scale1.bin',
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
		write(103) SCALING_FACTOR1
	close(103)
        open(104,
     $          file    = 'scale2.bin',
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
		write(104) SCALING_FACTOR2
	close(104)
        open(105,
     $          file    = 'scale3.bin',
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
		write(105) SCALING_FACTOR3
	close(105)
        open(106,
     $          file    = 'snow_inc.bin',
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
		write(106) snow_inc
	close(106)
        open(107,
     $          file    = 'area_inc.bin',
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
		write(107) area_inc
	close(107)
	  ENDIF

c filling
	output=0
	vmmn = deltat / (Mdays*86400.)
	DO n=1, nITD
	   output(:,:,n+ 5) = SCALING_FACTOR1 * analysis4d1(:,:,n,1)
	   output(:,:,n+15) = SCALING_FACTOR2 * analysis4d1(:,:,n,2)
	   output(:,:,n+20) = SCALING_FACTOR1 * analysis4d1(:,:,n,3)
	   output(:,:,n+25) = SCALING_FACTOR2 * analysis4d1(:,:,n,4)
	   output(:,:,n+10) = SCALING_FACTOR3 * analysis4d1(:,:,n,5)
	ENDDO
	DO n=1, nITD*nIceLayers
	   output(:,:,n+30) = SCALING_FACTOR1 * analysis4d2(:,:,n)
	ENDDO
c thin snow+area: addition	
	DO n=1, nITD
	   output(:,:,n+15) = output(:,:,n+15) + snow_inc
	   output(:,:,n+10) = output(:,:,n+10) + area_inc
	ENDDO
	output = output * vmmn

c output
        open(103,
     $          file    = iauFile,
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')
		write(103) output
	close(103)

        ENDIF

      stop
      end

