%     Cumulative Emissions Projection Model (CEPM).
%     Copyright (C) 2015 Jeremy Fyke (fyke@lanl.gov)
%   
%     This file is part of CEPM.
% 
%     CEPM is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     CEPM is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CEPM.  If not, see <http://www.gnu.org/licenses/>.

function [model_parameters,c,p] = generate_parameter_ranges(c)

disp('Generating parameter sets...')
n=0;
nSource=1;

%%%%%%%%%% 
n=n+1; 
p(n).ParameterName='Max population'; 
p(n).ParameterUnits='Billion people';
p(n).ParameterLatexSymbol='$P_{max}$';
p(n).ParameterSource=nSource;
iGerland_et_al_2014=nSource;
Reference{nSource}='Gerland_et_al_2014';nSource=nSource+1;
p(n).lb= 9.6;
p(n).ub=12.3;

%%%%%%%%%% 
n=n+1; 
p(n).ParameterName='Population increase rate'; 
p(n).ParameterUnits='\%/yr';
p(n).ParameterLatexSymbol='$P_{inc}$';
p(n).ParameterSource=nSource;
iworld_bank=nSource;
Reference{nSource}='World_bank_data_2014';nSource=nSource+1;%'https://www.google.com/publicdata/explore?ds=d5bncppjof8f9_&ctype=l&strail=false&bcs=d&nselm=h&met_y=sp_pop_grow&scale_y=lin&ind_y=false&rdim=region&ifdim=region&tdim=true&hl=en&dl=en&ind=false';
p(n).lb= 0.015;
p(n).ub= 0.023;

%% Generate model parameters

%First: define a vector of median values, for each parameter
mu=mean([[p.ub]' [p.lb]'],2);
%Next: extract standard deviation from the spread between the upper and lower
%bounds, assuming these bounds represent +/- 2-sigma (i.e. ~95%).
sigma=(([p.ub]'-[p.lb]')./4);
%Next: calculate covariance, as the squared of sigma
covariance=sigma.^2;
%Finally: generate model parameter sets, with each parameter varied
%according to an LHS sampling of parameter distributions.
model_parameters=lhsnorm(mu,diag(covariance),c.ensemble_size);

%% Convert input parameter data to Latex table

%Round for clean presentation
mu_rounded=round(mu,2);
sigma_rounded=round(sigma,2);
for nn=1:n
   p(nn).ParamRangeString=strcat(num2str(mu_rounded(nn)),'/',num2str(sigma_rounded(nn)),'$^',num2str(p(nn).ParameterSource),'$');
end

data=[{p.ParameterLatexSymbol}',{p.ParameterUnits}',{p.ParamRangeString}'];
columnlabels={'Symbol','Units','Mean/$\sigma$'};

if exist('./paramtable.tex')  
    delete ./paramtable.tex
end

%Generate latex table
matrix2latex(data, 'paramtable.tex','rowLabels',{p.ParameterName},'columnLabels',columnlabels,'alignment','c','size','tiny')

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

%% Create pdf plots of all parameter distributions

% for n=1:size(model_parameters,2)
%     figure
%     set(gcf,'Visible','Off')
%     hist(squeeze(model_parameters(:,n)),100)
%     axis tight
%     title(sprintf('%s (%s)',p(n).ParameterName,p(n).ParameterUnits),'interpreter','latex')
%     xlabel(strcat('Mean=',num2str(mu(n)),...
%                   ' Standard deviation=',num2str(sigma(n))))
%     print('-depsc2',strcat('figs/',p(n).ParameterName,'_distribution'))
% end

% disp('Parameter ranges plotted to file.')
