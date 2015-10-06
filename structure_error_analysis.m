%% Compare model_output structure with initialized structure.

initialized_fields=fieldnames(ensemble_output);
output_fields=fieldnames(model_output);
for f=1:length(initialized_fields)
    %Check for missing fields in model output.
    if ~isfield(model_output,initialized_fields{f})
        error(sprintf('Field name %s is not in output_fields, but it exists in initialized_output.',initialized_fields{f}));
    end
end
for f=1:length(output_fields)
    %Check for missing fields in initialized output.
    if ~isfield(initialized_fields,output_fields{f})
        error(sprintf('Field name %s is not in initialized_output, but it exists in output_fields.',output_fields{f}));
    end
end
for f=1:length(output_fields)
    %Check for unexpected order.
    if ~strcmp(output_fields{n},initialized_fields{n})
        error('output_fields does not appear to be in the same order as initialized_fields')
    end
end

%% Compare ensemble LHS values against prescribed standard deviation ranges.
for nn=1:size(model_parameters,2)
    disp('')
    if model_output.LHSparams(nn) < p(nn).lb || model_output.LHSparams(nn) > p(nn).ub
        
        decorator='    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
        initspace='    ';
    else
        decorator='_______________________________';
        initspace='';
    end
    disp(decorator)
    disp([initspace 'LHS parameter=' num2str(model_output.LHSparams(nn))])
    disp([initspace 'LHS parameter name=' p(nn).ParameterName])
    disp([initspace 'Minimum input value=' num2str(p(nn).lb)])
    disp([initspace 'Maximum input value=' num2str(p(nn).ub)])
    disp([initspace 'Parameter number=',num2str(nn)])
end

error('Error in emissions economy output.')