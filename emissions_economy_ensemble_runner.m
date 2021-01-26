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
%     along with CEPM.  If not, see <http://www.gnu.org/licenses/

%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all


    disp('Checking for necessary files and setting up output directories.')
check_for_needed_inputs;

    disp('Setting global constant valus in structure c.')
c=set_global_constants();
    disp('Generating parameter ranges in model_parameter array.')
[model_parameters,c,p]=generate_parameter_ranges(c);
    disp('Initializing output structure ensemble_output.')
ensemble_output =initialize_output_structure(c);

%openpool(12)
%parfor n=1:c.ensemble_size 

for n=1:c.ensemble_size 
    lastwarn('')
    if ( mod(n,10) )==0
      disp(['Running ensemble number' num2str(n) '.'])
    end
    
    %examine model output for strange but non-fatal behaviour here.
    %-discontinuous curves
    %runaway emissions
    %cumulative emissions of more than available
    %...?
    
    %%%%%%%%%%%%%%%%%%%%RUN MODEL%%%%%%%%%%%%%%%%%%%%%%%%
    model_output = emissions_economy(c,model_parameters(n,:));
    %%%%%%%%%%%%%%%END RUN MODEL%%%%%%%%%%%%%%%%%%%%%%%%%
    try
        %Assign output from ensemble member to output structure.
        ensemble_output(n) = model_output;
    catch
        %Try to diagnose source of error causing non-similar structures.
        structure_error_analysis   
    end
end

disp('Done')

%make pretty pictures
generate_projection_output

%save output for later
if c.start_year<2000.
    save('output/historical_validation_output','-v7.3')
else
    save('output/future_projection_output','-v7.3')
end
