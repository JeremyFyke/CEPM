
%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all

set_global_constants

%make output directory, if it doesn't exist.
if ~exist('figs','dir')
    [~,~,~] = mkdir('figs');
end

%Set ensemble size
ensemble_size = 100 ;

%generate parameter arrays
generate_parameter_ranges;
disp('Generating Latin Hypercube...')
xn = lhsdesign(ensemble_size,n);
model_parameters = bsxfun(@plus,lb,bsxfun(@times,xn,(ub-lb)));

%run ensemble
for n=1:ensemble_size
    disp(['Running ensemble number' num2str(n)])
    model_output = emissions_economy(model_parameters(n,:)); 
    so(n) = model_output;   
end

%make pretty pictures
close all
generate_projection_output

%save output for later
save output
