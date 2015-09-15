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

function [so] = initialize_output_structure(c)

so(c.ensemble_size)=struct();

so(1).LHSparams=[];
so(1).time=[];
so(1).ff_volume=[];
so(1).event_times=[];
so(1).solution_values=[];
so(1).which_event=[];
so(1).dVdt=[];
so(1).burn_rate=[];
so(1).ff_emission_factor=[];
so(1).ff_pr=[];
so(1).re_pr=[];
so(1).ff_fraction=[];
so(1).tot_en_demand=[];
so(1).pop=[];
so(1).per_cap_dem=[];
so(1).discovery_rate=[];
so(1).carbon_tax=[];
so(1).burn_rate_max=[];
so(1).cum_emissions=[];
so(1).tot_emissions=[];
so(1).TCRE_damper=[];
so(1).TCRE_orig=[];
so(1).net_warming=[];
so(1).consumption_init=[];
so(1).dconsumptiondt_init=[];
so(1).burn_rate_init=[];
so(1).ff_fraction_init=[];
so(1).ff_fractional_reservoir_depletion=[];
so(1).t_cross_over=[];
so(1).t_fossil_fuel_emissions_stop=[];
so(1).t_total_depletion=[];
