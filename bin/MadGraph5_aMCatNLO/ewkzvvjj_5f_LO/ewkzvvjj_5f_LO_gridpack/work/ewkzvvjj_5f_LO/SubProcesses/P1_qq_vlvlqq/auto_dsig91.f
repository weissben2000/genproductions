      DOUBLE PRECISION FUNCTION DSIG91(PP,WGT,IMODE)
C     ****************************************************
C     
C     Generated by MadGraph5_aMC@NLO v. 2.9.18, 2023-12-08
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     Process: u s > vt vt~ c d QCD=0 QED<=4 $ t t~ h @1
C     Process: c d > vt vt~ u s QCD=0 QED<=4 $ t t~ h @1
C     
C     RETURNS DIFFERENTIAL CROSS SECTION
C     Input:
C     pp    4 momentum of external particles
C     wgt   weight from Monte Carlo
C     imode 0 run, 1 init, 2 reweight, 
C     3 finalize, 4 only PDFs,
C     5 squared amplitude only (never
C     generate events)
C     Output:
C     Amplitude squared and summed
C     ****************************************************
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INCLUDE 'genps.inc'
      INCLUDE 'nexternal.inc'
      INCLUDE 'maxconfigs.inc'
      INCLUDE 'maxamps.inc'
      DOUBLE PRECISION       CONV
      PARAMETER (CONV=389379.66*1000)  !CONV TO PICOBARNS
      REAL*8     PI
      PARAMETER (PI=3.1415926D0)
C     
C     ARGUMENTS 
C     
      DOUBLE PRECISION PP(0:3,NEXTERNAL), WGT
      INTEGER IMODE
C     
C     LOCAL VARIABLES 
C     
      INTEGER I,ITYPE,LP,IPROC
      DOUBLE PRECISION U1,C1
      DOUBLE PRECISION D2,S2
      DOUBLE PRECISION XPQ(-7:7),PD(0:MAXPROC)
      DOUBLE PRECISION DSIGUU,R,RCONF
      INTEGER LUN,ICONF,IFACT,NFACT
      DATA NFACT/1/
      SAVE NFACT
C     
C     EXTERNAL FUNCTIONS
C     
      LOGICAL PASSCUTS
      DOUBLE PRECISION ALPHAS2,REWGT,PDG2PDF,CUSTOM_BIAS
      INTEGER NEXTUNOPEN
C     
C     GLOBAL VARIABLES
C     
      INTEGER          IPSEL
      COMMON /SUBPROC/ IPSEL
C     MINCFIG has this config number
      INTEGER           MINCFIG, MAXCFIG
      COMMON/TO_CONFIGS/MINCFIG, MAXCFIG
      INTEGER MAPCONFIG(0:LMAXCONFIGS), ICONFIG
      COMMON/TO_MCONFIGS/MAPCONFIG, ICONFIG
C     Keep track of whether cuts already calculated for this event
      LOGICAL CUTSDONE,CUTSPASSED
      COMMON/TO_CUTSDONE/CUTSDONE,CUTSPASSED

      INTEGER SUBDIAG(MAXSPROC),IB(2)
      COMMON/TO_SUB_DIAG/SUBDIAG,IB
      INCLUDE 'coupl.inc'
      INCLUDE 'run.inc'
C     
C     local
C     
      DOUBLE PRECISION P1(0:3, NEXTERNAL)

C     
C     DATA
C     
      DATA U1,C1/2*1D0/
      DATA D2,S2/2*1D0/
C     ----------
C     BEGIN CODE
C     ----------
      DSIG91=0D0

      IF(IMODE.EQ.1)THEN
C       Set up process information from file symfact
        LUN=NEXTUNOPEN()
        NFACT=1
        OPEN(UNIT=LUN,FILE='../symfact.dat',STATUS='OLD',ERR=20)
        DO WHILE(.TRUE.)
          READ(LUN,*,ERR=10,END=10) RCONF, IFACT
          ICONF=INT(RCONF)
          IF(ICONF.EQ.MAPCONFIG(MINCFIG))THEN
            NFACT=IFACT
          ENDIF
        ENDDO
 10     CLOSE(LUN)
        RETURN
 20     WRITE(*,*)'Error opening symfact.dat. No symmetry factor used.'
        RETURN
      ENDIF
C     Continue only if IMODE is 0, 4 or 5
      IF(IMODE.NE.0.AND.IMODE.NE.4.AND.IMODE.NE.5) RETURN


      IF (ABS(LPP(IB(1))).GE.1) THEN
        LP=SIGN(1,LPP(IB(1)))
        U1=PDG2PDF(ABS(LPP(IB(1))),2*LP, 1,XBK(IB(1)),DSQRT(Q2FACT(1)))
        C1=PDG2PDF(ABS(LPP(IB(1))),4*LP, 1,XBK(IB(1)),DSQRT(Q2FACT(1)))
      ENDIF
      IF (ABS(LPP(IB(2))).GE.1) THEN
        LP=SIGN(1,LPP(IB(2)))
        D2=PDG2PDF(ABS(LPP(IB(2))),1*LP, 1,XBK(IB(2)),DSQRT(Q2FACT(2)))
        S2=PDG2PDF(ABS(LPP(IB(2))),3*LP, 1,XBK(IB(2)),DSQRT(Q2FACT(2)))
      ENDIF
      PD(0) = 0D0
      IPROC = 0
      IPROC=IPROC+1  ! u s > vt vt~ c d
      PD(IPROC)=U1*S2
      PD(0)=PD(0)+DABS(PD(IPROC))
      IPROC=IPROC+1  ! c d > vt vt~ u s
      PD(IPROC)=C1*D2
      PD(0)=PD(0)+DABS(PD(IPROC))
      IF (IMODE.EQ.4)THEN
        DSIG91 = PD(0)
        RETURN
      ENDIF
      IF(FRAME_ID.NE.6)THEN
        CALL BOOST_TO_FRAME(PP, FRAME_ID, P1)
      ELSE
        P1 = PP
      ENDIF
      CALL SMATRIX91(P1,DSIGUU)
      IF (IMODE.EQ.5) THEN
        IF (DSIGUU.LT.1D199) THEN
          DSIG91 = DSIGUU*CONV
        ELSE
          DSIG91 = 0.0D0
        ENDIF
        RETURN
      ENDIF
C     Select a flavor combination (need to do here for right sign)
      CALL RANMAR(R)
      IPSEL=0
      DO WHILE (R.GE.0D0 .AND. IPSEL.LT.IPROC)
        IPSEL=IPSEL+1
        R=R-DABS(PD(IPSEL))/PD(0)
      ENDDO

      DSIGUU=DSIGUU*REWGT(PP)

C     Apply the bias weight specified in the run card (default is 1.0)
      DSIGUU=DSIGUU*CUSTOM_BIAS(PP,DSIGUU,91)

      DSIGUU=DSIGUU*NFACT

      IF (DSIGUU.LT.1D199) THEN
C       Set sign of dsig based on sign of PDF and matrix element
        DSIG91=DSIGN(PD(0)*CONV*DSIGUU,DSIGUU*PD(IPSEL))
      ELSE
        WRITE(*,*) 'Error in matrix element'
        DSIGUU=0D0
        DSIG91=0D0
      ENDIF
C     Generate events only if IMODE is 0.
      IF(IMODE.EQ.0.AND.DABS(DSIG91).GT.0D0)THEN
C       Call UNWGT to unweight and store events
        CALL UNWGT(PP,DSIG91*WGT,91)
      ENDIF

      END
C     
C     Functionality to handling grid
C     




      SUBROUTINE PRINT_ZERO_AMP91()

      RETURN
      END
