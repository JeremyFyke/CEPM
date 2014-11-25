function [mean_discovery,min_discovery,max_discovery,average_energy_density]=calculate_historical_reserve_growth_rate()

set_global_constants

clear *reserves
f='data/BP-Statistical_Review_of_world_energy_2014_workbook.xlsx';
year=xlsread(f,'Oil_Proved_reserves_history','B3:AI3');

doil_reserves=diff(xlsread(f,'Oil_Proved_reserves_history','B71:AI71')).*1.e9; %original units: billion barrels
oil_production=xlsread(f,'Oil_Production_Barrels','R71:AX71').*365.*1.e3; %original units: thousand barrels/day
oil_discovery=(doil_reserves+oil_production).*bbl_2_gC;

dgas_reserves=diff(xlsread(f,'Gas - Proved reserves history','B72:AI71')).*1.e12; %original units: trillion cubic meters
gas_production=xlsread(f,'Gas_Production_Bcm','M71:AS71').*1.e9; %original units: billions cubic meters
gas_discovery=(dgas_reserves+gas_production).*scm_2_gC;

coal_reserves(1)=1039181;%1993, original units: Million tons, source: http://www.bp.com/content/dam/bp/pdf/Energy-economics/statistical-review-2014/BP-statistical-review-of-world-energy-2014-full-report.pdf
coal_reserves(2)=984453.;%2003
coal_reserves(3)=891531.;%2013
dcoal_reserves=diff(interp1([1993 2003 2013],coal_reserves,year,'linear','extrap')).*1.e6; %
coal_production=xlsread(f,'Coal_Production_Tonnes','B53:AH53').*1.e6; %original units: Million tons
coal_discovery=(dcoal_reserves+coal_production).*t_coal_2_gC;

total_discovery=(oil_discovery+gas_discovery+coal_discovery);
total_discovery=total_discovery./g_2_Tt;
mean_discovery=mean(total_discovery); 
min_discovery=min(total_discovery); 
max_discovery=max(total_discovery);

oil_production=oil_production.*bbl_2_gC;
gas_production=gas_production.*scm_2_gC;
coal_production=coal_production.*t_coal_2_gC;

total_production=oil_production+gas_production+coal_production;
foil_production = oil_production/total_production;
fgas_production = gas_production/total_production;
fcoal_production= coal_production/total_production;

%energy density values from http://www.ocean.washington.edu/courses/envir215/energynumbers.pdf
average_energy_density=coalEdensity.*fcoal_production + oilEdensity.*foil_production + gasEdensity.*fgas_production;

%bar([oil_discovery' gas_discovery' coal_discovery'],'stacked')
%legend({'oil' 'gas' 'coal'})

return
end