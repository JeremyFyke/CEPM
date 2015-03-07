
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
ensemble_size = 1000 ;

%generate parameter arrays
generate_parameter_ranges;
disp('Generating Latin Hypercube...')

mu=mean([ub' lb'],2);
sigma=((ub'-lb')./4).^2;
model_parameters=lhsnorm(mu,diag(sigma),ensemble_size);

for n=1:size(model_parameters,2)
    tmp=model_parameters(:,n);
    xn(:,n) = (tmp-min(tmp)) ./ (max(tmp)-min(tmp));
end

%run ensemble
for n=1:ensemble_size
    
    warning('')
    disp(['Running ensemble number' num2str(n)])
    model_output = emissions_economy(model_parameters(n,:));
    try
        so(n) = model_output;
    catch
        for n=1:size(model_parameters,2)
            if model_output.LHSparams(n) < lb(n) || model_output.LHSparams(n) > ub(n)
                
                decorator='    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
            else
                decorator='_______________________________'       
            end
            disp(decorator)
            disp(['LHS parameter=' num2str(model_output.LHSparams(n))])
            disp(['Minimum input value=' num2str(lb(n))])
            disp(['Maximum input value=' num2str(ub(n))])
            disp(decorator)
        end
        error('Error in emissions economy output.')
    end
end

%make pretty pictures
close all
generate_projection_output

%save output for later
save output
