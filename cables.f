      PROGRAM Cables
      IMPLICIT NONE


!! Real cables
      DOUBLE PRECISION :: grav = 9.81  ! [m/s^2] acceleration of gravity
      DOUBLE PRECISION :: rho_rs = 7600  ! [kg/m^3] density of secondary cables
      real*8 :: pi = 3.14159265359  ! [kg/m^3] density of secondary cables
      INTEGER :: yield_strength_r = 500  ! [Pa] yield strength of steel cables 
      real*8 :: dia_rm = 0.6223  ! [m] diameter main cable
      DOUBLE PRECISION :: dia_rs = .25  ! [m] diameter secondary cables
      DOUBLE PRECISION :: Ef = 550  ! [Pa] Young's modulus for the fiber
      DOUBLE PRECISION :: Em = 3.5  ! [Pa] Young's modulus for the matrix
      INTEGER :: rho_f = 400  ! [kg/m^3] Density of the fibers
      DOUBLE PRECISION :: rho_m = 1250  ! [kg/m^3] Density of the matrix (Epoxy)
      DOUBLE PRECISION :: vf = .7  ! volume fraction of the fibers
      DOUBLE PRECISION :: max_ten_rm = 142343092  ! [N] equals to 16000 tons
      INTEGER :: tallest_cable = 160  ! [m] height of tallest cable
      DOUBLE PRECISION :: shortest_cable = 3.5  ! [m] height of shortest cable
      DOUBLE PRECISION :: strain = .002 ! max allowable strain for yield stress
      DOUBLE PRECISION :: yield_cu = 200
      DOUBLE PRECISION :: yield_b = 200
      INTEGER :: num_of_cables = 43  ! number of secondary cables
      INTEGER :: len_m = 1200  ! [m] length of main cable
      DOUBLE PRECISION :: a_rm,a_rs,stress_rm,fs,force_rs,
     & main_cable_h,main_cable_t,a_cu_m,a_cl_m,weight_cable_m,
     & Ecu,rho_c,yield_c,Ecl,yield_cl,adj_force_rm,dia_cu_m,
     & dia_cl_m,avg_dia_cu_m,avg_dia_cl_m,avg_dia_mix_m,
     & avg_dia_cu,avg_dia_cl,avg_dia_mix,Eb,rho_b,a_bu_m,
     & dia_bu_m,avg_dia_bu_m,avg_dia_bu
      INTEGER :: i,yield_f,yield_m
      REAL*8, DIMENSION(43) :: height_cables,
     & weight_cables,
     & adj_force_rs,a_cl,a_cu,dia_cu,dia_cl,a_bu,dia_bu
      a_rm = pi*(dia_rm/2)**2  ! [m^2] area of main cable
      a_rs = pi*(dia_rs/2)**2  ! [m^2] area of secondary cables

!! Main cable
      stress_rm = max_ten_rm/a_rm  ! [Pa] stress in main cables
      fs = yield_strength_r/stress_rm ! safety factor used
      weight_cable_m = rho_rs*grav*a_rm*len_m ! [N] weight of main cables
      adj_force_rm = max_ten_rm-weight_cable_m ! [N] adjusted max force in main avg_dia_cu_mcables
! Secondary cables

      do i = 1,num_of_cables
         height_cables(i) = shortest_cable + 
     & ((i-1)/(num_of_cables-1))*(tallest_cable-shortest_cable) ! height of secondary cables.... not done, fix to approx height change
      end do

      weight_cables = height_cables*a_rs*grav*rho_rs  ! [N] weight of secondary cables
      force_rs = (yield_strength_r*a_rs)/fs  ! [N] max force in secondary cables
      adj_force_rs = force_rs-weight_cables  ! [N] adjusted max force in secondary cables


!!! Composite
!! Main Cable
!! Secondary cables
      Ef = Ef*10**9   
      Em = Em*10**9  ! [Pa] Young's modulus for the matrix (Epoxy)
      Ecu = Ef*vf + (1-vf)*Em  ! Parallel 
      Ecl = (vf/Ef+(1-vf)/Em)**(-1)  ! Perpendicular
      rho_c = vf*rho_f + (1-vf)*rho_m  ! Density of the composite
      yield_cu = .25*yield_cu*10**9  ! [pa] yield of compsite upper
      yield_cl = Ecl*strain  ! [pa] yield of compsite lower

      a_cu_m = adj_force_rm/yield_cu  ! [m^2] area of compsite main cable
      a_cl_m = adj_force_rm/yield_cl  ! [m^2] area of compsite for secondary cables

      dia_cu_m = 2*sqrt(a_cu_m/pi)  ! [m] changing diameter of compsite cable upper for main cable
      dia_cl_m = 2*sqrt(a_cl_m/pi)  ! [m] changing diameter of compsite cable lower for main cable
      avg_dia_cu_m = dia_cu_m  ! [m] average diameter of compsite cable upper for secondary cable
      avg_dia_cl_m = dia_cl_m  ! [m] average diameter of compsite cable lower for secondary cable
      avg_dia_mix_m = (avg_dia_cu_m+avg_dia_cl_m)/2  ! [m] average diameter of compsite cable mix for secondary cable


!!! Secondary cables
!! Upper bound 
      a_cu = adj_force_rs/yield_cu  ! [m^2] area of compsite secondary cables

!! Lower bound volume fractions
      a_cl = adj_force_rs/yield_cl  ! [m^2] area of compsite for secondary cables

      dia_cu = 2*sqrt(a_cu/pi)  ! [m] changing diameter of compsite cable upper for secondary cable
      dia_cl = 2*sqrt(a_cl/pi)  ! [m] changing diameter of compsite cable lower for secondary cable
      
      avg_dia_cu = sum(dia_cu)/num_of_cables  ! [m] average diameter of compsite cable upper for secondary cable
      avg_dia_cl = sum(dia_cl)/num_of_cables  ! [m] average diameter of compsite cable lower for secondary cable
      avg_dia_mix = (avg_dia_cu+avg_dia_cl)/2  ! [m] average diameter of compsite cable mix for secondary cable


!!! Bucky paper
      Eb = Ef  ! [Pa] Young's modulus for the bucky paper
      rho_b = rho_f  ! [kg/m^3] Density of the bucky paper
      yield_b = .25*yield_b*10**9  !max!!! ! [Pa] Yield stress volume fraction of the bucky paper

!! Main cable
      a_bu_m = adj_force_rm/yield_b  ! [m^2] area of secondary cable for bucky paper
      dia_bu_m = 2*sqrt(a_bu_m/pi)  ! [m] changing to diameter of main cables for bucky paper
      avg_dia_bu_m = dia_bu_m  ! [m] average diameter of bucky paper for main cable


!! Secondary cable 
      a_bu = adj_force_rs/yield_b  ! [m^2] area of secondary cable for bucky paper
      dia_bu = 2*sqrt(a_bu/pi)  ! [m] changing to diameter of secondary cables for bucky paper
      avg_dia_bu = sum(dia_bu)/num_of_cables  ! [m] average diameter of bucky paper for secondary cable
!
!! Main Cables
      write(*,*) "Diameter of main cable on",
     & "Mackinac bridge equals"
      print *, dia_rm
      write(*,*) "Diameter of main cable made from Bucky", 
     & "paper equals"
      print *, avg_dia_bu_m
      write(*,*) "Diameter of main cable with composite",
     & "as transversely isotropic equals"
      print *, avg_dia_cu_m
      write(*,*) "Diameter of main cable with composite",
     & "as anisotropic equals"
      print *, avg_dia_mix_m
!
!! Secondary Cables
      write(*,*) "Diameter of secondary cable on",
     & "Mackinac bridge equals"
      print *, dia_rs
      write(*,*) "Diameter of secondary cable made",
     & "from Bucky paper equals"
      print *, avg_dia_bu
      write(*,*) "Diameter of secondary cable with",
     & "composite as transversely isotropic equals"
      print *, avg_dia_cu
      write(*,*) "Diameter of secondary cable with",
     & "composite as anisotropic equals"
      print *, avg_dia_mix
!
      END PROGRAM
