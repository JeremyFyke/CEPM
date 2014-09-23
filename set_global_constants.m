%Set run-time.
global t0; t0 = 0. ;               
global tf; tf = 1500 ;             
%Conversion constants

global bbl_2_gC; bbl_2_gC=              1.14e5 ; %gC/barrel
global kwh_2_J; kwh_2_J=                3.6e6  ; %J/kwh
global mwh_2_J; mwh_2_J=                3.6e9  ; %J/mwh
global g_2_Tt; g_2_Tt=1.e6.*1.e12;

%Per capita carbon demand doubling time (linear/constant if inf).
%Original per capita demand (modern global mean emissions are ~4 mt CO2 / person / year,
%which yields 4e6 * 12/44 = 1.1e6 gC/person/year modern
global Cpc; Cpc = 170. ; % (yr)
global rCpc; rCpc = 1./Cpc ;
%Original population (7e9 is roughly the 2000 pop)
global P0; P0 = 7.e9 ;
global Cpop; Cpop = 54. ; %Population doubling time in years, assuming exponential growth (TODO: was this fitted to data?).
global rCpop; rCpop = 1./Cpop ;

global present_year; present_year=2014.;
global emissions_to_date; emissions_to_date=.5; %historical emissions (Gt C) (TODO: make sure this is totally right (get emissions.nc from UVic model?)
global emissions2warming; emissions2warming=1.5; %mediam GtC to degrees C warming ratio (make this into a LHS variable?)

