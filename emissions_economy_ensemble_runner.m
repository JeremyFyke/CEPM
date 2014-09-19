%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all

set_global_constants

%Set ensemble size
n_samples = 1000 ;
generate_parameter_ranges;

%generate parameter arrays
disp('Generating Latin Hypercube...')
xn = lhsdesign(n_samples,n);
x = bsxfun(@plus,lb,bsxfun(@times,xn,(ub-lb)));

initialize_matrices

for n=1:n_samples
    disp(['Running ensemble number' num2str(n)])
    [time{n},...
        ff_volume{n},...
        event_times{n},...
        solution_values{n},...
        which_event{n},...
        dVdt{n},...
        burn_rate{n},...
        ff_fraction{n},...
        ff_pr{n},...
        re_pr{n}]...
        = energy(x(n,:));
        
        emissions{n}=burn_rate{n}.* J_2_gC ./ 1.e18 ;
        cum_emissions{n}=cumsum(emissions{n}) + emissions_to_date;
        event_times{n}=event_times{n} + present_year;
        tot_emissions(n)=cum_emissions{n}(end);
        
end

generate_diagnostics
