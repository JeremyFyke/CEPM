function [c] = set_global_constants()

c.ensemble_size=1000;

%Set run-time.
c.t0 = 0. ;               
c.tf = 5000 ; 

%Constants
c.thou=1.e3;
c.mill=1.e6;
c.bill=1.e9;
c.tril=1.e12;

%Conversion constants

c.CO2_2_C=               12./44.; %molar ratio
c.bbl_2_gC=              0.43.*c.mill*c.CO2_2_C;  %gC/barrel source: http://www.epa.gov/cleanenergy/energy-resources/refs.html
cf2cm=35.3145;
c.scm_2_gC=              54.4.*cf2cm.*c.CO2_2_C; %implicit /1000*1000 (/thousand cubic feet -> /cubic feet; then kg -> g; source: http://www.eia.gov/environment/emissions/co2_vol_mass.cfm
c.t_coal_2_gC=1../.907.*2100.8.*c.thou.*c.CO2_2_C; %note: conversion from short ton to ton; source: co2_vol_mass.xlsx
c.kwh_2_J=                3.6e6  ; %J/kwh
c.mwh_2_J=                3.6e9  ; %J/mwh
c.g_2_Tt=c.mill.*c.tril;
c.g_per_T = c.mill;
c.quads_2_J=1.055e18;
%Observed global consumption rates, 1980-2012.
data=xlsread('data/Total_Primary_Energy_Consumption_(Quadrillion_Btu).xls');

%1985 values
%p.present_year=1985.;
%p.ff_frac0=0.77; %Initial fraction of global energy consumption supplied by fossil energies 
%p.Globaltotenergyuseinit=data(3,end-12-15).*quads_2_J;
%p.P0 = 4.86e9;%World Bank
%p.emissions_to_date=.19; %historical ff emissions (Tt C, year 2012); Source: RCP data

%2012 values
c.present_year=2012.;
c.ff_frac0=0.80; %Initial fraction of global energy consumption supplied by fossil energies 
c.Globaltotenergyuseinit=data(3,end-1).*c.quads_2_J;
c.P0 = 7.2e9 ;%World Bank
c.emissions_to_date=.38; %historical ff emissions (Tt C, year 2012); Source: RCP data

c.GlobalpercapconsumpInit= c.Globaltotenergyuseinit./c.P0;
c.coalEfactor =2.58e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
c.oilEfactor   =2.0e-5;   %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
c.gasEfactor   =1.53e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf

c.ctax0=-60; %$/ton C, Based on -15$/ton C02 subsidy value supplied by Gernot Wagner

c.CE_TCRE_saturation_point=3.;
c.TCRE_dampening_factor=0.05;