!BOP
!    !ROUTINE: SIZE_f90.h
!EOP
      INTEGER sNx
      INTEGER sNy
      INTEGER OLx
      INTEGER OLy
      INTEGER nSx
      INTEGER nSy
      INTEGER nPx
      INTEGER nPy
      INTEGER Nx
      INTEGER Ny
      INTEGER Nr
      PARAMETER ( &
                sNx = 180, &
                sNy = 168, &
                OLx =   1, &
                OLy =   1, &
                nSx =   1, &
                nSy =   1, &
                nPx =   1, &
                nPy =   1, &
                Nx  = sNx*nSx*nPx, &
                Ny  = sNy*nSy*nPy, &
                Nr  =   1)

!     MAX_OLX :: Set to the maximum overlap region size of any array
!     MAX_OLY    that will be exchanged. Controls the sizing of exch
!                routine buffers.
      INTEGER MAX_OLX
      INTEGER MAX_OLY
      PARAMETER ( MAX_OLX = OLx, &
                 MAX_OLY = OLy )

