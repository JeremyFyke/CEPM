%     Cumulative Emissions Projection Model (CEPM).
%     Copyright (C) 2015 Jeremy Fyke (fyke@lanl.gov)
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

function [mean_discovery,min_discovery,max_discovery,average_emission_factor]=calculate_historical_reserve_growth_rate(c)

%This function returns:
%
%mean_discovery: the mean historical rate of discovery of fossil fuels, in
%units of Tt C
%
%min_discovery: mean historical rate of discovery, minus standard deviation
%max_discovery: mean historical rate of discovery, plus standard deviation
%
%average_emission_factor: average emission factor of fossil fuel supply, in
%units of %g C/J

clear *reserves
f='data/BP-Statistical_Review_of_world_energy_2014_workbook.xlsx';
year=xlsread(f,'Oil_Proved_reserves_history','B3:AI3');

doil_reserves=diff(xlsread(f,'Oil_Proved_reserves_history','B71:AI71')).*c.bill; %original units: billion barrels
oil_production=xlsread(f,'Oil_Production_Barrels','R71:AX71').*365.*c.thou; %original units: thousand barrels/day
oil_discovery=(doil_reserves+oil_production).*c.bbl_2_gC;

dgas_reserves=diff(xlsread(f,'Gas - Proved reserves history','B72:AI71')).*c.tril; %original units: trillion cubic meters
gas_production=xlsread(f,'Gas_Production_Bcm','M71:AS71').*c.bill; %original units: billions cubic meters
gas_discovery=(dgas_reserves+gas_production).*c.scm_2_gC;

coal_reserves(1)=1039181;%1993, original units: Million tons, source: http://www.bp.com/content/dam/bp/pdf/Energy-economics/statistical-review-2014/BP-statistical-review-of-world-energy-2014-full-report.pdf
coal_reserves(2)=984453.;%2003
coal_reserves(3)=891531.;%2013
dcoal_reserves=diff(interp1([1993 2003 2013],coal_reserves,year,'linear','extrap')).*c.mill; %
coal_production=xlsread(f,'Coal_Production_Tonnes','B53:AH53').*c.mill; %original units: Million tons
coal_discovery=(dcoal_reserves+coal_production).*c.t_coal_2_gC;

total_discovery=(oil_discovery+gas_discovery+coal_discovery);
total_discovery=total_discovery./c.g_2_Tt;
mean_discovery=mean(total_discovery);

linear_discovery_rate=polyfit(1:length(total_discovery),total_discovery,1);
disp(['Mean observed rate of fossil fuel discovery (%/yr)=',num2str(linear_discovery_rate./mean_discovery*100.)])

std_disc=std(total_discovery);
min_discovery=mean_discovery-std_disc;
max_discovery=mean_discovery+std_disc;
oil_production=oil_production.*c.bbl_2_gC;
gas_production=gas_production.*c.scm_2_gC;
coal_production=coal_production.*c.t_coal_2_gC;
total_production=oil_production+gas_production+coal_production;
foil_production = oil_production/total_production;
fgas_production = gas_production/total_production;
fcoal_production= coal_production/total_production;

average_emission_factor=c.coalEfactor.*fcoal_production + c.oilEfactor.*foil_production + c.gasEfactor.*fgas_production;

%bar([oil_discovery' gas_discovery' coal_discovery'],'stacked')
%legend({'oil' 'gas' 'coal'})

return
end
