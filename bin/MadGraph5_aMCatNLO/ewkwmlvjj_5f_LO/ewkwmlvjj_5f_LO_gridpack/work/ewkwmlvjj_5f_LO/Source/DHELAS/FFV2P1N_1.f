C     This File is Automatically generated by ALOHA 
C     The process calculated in this file is: 
C     Gamma(3,2,-1)*ProjM(-1,1)
C     
      SUBROUTINE FFV2P1N_1(F2, V3, COUP,F1)
      IMPLICIT NONE
      COMPLEX*16 CI
      PARAMETER (CI=(0D0,1D0))
      COMPLEX*16 COUP
      COMPLEX*16 F1(6)
      COMPLEX*16 F2(*)
      COMPLEX*16 V3(*)
      F1(3)= COUP*(-CI)*(F2(5)*(V3(3)+V3(6))+F2(6)*(V3(4)+CI*(V3(5))))
      F1(4)= COUP*CI*(F2(5)*(-V3(4)+CI*(V3(5)))+F2(6)*(-V3(3)+V3(6)))
      F1(5)= COUP*0D0
      F1(6)= COUP*0D0
      END


C     This File is Automatically generated by ALOHA 
C     The process calculated in this file is: 
C     Gamma(3,2,-1)*ProjM(-1,1)
C     
      SUBROUTINE FFV2_4P1N_1(F2, V3, COUP1, COUP2,F1)
      IMPLICIT NONE
      COMPLEX*16 CI
      PARAMETER (CI=(0D0,1D0))
      COMPLEX*16 COUP1
      COMPLEX*16 COUP2
      COMPLEX*16 F1(6)
      COMPLEX*16 F2(*)
      COMPLEX*16 FTMP(6)
      COMPLEX*16 V3(*)
      INTEGER*4 I
      CALL FFV2P1N_1(F2,V3,COUP1,F1)
      CALL FFV4P1N_1(F2,V3,COUP2,FTMP)
      DO I = 3, 6
        F1(I) = F1(I) + FTMP(I)
      ENDDO
      END


C     This File is Automatically generated by ALOHA 
C     The process calculated in this file is: 
C     Gamma(3,2,-1)*ProjM(-1,1)
C     
      SUBROUTINE FFV2_3P1N_1(F2, V3, COUP1, COUP2,F1)
      IMPLICIT NONE
      COMPLEX*16 CI
      PARAMETER (CI=(0D0,1D0))
      COMPLEX*16 COUP1
      COMPLEX*16 COUP2
      COMPLEX*16 F1(6)
      COMPLEX*16 F2(*)
      COMPLEX*16 FTMP(6)
      COMPLEX*16 V3(*)
      INTEGER*4 I
      CALL FFV2P1N_1(F2,V3,COUP1,F1)
      CALL FFV3P1N_1(F2,V3,COUP2,FTMP)
      DO I = 3, 6
        F1(I) = F1(I) + FTMP(I)
      ENDDO
      END


C     This File is Automatically generated by ALOHA 
C     The process calculated in this file is: 
C     Gamma(3,2,-1)*ProjM(-1,1)
C     
      SUBROUTINE FFV2_5P1N_1(F2, V3, COUP1, COUP2,F1)
      IMPLICIT NONE
      COMPLEX*16 CI
      PARAMETER (CI=(0D0,1D0))
      COMPLEX*16 COUP1
      COMPLEX*16 COUP2
      COMPLEX*16 F1(6)
      COMPLEX*16 F2(*)
      COMPLEX*16 FTMP(6)
      COMPLEX*16 V3(*)
      INTEGER*4 I
      CALL FFV2P1N_1(F2,V3,COUP1,F1)
      CALL FFV5P1N_1(F2,V3,COUP2,FTMP)
      DO I = 3, 6
        F1(I) = F1(I) + FTMP(I)
      ENDDO
      END


