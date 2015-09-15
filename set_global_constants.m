%     Cumulative Emissions Projection Model (CEPM).
%     Copyright (C) 2015 Jeremy Fyke
%   
%     This file is part of CEPM.
% 
%     CEPM is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     CEPM is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CEPM.  If not, see <http://www.gnu.org/licenses/>.

function [c] = set_global_constants()

c.ensemble_size=100000;

%Set run-time.
c.t0 = 0. ;               
c.tf = 4000 ; 

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
data=xlsread('data/Total_Primary_Energy_Consumption_(Quadrillion_Btu).xls');%http://www.eia.gov/cfapps/ipdbproject/IEDIndex3.cfm?tid=44&pid=44&aid=2

c.start_year=2012;

if c.start_year==1980
    c.n_validation_years=2012-c.start_year;
    c.ff_frac0=0.77; %Initial fraction of global energy consumption supplied by fossil energies %HOW WAS THIS CALCULATED?
    c.Globaltotenergyuseinit=data(3,end-c.n_validation_years).*c.quads_2_J;
    c.P0 = 4.86e9;%World Bank
    c.emissions_to_date=.19; %historical ff emissions (Tt C, year 2012); Source: RCP data
elseif c.start_year==2012
    c.ff_frac0=0.80; %Initial fraction of global energy consumption supplied by fossil energies
    c.Globaltotenergyuseinit=data(3,end-1).*c.quads_2_J;
    c.P0 = 7.2e9 ;%World Bank
    c.emissions_to_date=.38; %historical ff emissions (Tt C, year 2012); Source: RCP data
else
    error('Model not configured to use given syear.')
end

c.GlobalpercapconsumpInit= c.Globaltotenergyuseinit./c.P0;
c.coalEfactor =2.58e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
c.oilEfactor   =2.0e-5;   %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf
c.gasEfactor   =1.53e-5;  %g C/j http://www.ipcc-nggip.iges.or.jp/public/gl/guidelin/ch1ref2.pdf

c.cprice0=-60; %$/ton C, Based on -15$/ton C02 subsidy value supplied by Gernot Wagner

c.CE_TCRE_saturation_point=3.; %(Tc C): Emissions above which TCRE gets lower
c.TCRE_dampening_factor=0.05;  %

c.energy_fraction=0.05;

c.events.energy_prices_match=1;
c.events.trivial_ff_energy_fraction=2;
c.events.total_ff_depletion=3;

c.simulation_timestamp=datestr(now,30);