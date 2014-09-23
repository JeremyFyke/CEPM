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
UStotenergyuse2013= 97.3; %Quads (IEA or DOE source)
global USpercapconsump2013; USpercapconsump2013= UStotenergyuse2013.*quads_2_J./USpop2013;
global P0; P0 = 7.e9 ;
Globaltotenergyuse2013= 524.; %Quads (IEA source)
global Globalpercapconsump2013; Globalpercapconsump2013= Globaltotenergyuse2013.*quads_2_J./P0;
global Cpop; Cpop = 54. ; %Population doubling time in years, assuming exponential growth (TODO: was this fitted to data?).

global present_year; present_year=2014.;
global emissions_to_date; emissions_to_date=.5; %historical emissions (Gt C) (TODO: make sure this is totally right (get emissions.nc from UVic model?)

