C     This File is Automatically generated by ALOHA 
C     The process calculated in this file is: 
C     Gamma(3,2,-1)*ProjM(-1,1) - 2*Gamma(3,2,-1)*ProjP(-1,1)
C     
      SUBROUTINE FFV3P1N_3(F1, F2, COUP,V3)
      IMPLICIT NONE
      COMPLEX*16 CI
      PARAMETER (CI=(0D0,1D0))
      COMPLEX*16 COUP
      COMPLEX*16 F1(*)
      COMPLEX*16 F2(*)
      COMPLEX*16 V3(6)
      V3(3)= COUP*2D0 * CI*(-1D0/2D0*(F1(3)*F2(5)+F1(4)*F2(6))+F1(5)
     $ *F2(3)+F1(6)*F2(4))
      V3(4)= COUP*(-2D0 * CI)*(+1D0/2D0*(F1(3)*F2(6)+F1(4)*F2(5))+F1(5)
     $ *F2(4)+F1(6)*F2(3))
      V3(5)= COUP*CI*(-CI*(F1(3)*F2(6))+CI*(F1(4)*F2(5))-2D0 * CI
     $ *(F1(5)*F2(4))+2D0 * CI*(F1(6)*F2(3)))
      V3(6)= COUP*2D0 * CI*(-1D0/2D0*(F1(3)*F2(5))+1D0/2D0*(F1(4)*F2(6)
     $ )-F1(5)*F2(3)+F1(6)*F2(4))
      END


