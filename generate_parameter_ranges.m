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
n=n+1 ;
p(n).ParameterName='Init fossil fuel reserves'; 
p(n).ParameterUnits='Tt C';
p(n).ParameterLatexSymbol='$V_{ff}(0)$';
p(n).ParameterSource=nSource;
iRogner_et_al_2012=nSource;
Reference{nSource}='Rogner_et_al_2012';nSource=nSource+1;
p(n).lb=1.002;
p(n).ub=1.94;

%%%%%%%%%%
n=n+1 ; 
p(n).ParameterName='Max fossil fuel resources'; 
p(n).ParameterUnits='Tt C';
p(n).ParameterLatexSymbol='$V_{ff_{max}}$';
p(n).ParameterSource=iRogner_et_al_2012;
p(n).lb=2.535;
p(n).ub=7.665; 
%p(n).lb=2.535+.2;
%p(n).ub=7.665+.2; 
%From Rogner, tho these values are quoted from IPCC AR5 WG3 Ch7, and coal
%resources reduced by 80% according to Rogner arguement on practical availability.
%Add 0.2 teratonnes if accounting for a 1985 start.

%%%%%%%%%% 
n=n+1 ;  
p(n).ParameterName='Init fossil fuel cost'; 
p(n).ParameterUnits='\$/brl oil';
p(n).ParameterLatexSymbol='$Pr_{ff}(0)$';
p(n).ParameterSource=nSource;
iBP_review_2014=nSource;
Reference{nSource}='BP_statistical_review_2014';nSource=nSource+1;
p(n).lb= 50.;
p(n).ub= 100.;

%%%%%%%%%% 
n=n+1 ; 
p(n).ParameterName='Fossil energy emission factor trend'; 
p(n).ParameterUnits='g C/J/yr';
p(n).ParameterLatexSymbol='$T_{E_{ff}}$';
p(n).ParameterSource=nSource;
iauthor_estimate=nSource;
Reference{nSource}='Author_estimate';nSource=nSource+1;
p(n).lb= 0.6e-7;
p(n).ub= 1.e-7;

%%%%%%%%%% 
n=n+1 ; 
p(n).ParameterName='Final fossil energy emission factor'; 
p(n).ParameterUnits='g C/J';
p(n).ParameterLatexSymbol='$E_{ff_f}$';
p(n).ParameterSource=iauthor_estimate;%'http://www.ocean.washington.edu/courses/envir215/energynumbers.pdf'
[c.Dff0,~,~,c.ffef0] = calculate_historical_reserve_growth_rate(c);
p(n).lb= c.gasEfactor; %g C/J
p(n).ub= c.coalEfactor; %g C/J

%%%%%%%%%% 
n=n+1 ; 
p(n).ParameterName='Init non-fossil energy unit cost'; 
p(n).ParameterUnits='\$/MWh';
p(n).ParameterLatexSymbol='$Pr_{nff}(0)$ ';
p(n).ParameterSource=nSource;
iIEA_medium_term_market_report=nSource;
Reference{nSource}='IEA_medium_term_renewable_market_report_2014';nSource=nSource+1;
p(n).lb= 300.;
p(n).ub= 500.;

%%%%%%%%%% 
n=n+1 ; 
p(n).ParameterName='Min non-fossil energy unit cost'; 
p(n).ParameterUnits='Fraction of initial cost';
p(n).ParameterLatexSymbol='$Pr_{nff_{min}}$';
p(n).ParameterSource=iauthor_estimate;
p(n).lb= 0.1;
p(n).ub= 0.3;

%%%%%%%%%% 
n=n+1 ; 
p(n).ParameterName='Max carbon price'; 
p(n).ParameterUnits='\$/tonne C';
p(n).ParameterLatexSymbol='$S_{ff_{max}}$';
p(n).ParameterSource=nSource;
iLontzek=nSource;
Reference{nSource}='Lontzek_et_al_2015';nSource=nSource+1;
p(n).lb= c.cprice0; 
p(n).ub= 650.;

%%%%%%%%%% 
n=n+1 ; 
p(n).ParameterName='Carbon price trend'; 
p(n).ParameterUnits='\$/tonne C/yr';
p(n).ParameterLatexSymbol='$T_{S_{ff}}$';
p(n).ParameterSource=iLontzek;
p(n).lb= 5.;
p(n).ub= 10.;

%%%%%%%%%% 
n=n+1 ; 
p(n).ParameterName='Non-fossil cost decline e-folding time';
p(n).ParameterUnits='Yr';
p(n).ParameterLatexSymbol='$T_{nff}$';
p(n).ParameterSource=iIEA_medium_term_market_report;%also: 'UofM Energy Institute Technical Paper "Renewable Energy Technology Review"';
p(n).lb= 10;
p(n).ub= 20;

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

%%%%%%%%%% 
n=n+1; 
p(n).ParameterName='Max per-capita energy consumption'; %Ranges between Euro and NA energy consumption
p(n).ParameterUnits='GJ/yr';
p(n).ParameterLatexSymbol='$De_{{pc}_{max}}$';
p(n).ParameterSource=nSource;
iIEA_data=nSource;
Reference{nSource}='EIA_online';nSource=nSource+1;%'http://www.eia.gov/cfapps/ipdbproject/iedindex3.cfm?tid=44&pid=45&aid=2&cid=ww,&syid=1980&eyid=2011&unit=MBTUPP';
p(n).lb= 133.e6*1055./c.bill ;
p(n).ub= 254.e6*1055./c.bill ;

%%%%%%%%%% 
n=n+1; 
p(n).ParameterName='Per-capita energy consumption increase'; 
p(n).ParameterUnits='\%/yr';
p(n).ParameterLatexSymbol='$De_{pc_{inc}}$';
p(n).ParameterSource=iIEA_data;
p(n).lb= 0.006 ;
p(n).ub= 0.015 ;

%%%%%%%%%% 
n=n+1; 
p(n).ParameterName='Fossil/non-fossil energy transfer delay';
p(n).ParameterUnits='Unitless';
p(n).ParameterLatexSymbol='$B$';
p(n).ParameterSource=iauthor_estimate;
p(n).lb=0.2;
p(n).ub=1.;

%%%%%%%%%% 
n=n+1; 
p(n).ParameterName='Fossil/non-fossil energy transfer fade strength'; 
p(n).ParameterUnits='Unitless';
p(n).ParameterLatexSymbol='$C$';
p(n).ParameterSource=iauthor_estimate;
p(n).lb=-6;
p(n).ub=-4;

%%%%%%%%%% 
n=n+1; 
p(n).ParameterName='Transient climate response to emissions'; 
p(n).ParameterUnits='$^\circ$C/Tt C';
p(n).ParameterLatexSymbol='$TCRE$';
p(n).ParameterSource=nSource;
iCollins_et_al_2013=nSource;
Reference{nSource}='Collins_et_al_2013';nSource=nSource+1;
p(n).lb=0.8;
p(n).ub=2.5;

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
