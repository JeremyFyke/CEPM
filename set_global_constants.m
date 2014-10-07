%Set run-time.
global t0; t0 = 0. ;               
global tf; tf = 5000 ;             
%Conversion constants

global bbl_2_gC; bbl_2_gC=              1.14e5 ; %gC/barrel
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
global emissions_to_date; emissions_to_date=.5; %historical emissions (Gt C) (TODO: make sure this is totally right (get emissions.nc from UVic model?)

