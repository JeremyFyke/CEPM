
%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all

ensemble_size = 20000 ;

set_global_constants

%make figures and output directories, if they doesn't exist.
if ~exist('figs','dir')
    [~,~,~] = mkdir('figs');
end
if ~exist('./output','dir')
   [~,~,~]=mkdir('output');
end

generate_parameter_ranges;

initialize_output_structure;

for n=1:ensemble_size
    
    warning('')
    if ( mod(n,2)-1 )==0
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

generate_projection_output

%save output for later

save output/output

toc
