%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all

set_global_constants

%Set ensemble size

ensemble_size = 20 ;

generate_parameter_ranges;

%generate parameter arrays
disp('Generating Latin Hypercube...')
xn = lhsdesign(ensemble_size,n);
model_parameters = bsxfun(@plus,lb,bsxfun(@times,xn,(ub-lb)));

for n=1:ensemble_size
    disp(['Running ensemble number' num2str(n)])
    model_output = emissions_economy(model_parameters(n,:)); 
    so(n) = model_output;   
end

%sort ensemble members by total emissions
[sorted_total_emissions,itotcumranking]=sort([so.tot_emissions]);
so=so(itotcumranking);

%To do: add minimum renewables price as LHS var.

close all
%generate_diagnostics
generate_projection_output

save output so
