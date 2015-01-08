%Set run-time.
global t0; t0 = 0. ;               
global tf; tf = 5000 ; 

%Constants
thou=1.e3;
mill=1.e6;
bill=1.e9;
tril=1.e12;

%Conversion constants

global CO2_2_C;  CO2_2_C=               0.2727; %molar ratio (12/44)
global bbl_2_gC; bbl_2_gC=              0.43.*mill*CO2_2_C;  %gC/barrel source: http://www.epa.gov/cleanenergy/energy-resources/refs.html
cf2cm=35.3145;
global scm_2_gC; scm_2_gC=              54.4.*cf2cm.*CO2_2_C; %implicit /1000*1000 (/thousand cubic feet -> /cubic feet; then kg -> g; source: http://www.eia.gov/environment/emissions/co2_vol_mass.cfm
global t_coal_2_gC;t_coal_2_gC=1../.907.*2100.8.*thou.*CO2_2_C; %note: conversion from short ton to ton; source: co2_vol_mass.xlsx
global kwh_2_J; kwh_2_J=                3.6e6  ; %J/kwh
global mwh_2_J; mwh_2_J=                3.6e9  ; %J/mwh
global g_2_Tt; g_2_Tt=mill.*tril;
global quads_2_J; quads_2_J=1.055e18;

USpop2013= 316148990;
global USpercapconsump2013; USpercapconsump2013= 5.99842836e13.*mill./USpop2013;%Joules, source: http://www.iea.org/statistics/statisticssearch/report/?&country=USA&year=2012&product=Indicators, converted using EIA converter
%Observed global consumption rates, 1980-2012.
data=xlsread('data/Total_Primary_Energy_Consumption_(Quadrillion_Btu).xls');
global Globaltotenergyuse2013; Globaltotenergyuse2013=data(3,end-1).*quads_2_J;
global P0; P0 = 6.9e9 ;%United Nations Department of Economic and Social Affairs, Population Division
global Globalpercapconsump2013; Globalpercapconsump2013= Globaltotenergyuse2013./P0;
global present_year; present_year=2012.;
global emissions_to_date; emissions_to_date=.515; %historical emissions (Tt C); Source: AR5

global coalEfactor;coalEfactor =2.58e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
global oilEfactor;oilEfactor   =2.0e-5;   %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
global gasEfactor;gasEfactor   =1.53e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf

global ff_frac0; ff_frac0=0.87; %Initial fraction of global energy consumption supplied by renewables http://www.worldenergyoutlook.org/media/weowebsite/2012/WEO2012_Renewables.pdf
global noncombustedoil;noncombustedoil=0.05; %as a percent of total production, http://www.eia.gov/tools/faqs/faq.cfm?id=41&t=6



