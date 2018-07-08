Copyright (c) Tongji University 2006.
c    All rights reserved.
c    ��������XYZUEN
c
c    ���ܣ� ����߶Ƚǡ���λ��
c
c    Created by Jiexian Wang April 2006
c    Modified by zStone JUNE 30 2006
c
c     input:
c        real*8 Xsta, Ysta, Zsta         ��վ����
c        real*8 Xsat, Ysat, Zsat         ��������
c
c     output:
c        real*8 Elevation, Azimuth       վ�Ǹ߶Ƚ� ��λ��
c        integer*4 ier                   �����־
c********************************************************************

      subroutine XYZUEN(Xsta, Ysta, Zsta, Xsat, Ysat, Zsat
     . , Elevation, Azimuth,ier)
      IMPLICIT none
      !include 'wadpdef.fti'	
      	   
c     �����������
      real*8 Xsta, Ysta, Zsta
      real*8 Xsat, Ysat, Zsat
      real*8 Elevation, Azimuth
      integer*4 ier
      real(8) :: pi

c     �ڲ�����     
      real*8 Phi, Lam,XYZ(3), UEN(3), R(3, 3), H
      Integer*4 I,J

      pi=3.14159265358d0
      ier=0

c.... վ�Ƿ���
      XYZ(1) = Xsat - Xsta
      XYZ(2) = Ysat - Ysta
      XYZ(3) = Zsat - Zsta

c.... ��վ�������
      !call XYZ2BLH(Phi, Lam, H, Xsta, Ysta, Zsta,Ier)
      call XYZ2BLH(Xsta, Ysta, Zsta,Phi, Lam, H)  !����������Զ���Ϊ��λ����Ҫת�ɻ���
      Phi=Phi*pi/180.d0
      Lam=Lam*pi/180.d0
      if (Ier .ne. 0) then 
         print *, 'Error XYZUEN.f call XYZ2BLH error ', phi,' ', lam
      endif
      
c.... ����ϵ תΪ վ��ϵ
      call  RotMaxR(Phi, Lam, R,Ier)
      if (Ier .ne. 0) then 
         print *, 'Error XYZUEN.f call RotMaxR error', R  
      endif

c.... ����վ��վ�ĵ�ƽ����
      do 10 i = 1 , 3
         UEN(i) = 0.0d0
         do 10 j = 1 , 3
            UEN(i) = UEN(i) + R(j, i) * XYZ(j)
 10   continue
 
c.... �߶Ƚ�
      Elevation = datan(UEN(1)/dsqrt(UEN(2)*UEN(2) + UEN(3)*UEN(3)))

c.... ��λ��
      Azimuth = datan2(UEN(2), UEN(3))
      if (Azimuth .lt.0.0d0) Azimuth=Azimuth+pi*2.0d0
      
 999  continue
      return
	end