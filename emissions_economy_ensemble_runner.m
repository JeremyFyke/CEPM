
%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all

%make figures and output directories, if they doesn't exist.
if ~exist('figs','dir')
    [~,~,~] = mkdir('figs');
end
if ~exist('./output','dir')
   [~,~,~]=mkdir('output');
end

c=set_global_constants();
[model_parameters,c,p]=generate_parameter_ranges(c);
so =initialize_output_structure(c);

for n=1:c.ensemble_size 
    warning('')
    if ( mod(n,2)-1 )==0
      tic
      disp(['Running ensemble number' num2str(n)])
    end
    model_output = emissions_economy(c,model_parameters(n,:));
    try
        so(n) = model_output;
    catch
        for nn=1:size(model_parameters,2)
            disp('')
            if model_output.LHSparams(nn) < lb(nn) || model_output.LHSparams(n) > ub(nn)

                decorator='    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
            else
                decorator='_______________________________';     
            end
            disp(decorator)
            disp(['LHS parameter=' num2str(model_output.LHSparams(nn))])
            disp(['LHS parameter name=' ParameterName{nn}])            
            disp(['Minimum input value=' num2str(lb(nn))])
            disp(['Maximum input value=' num2str(ub(nn))])
            disp(['Parameter number=',num2str(nn)])
        end
        error('Error in emissions economy output.')
    end
end

%make pretty pictures
generate_projection_output

%save output for later
save output/output

