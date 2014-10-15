%Set run-time.
global t0; t0 = 0. ;               
global tf; tf = 5000 ;             
%Conversion constants

global CO2_2_C;  CO2_2_C=               0.2727; %molar ratio (12/44)
global bbl_2_gC; bbl_2_gC=              0.43.*1.e6.*CO2_2_C;  %gC/barrel source: http://www.epa.gov/cleanenergy/energy-resources/refs.html
cf2cm=35.3145;
global scm_2_gC; scm_2_gC=              54.4.*cf2cm.*CO2_2_C; %implicit /1000*1000 (/thousand cubic feet -> /cubic feet; then kg -> g; source: http://www.eia.gov/environment/emissions/co2_vol_mass.cfm
global t_coal_2_gC;t_coal_2_gC=1../.907.*2100.8.*1.e3.*CO2_2_C; %note: conversion from short ton to ton; source: co2_vol_mass.xlsx
global kwh_2_J; kwh_2_J=                3.6e6  ; %J/kwh
global mwh_2_J; mwh_2_J=                3.6e9  ; %J/mwh
global g_2_Tt; g_2_Tt=1.e6.*1.e12;
global quads_2_J; quads_2_J=1.055e18;

USpop2013= 316148990; %People
global USpercapconsump2013; USpercapconsump2013= 5.99842836e13.*1.e6./USpop2013;%Joules, source: http://www.iea.org/statistics/statisticssearch/report/?&country=USA&year=2012&product=Indicators, converted using EIA converter
Globaltotenergyuse2013= 3.75926910e14.*1.e6; %Joules, source: http://www.iea.org/statistics/statisticssearch/report/?country=WORLD&product=balances&year=2012, converted using EIA converter
global P0; P0 = 7.e9 ;
global Globalpercapconsump2013; Globalpercapconsump2013= Globaltotenergyuse2013./P0;
global present_year; present_year=2014.;
global emissions_to_date; emissions_to_date=.515; %historical emissions (Tt C); Source: AR5
