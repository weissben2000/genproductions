      SUBROUTINE SMATRIX166(P,ANS)
C     
C     Generated by MadGraph5_aMC@NLO v. 2.9.18, 2023-12-08
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     MadGraph5_aMC@NLO for Madevent Version
C     
C     Returns amplitude squared -- no average over initial
C      state/symmetry factor
C     and helicities
C     for the point in phase space P(0:3,NEXTERNAL)
C     
C     Process: u c~ > e+ ve d u~ QCD=0 $ t t~ h @1
C     Process: u c~ > mu+ vm d u~ QCD=0 $ t t~ h @1
C     
      USE DISCRETESAMPLER
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INCLUDE 'genps.inc'
      INCLUDE 'maxconfigs.inc'
      INCLUDE 'nexternal.inc'
      INCLUDE 'maxamps.inc'
      INTEGER                 NCOMB
      PARAMETER (             NCOMB=64)
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=6)
      INTEGER    NDIAGS
      PARAMETER (NDIAGS=6)
      INTEGER    THEL
      PARAMETER (THEL=2*NCOMB)
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL),ANS
C     
C     global (due to reading writting) 
C     
      LOGICAL GOODHEL(NCOMB,2)
      INTEGER NTRY(2)
      COMMON/BLOCK_GOODHEL/NTRY,GOODHEL

C     
C     LOCAL VARIABLES 
C     
      INTEGER CONFSUB(MAXSPROC,LMAXCONFIGS)
      INCLUDE 'config_subproc_map.inc'
      INTEGER NHEL(NEXTERNAL,NCOMB)
      INTEGER ISHEL(2)
      REAL*8 T,MATRIX166
      REAL*8 R,SUMHEL,TS(NCOMB)
      INTEGER I,IDEN
      INTEGER JC(NEXTERNAL),II
      REAL*8 HWGT, XTOT, XTRY, XREJ, XR, YFRAC(0:NCOMB)
      INTEGER NGOOD(2), IGOOD(NCOMB,2)
      INTEGER JHEL(2), J, JJ
      INTEGER THIS_NTRY(2)
      SAVE THIS_NTRY
      INTEGER NB_FAIL
      SAVE NB_FAIL
      DATA THIS_NTRY /0,0/
      DATA NB_FAIL /0/
      DOUBLE PRECISION GET_CHANNEL_CUT
      EXTERNAL GET_CHANNEL_CUT

C     
C     This is just to temporarily store the reference grid for
C      helicity of the DiscreteSampler so as to obtain its number of
C      entries with ref_helicity_grid%n_tot_entries
      TYPE(SAMPLEDDIMENSION) REF_HELICITY_GRID
C     
C     GLOBAL VARIABLES
C     
      LOGICAL INIT_MODE
      COMMON /TO_DETERMINE_ZERO_HEL/INIT_MODE
      DOUBLE PRECISION AMP2(MAXAMPS), JAMP2(0:MAXFLOW)
      COMMON/TO_AMPS/  AMP2,       JAMP2

      CHARACTER*101         HEL_BUFF
      COMMON/TO_HELICITY/  HEL_BUFF

      INTEGER NB_SPIN_STATE_IN(2)
      COMMON /NB_HEL_STATE/ NB_SPIN_STATE_IN

      INTEGER IMIRROR,IPROC
      COMMON/TO_MIRROR/ IMIRROR,IPROC

      DOUBLE PRECISION TMIN_FOR_CHANNEL
      INTEGER SDE_STRAT  ! 1 means standard single diagram enhancement strategy,
C     2 means approximation by the	denominator of the propagator
      COMMON/TO_CHANNEL_STRAT/TMIN_FOR_CHANNEL,	SDE_STRAT

      REAL*8 POL(2)
      COMMON/TO_POLARIZATION/ POL

      DOUBLE PRECISION SMALL_WIDTH_TREATMENT
      COMMON/NARROW_WIDTH/SMALL_WIDTH_TREATMENT

      INTEGER          ISUM_HEL
      LOGICAL                    MULTI_CHANNEL
      COMMON/TO_MATRIX/ISUM_HEL, MULTI_CHANNEL
      INTEGER MAPCONFIG(0:LMAXCONFIGS), ICONFIG
      COMMON/TO_MCONFIGS/MAPCONFIG, ICONFIG
      INTEGER SUBDIAG(MAXSPROC),IB(2)
      COMMON/TO_SUB_DIAG/SUBDIAG,IB
      DATA XTRY, XREJ /0,0/
      DATA NGOOD /0,0/
      DATA ISHEL/0,0/
      SAVE YFRAC, IGOOD, JHEL
      DATA (NHEL(I,   1),I=1,6) / 1,-1, 1,-1,-1, 1/
      DATA (NHEL(I,   2),I=1,6) / 1,-1, 1,-1,-1,-1/
      DATA (NHEL(I,   3),I=1,6) / 1,-1, 1,-1, 1, 1/
      DATA (NHEL(I,   4),I=1,6) / 1,-1, 1,-1, 1,-1/
      DATA (NHEL(I,   5),I=1,6) / 1,-1, 1, 1,-1, 1/
      DATA (NHEL(I,   6),I=1,6) / 1,-1, 1, 1,-1,-1/
      DATA (NHEL(I,   7),I=1,6) / 1,-1, 1, 1, 1, 1/
      DATA (NHEL(I,   8),I=1,6) / 1,-1, 1, 1, 1,-1/
      DATA (NHEL(I,   9),I=1,6) / 1,-1,-1,-1,-1, 1/
      DATA (NHEL(I,  10),I=1,6) / 1,-1,-1,-1,-1,-1/
      DATA (NHEL(I,  11),I=1,6) / 1,-1,-1,-1, 1, 1/
      DATA (NHEL(I,  12),I=1,6) / 1,-1,-1,-1, 1,-1/
      DATA (NHEL(I,  13),I=1,6) / 1,-1,-1, 1,-1, 1/
      DATA (NHEL(I,  14),I=1,6) / 1,-1,-1, 1,-1,-1/
      DATA (NHEL(I,  15),I=1,6) / 1,-1,-1, 1, 1, 1/
      DATA (NHEL(I,  16),I=1,6) / 1,-1,-1, 1, 1,-1/
      DATA (NHEL(I,  17),I=1,6) / 1, 1, 1,-1,-1, 1/
      DATA (NHEL(I,  18),I=1,6) / 1, 1, 1,-1,-1,-1/
      DATA (NHEL(I,  19),I=1,6) / 1, 1, 1,-1, 1, 1/
      DATA (NHEL(I,  20),I=1,6) / 1, 1, 1,-1, 1,-1/
      DATA (NHEL(I,  21),I=1,6) / 1, 1, 1, 1,-1, 1/
      DATA (NHEL(I,  22),I=1,6) / 1, 1, 1, 1,-1,-1/
      DATA (NHEL(I,  23),I=1,6) / 1, 1, 1, 1, 1, 1/
      DATA (NHEL(I,  24),I=1,6) / 1, 1, 1, 1, 1,-1/
      DATA (NHEL(I,  25),I=1,6) / 1, 1,-1,-1,-1, 1/
      DATA (NHEL(I,  26),I=1,6) / 1, 1,-1,-1,-1,-1/
      DATA (NHEL(I,  27),I=1,6) / 1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,  28),I=1,6) / 1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,  29),I=1,6) / 1, 1,-1, 1,-1, 1/
      DATA (NHEL(I,  30),I=1,6) / 1, 1,-1, 1,-1,-1/
      DATA (NHEL(I,  31),I=1,6) / 1, 1,-1, 1, 1, 1/
      DATA (NHEL(I,  32),I=1,6) / 1, 1,-1, 1, 1,-1/
      DATA (NHEL(I,  33),I=1,6) /-1,-1, 1,-1,-1, 1/
      DATA (NHEL(I,  34),I=1,6) /-1,-1, 1,-1,-1,-1/
      DATA (NHEL(I,  35),I=1,6) /-1,-1, 1,-1, 1, 1/
      DATA (NHEL(I,  36),I=1,6) /-1,-1, 1,-1, 1,-1/
      DATA (NHEL(I,  37),I=1,6) /-1,-1, 1, 1,-1, 1/
      DATA (NHEL(I,  38),I=1,6) /-1,-1, 1, 1,-1,-1/
      DATA (NHEL(I,  39),I=1,6) /-1,-1, 1, 1, 1, 1/
      DATA (NHEL(I,  40),I=1,6) /-1,-1, 1, 1, 1,-1/
      DATA (NHEL(I,  41),I=1,6) /-1,-1,-1,-1,-1, 1/
      DATA (NHEL(I,  42),I=1,6) /-1,-1,-1,-1,-1,-1/
      DATA (NHEL(I,  43),I=1,6) /-1,-1,-1,-1, 1, 1/
      DATA (NHEL(I,  44),I=1,6) /-1,-1,-1,-1, 1,-1/
      DATA (NHEL(I,  45),I=1,6) /-1,-1,-1, 1,-1, 1/
      DATA (NHEL(I,  46),I=1,6) /-1,-1,-1, 1,-1,-1/
      DATA (NHEL(I,  47),I=1,6) /-1,-1,-1, 1, 1, 1/
      DATA (NHEL(I,  48),I=1,6) /-1,-1,-1, 1, 1,-1/
      DATA (NHEL(I,  49),I=1,6) /-1, 1, 1,-1,-1, 1/
      DATA (NHEL(I,  50),I=1,6) /-1, 1, 1,-1,-1,-1/
      DATA (NHEL(I,  51),I=1,6) /-1, 1, 1,-1, 1, 1/
      DATA (NHEL(I,  52),I=1,6) /-1, 1, 1,-1, 1,-1/
      DATA (NHEL(I,  53),I=1,6) /-1, 1, 1, 1,-1, 1/
      DATA (NHEL(I,  54),I=1,6) /-1, 1, 1, 1,-1,-1/
      DATA (NHEL(I,  55),I=1,6) /-1, 1, 1, 1, 1, 1/
      DATA (NHEL(I,  56),I=1,6) /-1, 1, 1, 1, 1,-1/
      DATA (NHEL(I,  57),I=1,6) /-1, 1,-1,-1,-1, 1/
      DATA (NHEL(I,  58),I=1,6) /-1, 1,-1,-1,-1,-1/
      DATA (NHEL(I,  59),I=1,6) /-1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,  60),I=1,6) /-1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,  61),I=1,6) /-1, 1,-1, 1,-1, 1/
      DATA (NHEL(I,  62),I=1,6) /-1, 1,-1, 1,-1,-1/
      DATA (NHEL(I,  63),I=1,6) /-1, 1,-1, 1, 1, 1/
      DATA (NHEL(I,  64),I=1,6) /-1, 1,-1, 1, 1,-1/
      DATA IDEN/36/

C     To be able to control when the matrix<i> subroutine can add
C      entries to the grid for the MC over helicity configuration
      LOGICAL ALLOW_HELICITY_GRID_ENTRIES
      COMMON/TO_ALLOW_HELICITY_GRID_ENTRIES/ALLOW_HELICITY_GRID_ENTRIES

C     ----------
C     BEGIN CODE
C     ----------

      NTRY(IMIRROR)=NTRY(IMIRROR)+1
      THIS_NTRY(IMIRROR) = THIS_NTRY(IMIRROR)+1
      DO I=1,NEXTERNAL
        JC(I) = +1
      ENDDO

      IF (MULTI_CHANNEL) THEN
        DO I=1,NDIAGS
          AMP2(I)=0D0
        ENDDO
        JAMP2(0)=2
        DO I=1,INT(JAMP2(0))
          JAMP2(I)=0D0
        ENDDO
      ENDIF
      ANS = 0D0
      WRITE(HEL_BUFF,'(20I5)') (0,I=1,NEXTERNAL)
      DO I=1,NCOMB
        TS(I)=0D0
      ENDDO

        !   If the helicity grid status is 0, this means that it is not yet initialized.
        !   If HEL_PICKED==-1, this means that calls to other matrix<i> where in initialization mode as well for the helicity.
      IF ((ISHEL(IMIRROR).EQ.0.AND.ISUM_HEL.EQ.0)
     $ .OR.(DS_GET_DIM_STATUS('Helicity').EQ.0).OR.(HEL_PICKED.EQ.-1))
     $  THEN
        DO I=1,NCOMB
          IF (GOODHEL(I,IMIRROR) .OR. NTRY(IMIRROR)
     $     .LE.MAXTRIES.OR.(ISUM_HEL.NE.0).OR.THIS_NTRY(IMIRROR).LE.10)
     $      THEN
            T=MATRIX166(P ,NHEL(1,I),JC(1),I)
            DO JJ=1,NINCOMING
              IF(POL(JJ).NE.1D0.AND.NHEL(JJ,I).EQ.INT(SIGN(1D0,POL(JJ))
     $         )) THEN
                T=T*ABS(POL(JJ))*NB_SPIN_STATE_IN(JJ)/2D0  ! NB_SPIN_STATE(JJ)/2d0 is added for polarised beam
              ELSE IF(POL(JJ).NE.1D0)THEN
                T=T*(2D0-ABS(POL(JJ)))*NB_SPIN_STATE_IN(JJ)/2D0
              ENDIF
            ENDDO
            IF (ISUM_HEL.NE.0.AND.DS_GET_DIM_STATUS('Helicity')
     $       .EQ.0.AND.ALLOW_HELICITY_GRID_ENTRIES) THEN
              CALL DS_ADD_ENTRY('Helicity',I,T)
            ENDIF
            ANS=ANS+DABS(T)
            TS(I)=T
          ENDIF
        ENDDO
        IF(NTRY(IMIRROR).EQ.(MAXTRIES+1)) THEN
          CALL RESET_CUMULATIVE_VARIABLE()  ! avoid biais of the initialization
        ENDIF
        IF (ISUM_HEL.NE.0) THEN
            !         We set HEL_PICKED to -1 here so that later on, the call to DS_add_point in dsample.f does not add anything to the grid since it was already done here.
          HEL_PICKED = -1
            !         For safety, hardset the helicity sampling jacobian to 0.0d0 to make sure it is not .
          HEL_JACOBIAN   = 1.0D0
            !         We don't want to re-update the helicity grid if it was already updated by another matrix<i>, so we make sure that the reference grid is empty.
          REF_HELICITY_GRID = DS_GET_DIMENSION(REF_GRID,'Helicity')
          IF((DS_GET_DIM_STATUS('Helicity').EQ.1)
     $     .AND.(REF_HELICITY_GRID%N_TOT_ENTRIES.EQ.0)) THEN
              !           If we finished the initialization we can update the grid so as to start sampling over it.
              !           However the grid will now be filled by dsample with different kind of weights (including pdf, flux, etc...) so by setting the grid_mode of the reference grid to 'initialization' we make sure it will be overwritten (as opposed to 'combined') by the running grid at the next update.
            CALL DS_UPDATE_GRID('Helicity')
            CALL DS_SET_GRID_MODE('Helicity','init')
          ENDIF
        ELSE
          JHEL(IMIRROR) = 1
          IF(NTRY(IMIRROR).LE.MAXTRIES.OR.THIS_NTRY(IMIRROR).LE.10)THEN
            DO I=1,NCOMB
              IF(INIT_MODE) THEN
                IF (DABS(TS(I)).GT.ANS*LIMHEL/NCOMB) THEN
                  PRINT *, 'Matrix Element/Good Helicity: 166 ', I,
     $              'IMIRROR', IMIRROR
                ENDIF
              ELSE IF (.NOT.GOODHEL(I,IMIRROR) .AND. (DABS(TS(I))
     $         .GT.ANS*LIMHEL/NCOMB)) THEN
                GOODHEL(I,IMIRROR)=.TRUE.
                NGOOD(IMIRROR) = NGOOD(IMIRROR) +1
                IGOOD(NGOOD(IMIRROR),IMIRROR) = I
                PRINT *,'Added good helicity ',I,TS(I)*NCOMB/ANS,' in'
     $           //' event ',NTRY(IMIRROR), 'local:',THIS_NTRY(IMIRROR)
              ENDIF
            ENDDO
          ENDIF
          IF(NTRY(IMIRROR).EQ.MAXTRIES)THEN
            ISHEL(IMIRROR)=MIN(ISUM_HEL,NGOOD(IMIRROR))
          ENDIF
        ENDIF
      ELSE IF (.NOT.INIT_MODE) THEN  ! random helicity 
C       The helicity configuration was chosen already by genps and put
C        in a common block defined in genps.inc.
        I = HEL_PICKED

        T=MATRIX166(P ,NHEL(1,I),JC(1),I)

        DO JJ=1,NINCOMING
          IF(POL(JJ).NE.1D0.AND.NHEL(JJ,I).EQ.INT(SIGN(1D0,POL(JJ))))
     $      THEN
            T=T*ABS(POL(JJ))
          ELSE IF(POL(JJ).NE.1D0)THEN
            T=T*(2D0-ABS(POL(JJ)))
          ENDIF
        ENDDO
C       Always one helicity at a time
        ANS = T
C       Include the Jacobian from helicity sampling
        ANS = ANS * HEL_JACOBIAN

        WRITE(HEL_BUFF,'(20i5)')(NHEL(II,I),II=1,NEXTERNAL)
      ELSE
        ANS = 1D0
        RETURN
      ENDIF
      IF (ANS.NE.0D0.AND.(ISUM_HEL .NE. 1.OR.HEL_PICKED.EQ.-1)) THEN
        CALL RANMAR(R)
        SUMHEL=0D0
        DO I=1,NCOMB
          SUMHEL=SUMHEL+DABS(TS(I))/ANS
          IF(R.LT.SUMHEL)THEN
            WRITE(HEL_BUFF,'(20i5)')(NHEL(II,I),II=1,NEXTERNAL)
C           Set right sign for ANS, based on sign of chosen helicity
            ANS=DSIGN(ANS,TS(I))
            GOTO 10
          ENDIF
        ENDDO
 10     CONTINUE
      ENDIF
      IF (MULTI_CHANNEL) THEN
        XTOT=0D0
        DO I=1,LMAXCONFIGS
          J = CONFSUB(166, I)
          IF (J.NE.0) THEN
            IF(SDE_STRAT.EQ.1) THEN
              AMP2(J) = AMP2(J) * GET_CHANNEL_CUT(P, I)
              XTOT=XTOT+AMP2(J)
            ELSE
              AMP2(J) = GET_CHANNEL_CUT(P, I)
              XTOT=XTOT+AMP2(J)
            ENDIF
          ENDIF
        ENDDO
        IF (XTOT.NE.0D0) THEN
          ANS=ANS*AMP2(SUBDIAG(166))/XTOT
        ELSE IF(ANS.NE.0D0) THEN
          IF(NB_FAIL.GE.10)THEN
            WRITE(*,*) 'Problem in the multi-channeling. All amp2 are'
     $       //' zero but not the total matrix-element'

            STOP 1
          ELSE
            NB_FAIL = NB_FAIL +1
          ENDIF
        ENDIF
      ENDIF
      ANS=ANS/DBLE(IDEN)
      END


      REAL*8 FUNCTION MATRIX166(P,NHEL,IC, IHEL)
C     
C     Generated by MadGraph5_aMC@NLO v. 2.9.18, 2023-12-08
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     Returns amplitude squared summed/avg over colors
C     for the point with external lines W(0:6,NEXTERNAL)
C     
C     Process: u c~ > e+ ve d u~ QCD=0 $ t t~ h @1
C     Process: u c~ > mu+ vm d u~ QCD=0 $ t t~ h @1
C     
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=6)
      INTEGER                 NCOMB
      PARAMETER (             NCOMB=64)
      INCLUDE 'genps.inc'
      INCLUDE 'nexternal.inc'
      INCLUDE 'maxamps.inc'
      INTEGER    NWAVEFUNCS,     NCOLOR
      PARAMETER (NWAVEFUNCS=8, NCOLOR=2)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
      COMPLEX*16 IMAG1
      PARAMETER (IMAG1=(0D0,1D0))
      INTEGER NAMPSO, NSQAMPSO
      PARAMETER (NAMPSO=1, NSQAMPSO=1)
      LOGICAL CHOSEN_SO_CONFIGS(NSQAMPSO)
      DATA CHOSEN_SO_CONFIGS/.TRUE./
      SAVE CHOSEN_SO_CONFIGS
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL)
      INTEGER NHEL(NEXTERNAL), IC(NEXTERNAL)
      INTEGER IHEL
C     
C     LOCAL VARIABLES 
C     
      INTEGER I,J,M,N
      COMPLEX*16 ZTEMP, TMP_JAMP(0)
      REAL*8 CF(NCOLOR,NCOLOR)
      COMPLEX*16 AMP(NGRAPHS), JAMP(NCOLOR,NAMPSO)
      COMPLEX*16 W(6,NWAVEFUNCS)
C     Needed for v4 models
      COMPLEX*16 DUM0,DUM1
      DATA DUM0, DUM1/(0D0, 0D0), (1D0, 0D0)/

      DOUBLE PRECISION FK_ZERO
      DOUBLE PRECISION FK_MDL_WW
      SAVE FK_ZERO
      SAVE FK_MDL_WW

      LOGICAL FIRST
      DATA FIRST /.TRUE./
      SAVE FIRST
C     
C     FUNCTION
C     
      INTEGER SQSOINDEX166
C     
C     GLOBAL VARIABLES
C     
      DOUBLE PRECISION AMP2(MAXAMPS), JAMP2(0:MAXFLOW)
      COMMON/TO_AMPS/  AMP2,       JAMP2
      INCLUDE 'coupl.inc'

      DOUBLE PRECISION SMALL_WIDTH_TREATMENT
      COMMON/NARROW_WIDTH/SMALL_WIDTH_TREATMENT

      LOGICAL INIT_MODE
      COMMON/TO_DETERMINE_ZERO_HEL/INIT_MODE

      LOGICAL ZEROAMP_166(NCOMB,NGRAPHS)
      COMMON/TO_ZEROAMP_166/ZEROAMP_166

      DOUBLE PRECISION TMIN_FOR_CHANNEL
      INTEGER SDE_STRAT  ! 1 means standard single diagram enhancement strategy,
C     2 means approximation by the	denominator of the propagator
      COMMON/TO_CHANNEL_STRAT/TMIN_FOR_CHANNEL,	SDE_STRAT

C     
C     COLOR DATA
C     
      DATA (CF(I,  1),I=  1,  2) /9.000000000000000D+00
     $ ,3.000000000000000D+00/
C     1 T(2,1) T(5,6)
      DATA (CF(I,  2),I=  1,  2) /3.000000000000000D+00
     $ ,9.000000000000000D+00/
C     1 T(2,6) T(5,1)
C     ----------
C     BEGIN CODE
C     ----------
      IF (FIRST) THEN
        FIRST=.FALSE.
        IF(ZERO.NE.0D0) FK_ZERO = SIGN(MAX(ABS(ZERO), ABS(ZERO
     $   *SMALL_WIDTH_TREATMENT)), ZERO)
        IF(MDL_WW.NE.0D0) FK_MDL_WW = SIGN(MAX(ABS(MDL_WW), ABS(MDL_MW
     $   *SMALL_WIDTH_TREATMENT)), MDL_WW)

        IF(INIT_MODE) THEN
          ZEROAMP_166(:,:) = .TRUE.
        ENDIF
      ENDIF


      CALL IXXXXX(P(0,1),ZERO,NHEL(1),+1*IC(1),W(1,1))
      CALL OXXXXX(P(0,2),ZERO,NHEL(2),-1*IC(2),W(1,2))
      CALL IXXXXX(P(0,3),ZERO,NHEL(3),-1*IC(3),W(1,3))
      CALL OXXXXX(P(0,4),ZERO,NHEL(4),+1*IC(4),W(1,4))
      CALL OXXXXX(P(0,5),ZERO,NHEL(5),+1*IC(5),W(1,5))
      CALL IXXXXX(P(0,6),ZERO,NHEL(6),-1*IC(6),W(1,6))
      CALL FFV2_3(W(1,1),W(1,5),GC_100,MDL_MW, ZERO,W(1,7))
      CALL FFV2_3(W(1,3),W(1,4),GC_108,MDL_MW, FK_MDL_WW,W(1,8))
      CALL FFV2_1(W(1,2),W(1,7),-GC_101,ZERO, FK_ZERO,W(1,4))
C     Amplitude(s) for diagram number 1
      CALL FFV2_0(W(1,6),W(1,4),W(1,8),GC_100,AMP(1))
      CALL FFV2_1(W(1,2),W(1,7),GC_100,ZERO, FK_ZERO,W(1,4))
C     Amplitude(s) for diagram number 2
      CALL FFV2_0(W(1,6),W(1,4),W(1,8),GC_101,AMP(2))
      CALL FFV2_1(W(1,2),W(1,7),GC_105,ZERO, FK_ZERO,W(1,4))
C     Amplitude(s) for diagram number 3
      CALL FFV2_0(W(1,6),W(1,4),W(1,8),GC_102,AMP(3))
      CALL FFV2_3(W(1,6),W(1,5),GC_100,MDL_MW, FK_MDL_WW,W(1,4))
      CALL FFV2_2(W(1,1),W(1,8),GC_100,ZERO, FK_ZERO,W(1,6))
C     Amplitude(s) for diagram number 4
      CALL FFV2_0(W(1,6),W(1,2),W(1,4),-GC_101,AMP(4))
      CALL FFV2_2(W(1,1),W(1,8),GC_101,ZERO, FK_ZERO,W(1,6))
C     Amplitude(s) for diagram number 5
      CALL FFV2_0(W(1,6),W(1,2),W(1,4),GC_100,AMP(5))
      CALL FFV2_2(W(1,1),W(1,8),GC_102,ZERO, FK_ZERO,W(1,6))
C     Amplitude(s) for diagram number 6
      CALL FFV2_0(W(1,6),W(1,2),W(1,4),GC_105,AMP(6))

      JAMP(:,:) = (0D0,0D0)
C     JAMPs contributing to orders ALL_ORDERS=1
      JAMP(1,1) = (-1.000000000000000D+00)*AMP(4)+(-1.000000000000000D
     $ +00)*AMP(5)+(-1.000000000000000D+00)*AMP(6)
      JAMP(2,1) = AMP(1)+AMP(2)+AMP(3)

      IF(INIT_MODE)THEN
        DO I=1, NGRAPHS
          IF (AMP(I).NE.0) THEN
            ZEROAMP_166(IHEL,I) = .FALSE.
          ENDIF
        ENDDO
      ENDIF

      MATRIX166 = 0.D0
      DO M = 1, NAMPSO
        DO I = 1, NCOLOR
          ZTEMP = (0.D0,0.D0)
          DO J = 1, NCOLOR
            ZTEMP = ZTEMP + CF(J,I)*JAMP(J,M)
          ENDDO
          DO N = 1, NAMPSO

            MATRIX166 = MATRIX166 + ZTEMP*DCONJG(JAMP(I,N))

          ENDDO
        ENDDO
      ENDDO

      IF(SDE_STRAT.EQ.1)THEN
        AMP2(1)=AMP2(1)+(AMP(1)+AMP(2)+AMP(3))*DCONJG(AMP(1)+AMP(2)
     $   +AMP(3))
        AMP2(4)=AMP2(4)+(AMP(4)+AMP(5)+AMP(6))*DCONJG(AMP(4)+AMP(5)
     $   +AMP(6))
      ENDIF

      DO I = 1, NCOLOR
        DO M = 1, NAMPSO
          DO N = 1, NAMPSO

            JAMP2(I)=JAMP2(I)+DABS(DBLE(JAMP(I,M)*DCONJG(JAMP(I,N))))

          ENDDO
        ENDDO
      ENDDO

      END

      SUBROUTINE PRINT_ZERO_AMP_166()

      IMPLICIT NONE
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=6)

      INTEGER    NCOMB
      PARAMETER (NCOMB=64)

      LOGICAL ZEROAMP_166(NCOMB, NGRAPHS)
      COMMON/TO_ZEROAMP_166/ZEROAMP_166

      INTEGER I,J
      LOGICAL ALL_FALSE

      DO I=1, NGRAPHS
        ALL_FALSE = .TRUE.
        DO J=1,NCOMB
          IF (.NOT.ZEROAMP_166(J, I)) THEN
            ALL_FALSE = .FALSE.
            EXIT
          ENDIF
        ENDDO
        IF (ALL_FALSE) THEN
          WRITE(*,*) 'Amplitude/ZEROAMP:', 166, I
        ELSE
          DO J=1,NCOMB
            IF (ZEROAMP_166(J, I)) THEN
              WRITE(*,*) 'HEL/ZEROAMP:', 166, J  , I
            ENDIF
          ENDDO
        ENDIF
      ENDDO

      RETURN
      END
C     Set of functions to handle the array indices of the split orders


      INTEGER FUNCTION SQSOINDEX166(ORDERINDEXA, ORDERINDEXB)
C     
C     This functions plays the role of the interference matrix. It can
C      be hardcoded or 
C     made more elegant using hashtables if its execution speed ever
C      becomes a relevant
C     factor. From two split order indices, it return the
C      corresponding index in the squared 
C     order canonical ordering.
C     
C     CONSTANTS
C     

      INTEGER    NSO, NSQUAREDSO, NAMPSO
      PARAMETER (NSO=1, NSQUAREDSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERINDEXA, ORDERINDEXB
C     
C     LOCAL VARIABLES
C     
      INTEGER I, SQORDERS(NSO)
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      DATA (AMPSPLITORDERS(  1,I),I=  1,  1) /    1/
      COMMON/AMPSPLITORDERS166/AMPSPLITORDERS
C     
C     FUNCTION
C     
      INTEGER SOINDEX_FOR_SQUARED_ORDERS166
C     
C     BEGIN CODE
C     
      DO I=1,NSO
        SQORDERS(I)=AMPSPLITORDERS(ORDERINDEXA,I)
     $   +AMPSPLITORDERS(ORDERINDEXB,I)
      ENDDO
      SQSOINDEX166=SOINDEX_FOR_SQUARED_ORDERS166(SQORDERS)
      END

      INTEGER FUNCTION SOINDEX_FOR_SQUARED_ORDERS166(ORDERS)
C     
C     This functions returns the integer index identifying the squared
C      split orders list passed in argument which corresponds to the
C      values of the following list of couplings (and in this order).
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NSQSO, NAMPSO
      PARAMETER (NSO=1, NSQSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I,J
      INTEGER SQSPLITORDERS(NSQSO,NSO)
      DATA (SQSPLITORDERS(  1,I),I=  1,  1) /    2/
      COMMON/SQPLITORDERS166/SQPLITORDERS
C     
C     BEGIN CODE
C     
      DO I=1,NSQSO
        DO J=1,NSO
          IF (ORDERS(J).NE.SQSPLITORDERS(I,J)) GOTO 1009
        ENDDO
        SOINDEX_FOR_SQUARED_ORDERS166 = I
        RETURN
 1009   CONTINUE
      ENDDO

      WRITE(*,*) 'ERROR:: Stopping in function'
      WRITE(*,*) 'SOINDEX_FOR_SQUARED_ORDERS166'
      WRITE(*,*) 'Could not find squared orders ',(ORDERS(I),I=1,NSO)
      STOP

      END

      SUBROUTINE GET_NSQSO_BORN166(NSQSO)
C     
C     Simple subroutine returning the number of squared split order
C     contributions returned when calling smatrix_split_orders 
C     

      INTEGER    NSQUAREDSO
      PARAMETER  (NSQUAREDSO=1)

      INTEGER NSQSO

      NSQSO=NSQUAREDSO

      END

C     This is the inverse subroutine of SOINDEX_FOR_SQUARED_ORDERS.
C      Not directly useful, but provided nonetheless.
      SUBROUTINE GET_SQUARED_ORDERS_FOR_SOINDEX166(SOINDEX,ORDERS)
C     
C     This functions returns the orders identified by the squared
C      split order index in argument. Order values correspond to
C      following list of couplings (and in this order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NSQSO
      PARAMETER (NSO=1, NSQSO=1)
C     
C     ARGUMENTS
C     
      INTEGER SOINDEX, ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I
      INTEGER SQPLITORDERS(NSQSO,NSO)
      COMMON/SQPLITORDERS166/SQPLITORDERS
C     
C     BEGIN CODE
C     
      IF (SOINDEX.GT.0.AND.SOINDEX.LE.NSQSO) THEN
        DO I=1,NSO
          ORDERS(I) =  SQPLITORDERS(SOINDEX,I)
        ENDDO
        RETURN
      ENDIF

      WRITE(*,*) 'ERROR:: Stopping function'
     $ //' GET_SQUARED_ORDERS_FOR_SOINDEX166'
      WRITE(*,*) 'Could not find squared orders index ',SOINDEX
      STOP

      END SUBROUTINE

C     This is the inverse subroutine of getting amplitude SO orders.
C      Not directly useful, but provided nonetheless.
      SUBROUTINE GET_ORDERS_FOR_AMPSOINDEX166(SOINDEX,ORDERS)
C     
C     This functions returns the orders identified by the split order
C      index in argument. Order values correspond to following list of
C      couplings (and in this order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NAMPSO
      PARAMETER (NSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER SOINDEX, ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      COMMON/AMPSPLITORDERS166/AMPSPLITORDERS
C     
C     BEGIN CODE
C     
      IF (SOINDEX.GT.0.AND.SOINDEX.LE.NAMPSO) THEN
        DO I=1,NSO
          ORDERS(I) =  AMPSPLITORDERS(SOINDEX,I)
        ENDDO
        RETURN
      ENDIF

      WRITE(*,*) 'ERROR:: Stopping function'
     $ //' GET_ORDERS_FOR_AMPSOINDEX166'
      WRITE(*,*) 'Could not find amplitude split orders index ',SOINDEX
      STOP

      END SUBROUTINE

C     This function is not directly useful, but included for
C      completeness
      INTEGER FUNCTION SOINDEX_FOR_AMPORDERS166(ORDERS)
C     
C     This functions returns the integer index identifying the
C      amplitude split orders passed in argument which correspond to
C      the values of the following list of couplings (and in this
C      order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NAMPSO
      PARAMETER (NSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I,J
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      COMMON/AMPSPLITORDERS166/AMPSPLITORDERS
C     
C     BEGIN CODE
C     
      DO I=1,NAMPSO
        DO J=1,NSO
          IF (ORDERS(J).NE.AMPSPLITORDERS(I,J)) GOTO 1009
        ENDDO
        SOINDEX_FOR_AMPORDERS166 = I
        RETURN
 1009   CONTINUE
      ENDDO

      WRITE(*,*) 'ERROR:: Stopping function SOINDEX_FOR_AMPORDERS166'
      WRITE(*,*) 'Could not find squared orders ',(ORDERS(I),I=1,NSO)
      STOP

      END

