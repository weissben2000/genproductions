C     This File is Automatically generated by ALOHA 
C     The process calculated in this file is: 
C     P(3,1)*Metric(1,2) - P(3,2)*Metric(1,2) - P(2,1)*Metric(1,3) +
C      P(2,3)*Metric(1,3) + P(1,2)*Metric(2,3) - P(1,3)*Metric(2,3)
C     
      SUBROUTINE VVV1P1N_2(V1, V3, COUP,V2)
      IMPLICIT NONE
      COMPLEX*16 CI
      PARAMETER (CI=(0D0,1D0))
      COMPLEX*16 COUP
      REAL*8 P1(0:3)
      REAL*8 P2(0:3)
      REAL*8 P3(0:3)
      COMPLEX*16 TMP11
      COMPLEX*16 TMP14
      COMPLEX*16 TMP15
      COMPLEX*16 TMP8
      COMPLEX*16 TMP9
      COMPLEX*16 V1(*)
      COMPLEX*16 V2(6)
      COMPLEX*16 V3(*)
      P1(0) = DBLE(V1(1))
      P1(1) = DBLE(V1(2))
      P1(2) = DIMAG(V1(2))
      P1(3) = DIMAG(V1(1))
      P3(0) = DBLE(V3(1))
      P3(1) = DBLE(V3(2))
      P3(2) = DIMAG(V3(2))
      P3(3) = DIMAG(V3(1))
      V2(1) = +V1(1)+V3(1)
      V2(2) = +V1(2)+V3(2)
      P2(0) = -DBLE(V2(1))
      P2(1) = -DBLE(V2(2))
      P2(2) = -DIMAG(V2(2))
      P2(3) = -DIMAG(V2(1))
      TMP11 = (V3(3)*V1(3)-V3(4)*V1(4)-V3(5)*V1(5)-V3(6)*V1(6))
      TMP14 = (P2(0)*V1(3)-P2(1)*V1(4)-P2(2)*V1(5)-P2(3)*V1(6))
      TMP15 = (P3(0)*V1(3)-P3(1)*V1(4)-P3(2)*V1(5)-P3(3)*V1(6))
      TMP8 = (V3(3)*P1(0)-V3(4)*P1(1)-V3(5)*P1(2)-V3(6)*P1(3))
      TMP9 = (V3(3)*P2(0)-V3(4)*P2(1)-V3(5)*P2(2)-V3(6)*P2(3))
      V2(3)= COUP*(TMP11*(+CI*(P1(0))-CI*(P3(0)))+(V1(3)*(-CI*(TMP8)
     $ +CI*(TMP9))+V3(3)*(-CI*(TMP14)+CI*(TMP15))))
      V2(4)= COUP*(TMP11*(-CI*(P1(1))+CI*(P3(1)))+(V1(4)*(+CI*(TMP8)
     $ -CI*(TMP9))+V3(4)*(+CI*(TMP14)-CI*(TMP15))))
      V2(5)= COUP*(TMP11*(-CI*(P1(2))+CI*(P3(2)))+(V1(5)*(+CI*(TMP8)
     $ -CI*(TMP9))+V3(5)*(+CI*(TMP14)-CI*(TMP15))))
      V2(6)= COUP*(TMP11*(-CI*(P1(3))+CI*(P3(3)))+(V1(6)*(+CI*(TMP8)
     $ -CI*(TMP9))+V3(6)*(+CI*(TMP14)-CI*(TMP15))))
      END


