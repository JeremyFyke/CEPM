%% Convert input parameter data to Latex table

%Round for clean presentation
mu_rounded=spa_sf(mu,2);
sigma_rounded=spa_sf(sigma,2);
for nn=1:n
   ParamRange{nn}=strcat(num2str(mu_rounded(nn)),'/',num2str(sigma_rounded(nn)),'$^',num2str(ParameterSource{nn}),'$');
end

data=[ParameterLatexSymbol',ParameterUnits',ParamRange'];
columnlabels={'Symbol','Units','Mean/$\sigma$'};

if exist('./paramtable.tex')  
    delete *.tex
end

%Generate latex table
matrix2latex(data, 'paramtable.tex','rowLabels',ParameterName,'columnLabels',columnlabels,'alignment','c','size','tiny')

%Generate latex table caption (catting together reference indexes and
%reference names.
fileID = fopen('paramtable_caption.tex','w');
Refstring='';
%add on references to refstring with each loop index step.  On last one,
%use period instead of semi-colon.
for ref=1:length(Reference)
    if ref<length(Reference)
        Refstring=sprintf('%s %d: \\cite{%s}; ',Refstring,ref,Reference{ref});
    else
        Refstring=sprintf('%s %d: \\cite{%s}.',Refstring,ref,Reference{ref});
    end
end

Refstring = sprintf('Uncertain parameters, and parameter mean/standard deviation values, varied in the course of the ensemble of simulations.  Sources for parameter ranges are as follows: %s',Refstring);
[~]=fprintf(fileID,'%s\\label{table:free_parameters}',Refstring);

clear mu_rounded sigma_rounded ParamRange data columnlabels fileID caption
