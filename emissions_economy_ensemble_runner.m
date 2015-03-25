
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
ensemble_size = 10000 ;

%generate parameter arrays
generate_parameter_ranges;
disp('Generating Latin Hypercube...')

%Define a vector of median values, for each parameter
mu=mean([ub' lb'],2);
%Extract standard deviation from the spread between the upper and lower
%bounds, assuming these bounds represent +/- 2-sigma (i.e. ~95%).
%Then, square standard deviation to obtain covariance.

sigma=((ub'-lb')./4).^2;

model_parameters=lhsnorm(mu,diag(sigma),ensemble_size);

% for n=1:size(model_parameters,2)
%     figure
%     x=linspace(lb(n),ub(n),100);
%     norm=normpdf(x,mu(n),sigma(n));
%     plot(x,norm)
%     title(ParameterName{n})
%     xlabel(strcat(' lb=',num2str(lb(n)),...
%                   ' ub=',num2str(ub(n)),...
%                   ' mu=',num2str(mu(n)),...
%                   ' sigma=',num2str(sigma(n))))
% end


for n=1:size(model_parameters,2)
    tmp=model_parameters(:,n);
    xn(:,n) = (tmp-min(tmp)) ./ (max(tmp)-min(tmp));
end

%Run ensemble
output_initialization
tic
for n=1:ensemble_size
    
    warning('')
    if mod(n,50)==0
      toc
      tic
      disp(['Running ensemble number' num2str(n)])
    end
    model_output = emissions_economy(model_parameters(n,:));
    try
        so(n) = model_output;
    catch
        for n=1:size(model_parameters,2)
            disp('')
            if model_output.LHSparams(n) < lb(n) || model_output.LHSparams(n) > ub(n)
                
                decorator='    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
            else
                decorator='_______________________________';     
            end
            disp(decorator)
            disp(['LHS parameter=' num2str(model_output.LHSparams(n))])
            disp(['LHS parameter name=' ParameterName{n}])            
            disp(['Minimum input value=' num2str(lb(n))])
            disp(['Maximum input value=' num2str(ub(n))])
            disp(['Parameter number=',num2str(n)])
        end
        error('Error in emissions economy output.')
    end
end

%make pretty pictures
close all
generate_projection_output

%save output for later
save output
toc