%Set run-time.
global t0; t0 = 0. ;               
global tf; tf = 5000 ; 

%Constants
global thou; thou=1.e3;
global mill; mill=1.e6;
global bill; bill=1.e9;
global tril; tril=1.e12;

%Conversion constants

global CO2_2_C;  CO2_2_C=               12./44.; %molar ratio
global bbl_2_gC; bbl_2_gC=              0.43.*mill*CO2_2_C;  %gC/barrel source: http://www.epa.gov/cleanenergy/energy-resources/refs.html
cf2cm=35.3145;
global scm_2_gC; scm_2_gC=              54.4.*cf2cm.*CO2_2_C; %implicit /1000*1000 (/thousand cubic feet -> /cubic feet; then kg -> g; source: http://www.eia.gov/environment/emissions/co2_vol_mass.cfm
global t_coal_2_gC;t_coal_2_gC=1../.907.*2100.8.*thou.*CO2_2_C; %note: conversion from short ton to ton; source: co2_vol_mass.xlsx
global kwh_2_J; kwh_2_J=                3.6e6  ; %J/kwh
global mwh_2_J; mwh_2_J=                3.6e9  ; %J/mwh
global g_2_Tt; g_2_Tt=mill.*tril;
global g_per_T; g_per_T = mill;
global quads_2_J; quads_2_J=1.055e18;

global ff_frac0; ff_frac0=0.77; %Initial fraction of global energy consumption supplied by fossil energies 
%Observed global consumption rates, 1980-2012.
data=xlsread('data/Total_Primary_Energy_Consumption_(Quadrillion_Btu).xls');
global Globaltotenergyuseinit; Globaltotenergyuseinit=data(3,end-12-15).*quads_2_J;
%global P0; P0 = 7.2e9 ;%Gerland et al., 2014
global P0; P0 = 4.86e9;%US census
global GlobalpercapconsumpInit; GlobalpercapconsumpInit= Globaltotenergyuseinit./P0;
global present_year; present_year=1985.;
%global emissions_to_date; emissions_to_date=.3809; %historical ff emissions (Tt C, year 2012); Source: RCP data
global emissions_to_date; emissions_to_date=.1903; %historical ff emissions (Tt C, year 1985); Source: RCP data

global coalEfactor;coalEfactor =2.58e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
global oilEfactor;oilEfactor   =2.0e-5;   %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
global gasEfactor;gasEfactor   =1.53e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf

global ctax0; ctax0=-60; %$/ton C, Based on -15$/ton C02 subsidy value supplied by Gernot Wagner
