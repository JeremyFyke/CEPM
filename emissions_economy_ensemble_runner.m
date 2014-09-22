%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all

set_global_constants

%Set ensemble size
ensemble_size = 4000 ;
generate_parameter_ranges;

%generate parameter arrays
disp('Generating Latin Hypercube...')
xn = lhsdesign(ensemble_size,n);
model_parameters = bsxfun(@plus,lb,bsxfun(@times,xn,(ub-lb)));
tic
for n=1:ensemble_size
    disp(['Running ensemble number' num2str(n)])
    so(n) = emissions_economy(model_parameters(n,:));   
end
toc
generate_diagnostics
