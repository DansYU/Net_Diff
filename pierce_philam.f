Copyright (c) Tongji University 2006.
c    All rights reserved.
c
c    �������� MultiplyRR
c        
c    ���ܣ�   ����3*3 �������
c
c    Created by Jiexian Wang April 2006
c
c    Modified by zStone JULY 7 2006
c
c     input:
c        real*8 XSTA, YSTA, ZSTA     ��վ �ع�ϵֱ������
c        real*8 XSAT, YSAT, ZSAT     ���� �ع�ϵֱ������
c
c     output:
c        real*8 Phi, Lam             ���̵���������
c        real*8 RcIono               ��б����
c        real*8 Elevation            �߶Ƚ�
c        real*8 Azimuth              ��λ��
c        Integer*4 Ier               �����־        
c
c****************************************************************** 
      subroutine pierce_philam(Xsta, Ysta , Zsta
     . , Xsat, Ysat, Zsat ,Phi, Lam, RcIono, Elevation, Azimuth,Ier) 

      IMPLICIT none
      
      !include 'wadpdef.fti'	
c.... ���롢�������
      real*8 XSTA, YSTA, ZSTA
      real*8 XSAT, YSAT, ZSAT
      real*8 Phi, Lam
      real*8 RcIono
      real*8 Elevation
      real*8 Azimuth
      Integer*4 Ier
      real(8) Earth_Radius 
      real(8) Iono_Hei
           
c.... �ڲ�ʹ�ñ���
      real*8 DIST
      real*8 EX
      real*8 EY
      real*8 EZ
      real*8 B
      real*8 C
      real*8 X,Y,Z
      EARTH_RADIUS=6378.137d0
      Iono_Hei = 375.d0
c.... ��ʼ�������־
      ier = 0
c.... ����վ�Ǿ���
      Dist = (Xsat - Xsta)**2 + (Ysat - Ysta)**2 + (Zsat - Zsta)**2
      Dist = dsqrt(Dist)

c.... վ�Ƿ���ʸ��
      ex = (Xsat - Xsta) / Dist
      ey = (Ysat - Ysta) / Dist
      ez = (Zsat - Zsta) / Dist

c.... ���IPPλ��
c      print *, 'Iono_Hei', Iono_Hei, 'Earth_Radius', Earth_Radius
      B = 2.0d0 * (Xsta * ex + Ysta * ey + Zsta * ez)
      c = Xsta * Xsta + Ysta * Ysta + Zsta * Zsta 
     . - (Earth_Radius  + Iono_Hei)*(Earth_Radius + Iono_Hei)
     . *1000000.0d0
      Dist = -B + dsqrt(B * B - 4.0d0 * c)
      Dist = Dist / 2.0d0

c.... IPP��άֱ������
      X = Xsta + Dist * ex
      Y = Ysta + Dist * ey
      Z = Zsta + Dist * ez

c.... ��Ϊ��������
      Phi = datan(Z / dsqrt(X * X + Y * Y))
      Lam = datan2(Y, X)

c.... ��б����
      RcIono = ex * X + ey * Y + ez * Z
      RcIono = RcIono / dsqrt(X * X + Y * Y + Z * Z)

c.... ����߶Ƚǡ���λ��    
 	  call  XYZUEN(Xsta, Ysta, Zsta, Xsat, Ysat, Zsat
     . , Elevation, Azimuth,Ier) 
 

      return
      end