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

function [so] = initialize_output_structure(c)

so(c.ensemble_size)=struct();

so(1).LHSparams                        =[];
so(1).time                             =single([]);
so(1).ff_volume                        =single([]);
so(1).event_times                      =[];
so(1).solution_values                  =[];
so(1).which_event                      =[];
so(1).dVdt                             =single([]);
so(1).burn_rate                        =single([]);  
so(1).ff_emission_factor               =single([]);
so(1).ff_pr                            =single([]);
so(1).re_pr                            =single([]);
so(1).ff_fraction                      =single([]);
so(1).tot_en_demand                    =single([]);
so(1).pop                              =single([]);
so(1).per_cap_dem                      =single([]);
so(1).discovery_rate                   =single([]);
so(1).carbon_tax                       =single([]);
so(1).burn_rate_max                    =single([]);
so(1).cum_emissions                    =single([]);
so(1).tot_emissions                    =single([]);
so(1).TCRE_damper                      =single([]);
so(1).TCRE_orig                        =single([]);
so(1).net_warming                      =single([]);
so(1).consumption_init                 =single([]);
so(1).dconsumptiondt_init              =single([]);
so(1).burn_rate_init                   =single([]);
so(1).ff_fraction_init                 =single([]);
so(1).ff_fractional_reservoir_depletion=single([]);
so(1).t_cross_over                     =[];
so(1).t_fossil_fuel_emissions_stop     =[];
so(1).t_total_depletion                =[];
