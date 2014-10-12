function [new_discovery_rate]=calculate_historical_reserve_growth_rate()
set_global_constants
clear *reserves
f='data/BP-Statistical_Review_of_world_energy_2014_workbook.xlsx';
year=xlsread(f,'Oil_Proved_reserves_history','B3:AI3');
oil_reserves=xlsread(f,'Oil_Proved_reserves_history','B71:AI71'); %units of billion barrels
    oil_reserves=oil_reserves.*10.e9.*bbl_2_gC;
gas_reserves=xlsread(f,'Gas - Proved reserves history','B72:AI71'); %units of tcf
    gas_reserves=gas_reserves.*1.e12.*scf_2_gC;
coal_reserves(1)=1039181;%1993, Million tons, source: http://www.bp.com/content/dam/bp/pdf/Energy-economics/statistical-review-2014/BP-statistical-review-of-world-energy-2014-full-report.pdf
coal_reserves(2)=984453.;%2003
coal_reserves(3)=891531.;%2013
    coal_reserves=interp1([1993 2003 2013],coal_reserves,year,'linear','extrap').*1.e6.*t_coal_2_gC; %  
hold on
plot(oil_reserves)
plot(gas_reserves)
plot(coal_reserves)
total_reserve=oil_reserves+gas_reserves+coal_reserves;
p = polyfit(year,total_reserve,1);
new_discovery_rate = p(1)./g_2_Tt; %Finally, convert to Teratons C/yr
return
end

%TODO: 
%1. SUBTRACT CONSUMPTION RATE OFF THESE VALUES, TO DETERMINE PURE
%'DISCOVERY' RATE- SHOULD BE HIGHER.
%2. DOUBLE-CHECK: new_discovery_rate SEEMS LOW... but maybe because this is only proved reserves, and not estimate resources?