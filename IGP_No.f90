!********************************************************************
!  �������� IGP_No
!
!  ��;��   ���������뾭γ��ת��
!           Mode=0 �ɾ�γ����IGP��
!           Mode=1 ��IGP����γ��
!
!  ���롢���������
!           integer*4 phi, lam �����㾭γ�� �Ƕ�
!           integer*4 ipgno    ��������
!           integer*4 mode     ת������
!           integer*4 ier      �����־
! 2012-1-21 4:07 �������㾭γ�ȸ�Ϊʵ������Ӧ��������
!********************************************************************

      subroutine IGP_No(Phi, Lam, IGPNo,  Mode,Ier) 
      IMPLICIT none
!      include 'wadpdef.fti'
!.... I/O����
!      integer*4 phi, lam
      real*8     phi, lam
      integer*4 IGPNo
      integer*4 IGPNosequent
      integer*4 mode
      integer*4 ier 

! .... �������� �С�����     
      integer*4 N_Row 
      parameter( N_Row = 20)     
      integer*4 N_Col            
      parameter( N_Col = 16)

! .... �������� ��ʼ��γ�� �Ƕ�
      real*8  B0
      parameter( B0 = 7.5) 
      real*8 L0
      parameter( L0 = 70.0)

! .... �������� ��� �Ƕ�      
      real*8 Delta_B      
      parameter( Delta_B = 2.5)
      real*8 Delta_L      
      parameter( Delta_L = 5.0)
! .... �������� ��ֹ��γ�� �Ƕ�
      integer*4 B1
      parameter( B1 = 55)
      integer*4 L1
      parameter( L1 = 145)

!.... �ڲ�ʹ�ñ���
      Integer*4 i_row,i_col, ntol

!.... ��ʼ�������־      
      Ier = 0

!.... �ܸ��������      
      ntol = n_row * n_col

!.... ��γ�� --> ���
      if (mode .eq. 0) then
          if (phi .lt. b0 .or. phi .gt. b1 .or. lam .lt. l0 .or. lam .gt. l1) then
             igpno = 0
             ier = 1
          else
             i_row = int((phi - b0) / delta_b) + 1
             i_col = int((lam - l0) / delta_l) + 1
             IGPNosequent = (i_col - 1) * n_row + i_row               
             if(mod(IGPNosequent,2) .eq. 0)then
!...igpno��ż����(2,4,6,...,320)==>1-160
               igpno=IGPNosequent/2
             else
!...igpno��������(1,3,5,...,319)==>161-320
               igpno=(IGPNosequent+1)/2+160
             endif
          end if
!.... ��� --> ��γ��
      elseif (mode .eq. 1) then 
          if (igpno .le. 0 .or. igpno .gt. ntol) then
             phi = 0
             lam = 0
             ier=1
          else
             if(igpno .le. ntol/2)then
               IGPNosequent=igpno*2
             else
               IGPNosequent=(igpno-ntol/2)*2-1
             endif
             i_col = int((IGPNosequent -1)/ n_row ) + 1
             i_row = IGPNosequent - (i_col - 1) * n_row
             phi = b0 + (i_row - 1) * delta_b
             lam = l0 + (i_col - 1) * delta_l
          end if
!.... mode����
      else
          ier=1
      endif

      return
      end
      