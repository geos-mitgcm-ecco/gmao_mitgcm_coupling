	program ecco_iau_seaice

	implicit none
	integer*4 nx,ny, siz2d, siz3d, siz4d
	integer*4 nSnowLayers, nIceLayers, nITD
	parameter (nx=90, ny=nx*13)
	parameter (nSnowLayers=1,nIceLayers=4,nITD=5)
	parameter (siz2d=nx*ny, siz3d=nx*ny*nITD)
	parameter (siz4d=nx*ny*nIceLayers*nITD)

	integer*4 inp1, inp2, inp3, inp4
	integer*4 jnp1, jnp2, jnp3, jnp4
	parameter (inp1=45, inp2=46, inp3=45, inp4=46)
	parameter (jnp1=585,jnp2=585,jnp3=586,jnp4=586)

c	
c	iceNcat	
c	fldList = 'SIheffN ' 'SIhsnowN' 'SImeltPd' 'SIqSnow'
c	dimList = [90 1170 5 4]
c	iceNcat_ice	
c	fldList = 'SIqIce  '
c	dimList = [90 1170 4*5]
c
	real*4 VOLICE_DENSITY, VOLSNO_DENSITY
	parameter (VOLICE_DENSITY=917, VOLSNO_DENSITY=330)
	real*4 deltat, SICEload_threshold
	parameter (deltat=450, SICEload_threshold=100)

	real*4 analysis4d1(nx,ny,nITD, 4)         ![nx ny 5 4Flds]
	real*4 analysis4d2(nx,ny,nIceLayers*nITD) ![nx ny 4*5]
	real*4 ecco2d(nx,ny)
	real*4 HEFF_GEOS5(nx,ny), HSNOW_GEOS5(nx,ny)
	real*4 GEOS_frozen_load(nx,ny)
	real*4 ICESNO_ANALYSIS_INC(nx,ny),SCALING_FACTOR(nx,ny)

	real*4 HEFFITD5(nx,ny,nITD), HSNOWITD5(nx,ny,nITD)
	real*4 output(nx,ny,50)
	real*4 vmax, vmin, vmmn
	
	real*4 Mdays
	character*80 analysisFile(2), eccoFile, iauFile

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
     &                              .and. eccoFile.NE.' ') THEN
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
     $          file    = eccoFile,
     $          form    = 'unformatted',
     $          status  = 'unknown',
     $          access  = 'stream')

	read(101) analysis4d1
	read(102) analysis4d2
	read(103) ecco2d
	close(101)
	close(102)
	close(103)

c	fldList = 'SIheffN ' 'SIhsnowN' 'SImeltPd' 'SIqSnow'
c distribute
	HEFFITD5 =analysis4d1(:,:,:,1)
	HSNOWITD5=analysis4d1(:,:,:,2)
c ini
	  HEFF_GEOS5=0
	  HSNOW_GEOS5=0
c sum	
	DO n=1,nITD
	   HEFF_GEOS5 =HEFF_GEOS5 +HEFFITD5(:,:,n)
	   HSNOW_GEOS5=HSNOW_GEOS5+HSNOWITD5(:,:,n)
	ENDDO
c diff	
  	GEOS_frozen_load =
     &     HEFF_GEOS5 * VOLICE_DENSITY + HSNOW_GEOS5* VOLSNO_DENSITY
  	ICESNO_ANALYSIS_INC = GEOS_frozen_load - ecco2d

c scaling
	SCALING_FACTOR=0
	vmax=-100
	vmin= 100
	vmmn= 0
	n   = 0
	DO j=1,ny
	DO i=1,nx
c case1	normal
	  IF (GEOS_frozen_load(i,j) .GE. SICEload_threshold) THEN
	  SCALING_FACTOR(i,j) = ICESNO_ANALYSIS_INC(i,j) /
     &                 GEOS_frozen_load(i,j)
     		vmax = MAX(vmax, SCALING_FACTOR(i,j))
     		vmin = MIN(vmin, SCALING_FACTOR(i,j))
		vmmn = vmmn + SCALING_FACTOR(i,j)
		n = n + 1
	  ENDIF
	ENDDO
	ENDDO
	DO j=1,ny
	DO i=1,nx
c case2	thin, goes<ecco
	  IF (GEOS_frozen_load(i,j) .LT. SICEload_threshold .and.
     &                 ICESNO_ANALYSIS_INC(i,j) .LT. 0) THEN
	  SCALING_FACTOR(i,j) = (SCALING_FACTOR(inp1,jnp1) + 
     &                           SCALING_FACTOR(inp2,jnp2) +
     &                           SCALING_FACTOR(inp3,jnp3) +
     &                           SCALING_FACTOR(inp4,jnp4) )/4.
     		vmax = MAX(vmax, SCALING_FACTOR(i,j))
     		vmin = MIN(vmin, SCALING_FACTOR(i,j))
		vmmn = vmmn + SCALING_FACTOR(i,j)
		n = n + 1
	  ENDIF
	ENDDO
	ENDDO
c case3	thin, goes>=ecco already set by SCALING_FACTOR=0
	print *, 'max=', vmax
	print *, 'min=', vmin
	print *, 'mean=', vmmn/real(n)
c output factor
c        open(103,
c     $          file    = 'scale.bin',
c     $          form    = 'unformatted',
c     $          status  = 'unknown',
c     $          access  = 'stream')
c		write(103) SCALING_FACTOR
c	close(103)

c filling
	output=0
	vmmn = deltat / (Mdays*86400.)
	DO n=1, nITD
	   output(:,:,n+ 5) = SCALING_FACTOR * analysis4d1(:,:,n,1)
	   output(:,:,n+15) = SCALING_FACTOR * analysis4d1(:,:,n,2)
	   output(:,:,n+20) = SCALING_FACTOR * analysis4d1(:,:,n,3)
	   output(:,:,n+25) = SCALING_FACTOR * analysis4d1(:,:,n,4)
	ENDDO
	DO n=1, nITD*nIceLayers
	   output(:,:,n+30) = SCALING_FACTOR * analysis4d2(:,:,n)
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

