c  ����14����ģ�ͼ���L1�ϵ�����ӳ�iondely
cccc by gxq 2014/1/5 15:57
c*****************************************

       subroutine cal_iondelay(ISow,RStaPos,RSatPos,iono_14para
     . ,Rionvdelay,I1outerr)
      implicit none
     
      integer(kind=1)  :: I1outerr
      integer(kind=4)  :: Week0,Ierr,i,ISow
      real(kind=8)     :: RStaPos(3),RSatPos(3)      
      real(kind=8)     :: RPhi,RLam,RcIono,RElevation,RAzimuth
      real(kind=8)     :: RA1,RB,iono_14para(14),Rionvdelay
      real(kind=8)     :: Ralpha(4),Rbeta(4),Rgama(4)     
                    
      I1outerr=1   
c************************************************  
c*********�����14��*****************************     
!      iono_14para(1)=8.750940e+00
!      iono_14para(2)=3.243312e+00
!      iono_14para(3)=1.416835e-08   
!      iono_14para(4)=1.942698e-07
!      iono_14para(5)=-1.837431e-06
!      iono_14para(6)=3.579759e-06
!      iono_14para(7)=1.274286e+05   
!      iono_14para(8)=-5.908882e+05
!      iono_14para(9)=5.955631e+06
!      iono_14para(10)=-1.138271e+07
!      iono_14para(11)=-3.561169e+03   
!      iono_14para(12)=1.652139e+05
!      iono_14para(13)=-1.257419e+06
!      iono_14para(14)=2.655165e+06                       
c**************************************************       
      RA1 = iono_14para(1)
      RB  = iono_14para(2)
      
      do i=1,4
        Ralpha(i)= iono_14para(i+2)
        Rbeta(i) = iono_14para(i+6)
        Rgama(i) = iono_14para(i+10)
      enddo
      
      call Pierce_PHiLam(RStaPos(1),RStaPos(2),RStaPos(3),
     .RSatPos(1),RSatPos(2),RSatPos(3), RPhi, RLam, RcIono, 
     .RElevation, RAzimuth,Ierr)
      if(Ierr .ne. 0) then
         print *, 'integerity_cor.f Pierce_PHiLam error'
         return
      endif
 
      call iono_14(RA1, RB, Ralpha, Rbeta, Rgama, 
     .                   RPhi, RLam, dble(ISow), Rionvdelay)
            if(Rionvdelay .lt. 0)Rionvdelay=1.5   !2.25��Ϊ1.5m 9TECu��ӦB1Ƶ��ĵ�����ӳ�
        ! ���춥�ӳٸ�Ϊб·���ӳ�   ���ڱ���һ��B1Ƶ�㣬��λ�ǣ�m
         
       Rionvdelay = Rionvdelay/RcIono   
      I1outerr=0      
      return
      end
      
c####################################################################c
      subroutine iono_14(A1, B, alpha, beta, gama,
     .                   lat, lon, sow, iono_delay)
c---------------------------------------------------------------------+
c˵������Ϣ����ϵͳ�����ʮ�Ĳ���ģ��                                 |
c                                                                     |
c���룺ʮ�Ĳ���ģ�� ҹ��ƽ��        A1          ����                  |
c      ʮ�Ĳ���ģ�� ҹ��б��        B           ����/pi               |
c      ʮ�Ĳ���ģ�� �������        alpha(4)    ��/pi^0~3             |
c      ʮ�Ĳ���ģ�� ��������        beta(4)     ��/pi^0~3             |
c      ʮ�Ĳ���ģ�� ���ҳ���        gama(4)     ��/pi^0~3             |
c      ���̵�γ��                   lat         ����                  |
c      ���̵㾭��                   lon         ����                  |
c      ����ʱ����                   sow         ��                    |
c                                                                     |
c��������̵�B1Ƶ���춥�ӳ�         iono_delay  ��                    |
c                                                                     |
c���ڣ�2007-9-21                                                      |
c---------------------------------------------------------------------+
      implicit none
     
      real*8 A1, B, alpha(4), beta(4), gama(4)
      real*8 lat, lon, sow
      real*8 iono_delay
      real*8 A2, A3, A4, t, PI, VLIGHT
      integer*4 i
c.... Frequency L1 L2
      real*8,parameter ::  Freq1  = 1561.098d6
      real*8,parameter ::  Freq2  = 1207.14d6
      real*8,parameter ::  Freq3  = 1268.52d6
     
      data PI/3.1415926535897932384626433832795d0/
      data VLIGHT/299792458.0d0/
      
c.... ��λת��      
	  lat = lat / PI

c.... ���̵�ط�ʱ
      t = sow + (lon / PI) * 43200.d0
      t = mod(t, 86400.d0)

c.... ���������ӳ������������
      A2= alpha(1)

c.... ���������ӳ��������߳���λ
c      A3= gama(1)   �����½ӿڸ���Ϊ gama(1)+ 50400.d0  cyl&wxl 2010-6-17 1:34 
      A3= gama(1) + 50400.d0

c.... ���������ӳ�������������
      A4 = beta(1)
      
      do i=1,3
        A2 = A2 + alpha(i+1)*(lat**i)
        A3 = A3 + gama(i+1)*(lat**i)
        A4 = A4 + beta(i+1)*(lat**i)
      enddo      
      
c.... ���������ӳ������������ȡֵ�ж�
      if(A2 .lt. 0.d0) A2 = 0.d0

c.... ���������ӳ��������߳���λȡֵ�ж�
      if(A3 .gt. 55800.d0) then
        A3 = 55800.d0
      else 
        if(A3 .lt. 43200.d0) then
           A3 = 43200.d0
        endif
      endif

c.... ���������ӳ�������������ȡֵ�ж�
c      if(A4 .gt. 158400.d0) then
c        A4 = 158400.d0
c      else 
c        if(A4 .lt. 86400.d0) then
c           A4 = 86400.d0
c        endif                
c      endif
cc.... ȫ�������ӳ�������������ȡֵ�ж�   
c �����µĽӿڣ���Ϊ 72000 ��172800 s (20h - 48h) cyl&wxl 2010-6-17 1:34
   
      if(A4 .gt. 172800.d0) then
        A4 = 172800.d0
      else   
        if(A4 .lt. 72000.d0) then
           A4 = 72000.d0
      endif        
        
      endif
c.... �ѵ�ǰʱ�̹��㵽�Գ���λΪ���ĵ�һ������
      do while(t .lt. (A3 - 43200.d0))
        t = t + 86400.d0
      end do
      
c  ȥ���ж����� ���û�����һ�� cyl&wxl 2010-6-17 1:34
c      do while(t .gt. (A3 + 43200.d0))   cyl&wxl
c        t = t - 86400.d0
c      end do

c.... �����춥�ӳ�
      iono_delay = (A1 - B * lat) * VLIGHT * 1e-9
c..... ���ҹ������ֵ������Ϊ��ֵ�����ݾ�������Ϊ1.5m
      if(0.1d0 > iono_delay) then
      iono_delay =1.5
      endif
      if( (A4 - 4.d0 * dabs(t - A3)) .gt. 0.d0) then
        iono_delay=iono_delay + A2*dcos(2.d0*PI*(t-A3)/A4)*VLIGHT
      endif
      
!!   ����2011-4-27 7:47 �ӿڣ����������޸�Ϊ����B1Ƶ�㣨ԭ��Ϊ����B3Ƶ�㣩
!! ����14�μ���ĵ�����ӳ�ΪB1Ƶ��ģ��ڸ����������ӳٻ���B3Ƶ��
!! cyl 2011-4-27 7:47
!       iono_delay =iono_delay*Freq1*Freq1/(Freq3*Freq3)
       
            
      end        