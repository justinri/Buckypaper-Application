clc;
clear all;
close all;

%% Real cables
grav = 9.81; % [m/s^2] acceleration of gravity
rho_rs = 7600; % [kg/m^3] density of secondary cables
yield_strength_r = 250*10^6; % [Pa] yield strength of steel cables 
dia_rm = 0.6223; % [m] diameter main cable
dia_rs = .25; % [m] diameter secondary cables
a_rm = pi*(dia_rm/2)^2; % [m^2] area of main cable
a_rs = pi*(dia_rs/2)^2; % [m^2] area of secondary cables
max_ten_rm = 142343092; % [N] equals to 16000 tons
strain = .002; % strain allowed yield, aka .2%


%% Main cable
% Main Cable
len_m = 1200; % [m] Length of main cable
stress_rm = max_ten_rm/a_rm; % [Pa] stress in main cables
fs = yield_strength_r/stress_rm; % safety factor used
weight_cable_m = rho_rs*grav*a_rm*len_m; % [N] weight of main cables
adj_force_rm = max_ten_rm-weight_cable_m; % [N] adjusted max force in main avg_dia_cu_mcables

% Secondary cables
tallest_cable = 160; % [m] height of tallest secondary cable
shortest_cable = 3.5; % [m] height of shortest secondary cable
num_of_cables = 43; % number of secondary cables

height_cables = zeros(1,num_of_cables);
for i = 1:num_of_cables;
height_cables(:,i) = shortest_cable + ((i-1)/(num_of_cables-1))*(tallest_cable-shortest_cable); % height of secondary cables
end


weight_cables = height_cables*a_rs*grav*rho_rs; % [N] weight of secondary cables
force_rs = (yield_strength_r*a_rs)/fs; % [N] max force in secondary cables
adj_force_rs = force_rs-weight_cables; % [N] adjusted max force in secondary cables


%% Composite
% Main Cable
Ef = 550*10^9; % [Pa] Young's modulus for the fiber
Em = 3.5*10^9; % [Pa] Young's modulus for the matrix (Epoxy)
rho_f = 400; % [kg/m^3] Density of the fibers
rho_m = 1.25*10^3; % [kg/m^3] Density of the matrix (Epoxy)
vf = .7; % volume fraction of the fibers
Ecu = Ef*vf + (1-vf)*Em; % Parallel 
Ecl = (vf/Ef+(1-vf)/Em)^(-1); % Perpendicular
rho_c = vf*rho_f + (1-vf)*rho_m; % Density of the composite
yield_cu = .25*200*10^9; % [pa] yield of compsite upper
yield_cl = Ecl*strain; % [pa] yield of compsite lower



a_cu_m = adj_force_rm/yield_cu; % [m^2] area of compsite main cable
a_cl_m = adj_force_rm/yield_cl; % [m^2] area of compsite for secondary cables

dia_cu_m = 2*sqrt(a_cu_m/pi); % [m] changing diameter of compsite cable upper for main cable
dia_cl_m = 2*sqrt(a_cl_m/pi); % [m] changing diameter of compsite cable lower for main cable

avg_dia_cu_m = mean(dia_cu_m); % [m] average diameter of compsite cable upper for secondary cable
avg_dia_cl_m = mean(dia_cl_m); % [m] average diameter of compsite cable lower for secondary cable
avg_dia_mix_m = (avg_dia_cu_m+avg_dia_cl_m)/2; % [m] average diameter of compsite cable mix for secondary cable


%% Secondary cables
% Upper bound 
a_cu = adj_force_rs./yield_cu; % [m^2] area of compsite secondary cables

% Lower bound volume fractions
a_cl = adj_force_rs./yield_cl; % [m^2] area of compsite for secondary cables

dia_cu = 2*sqrt(a_cu/pi); % [m] changing diameter of compsite cable upper for secondary cable
dia_cl = 2*sqrt(a_cl/pi); % [m] changing diameter of compsite cable lower for secondary cable

avg_dia_cu = mean(dia_cu); % [m] average diameter of compsite cable upper for secondary cable
avg_dia_cl = mean(dia_cl); % [m] average diameter of compsite cable lower for secondary cable
avg_dia_mix = (avg_dia_cu+avg_dia_cl)/2; % [m] average diameter of compsite cable mix for secondary cable


%% Bucky paper
Eb = Ef; % [Pa] Young's modulus for the bucky paper
rho_b = rho_f; % [kg/m^3] Density of the bucky paper
yield_b = .25*200*10^9; %max!!! % [Pa] Yield stress volume fraction of the bucky paper

% Main cable
a_bu_m = adj_force_rm/yield_b; % [m^2] area of secondary cable for bucky paper
dia_bu_m = 2*sqrt(a_bu_m/pi); % [m] changing to diameter of main cables for bucky paper
avg_dia_bu_m = mean(dia_bu_m); % [m] average diameter of bucky paper for main cable


% Secondary cable 
a_bu = adj_force_rs./yield_b; % [m^2] area of secondary cable for bucky paper
dia_bu = 2*sqrt(a_bu/pi); % [m] changing to diameter of secondary cables for bucky paper
avg_dia_bu = mean(dia_bu); % [m] average diameter of bucky paper for secondary cable

%% Main Cables
printf("Diameter of main cable on \n Mackinac bridge equals %f \n \n", dia_rm);
printf("Diameter of main cable made \n from Bucky paper equals %f \n \n", avg_dia_bu_m);
printf("Diameter of main cable with \n composite as transversely isotropic equals %f \n \n", avg_dia_cu_m);
printf("Diameter of main cable with \n  composite as anisotropic equals %f \n \n", avg_dia_mix_m);

%% Secondary Cables
printf("Diameter of secondary cables on \n  cMackinac bridge equals %f \n \n", dia_rs);
printf("Diameter of secondary cables made \n from Bucky paper equals %f \n \n", avg_dia_bu);
printf("Diameter of secondary cable with \n composite as transversely isotropic equals %f \n \n", avg_dia_cu);
printf("Diameter of secondary cable with \n  composite as anisotropic equals %f \n \n", avg_dia_mix);


