global ffd0 Dff0

n=0;
nSource=1;
%%%%%%%%%%
n=n+1 ;
ParameterName{n}='Initial fossil fuel reservoir reserves'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$V_{ff_O}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iRogner_et_al_2012=nSource;
Reference{nSource}='Collins_et_al_2013';nSource=nSource+1;
lb(n)=1.002;
ub(n)=1.94;
v(n) = mean([lb(n) ub(n)]);

%%%%%%%%%%
n=n+1 ; 
ParameterName{n}='Maximum fossil fuel resources'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$V_{ff_{max}}$';
ParameterSource{n}=iRogner_et_al_2012;
lb(n)=2.535;
ub(n)=7.665; %From Rogner, tho these values are quoted from IPCC AR5 WG3 Ch7, and coal resources reduced by 80% according to Rogner arguement on practical availability
v(n) = mean([lb(n) ub(n)]);

%%%%%%%%%% 
n=n+1 ;  
ParameterName{n}='Initial fossil fuel cost'; 
ParameterUnits{n}='\$/bbl oil';
ParameterLatexSymbol{n}='$Pr_{ff_0}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iBP_review_2014=nSource;
Reference{nSource}='BP_statistical_review_2014';nSource=nSource+1;
v(n) = 90.;
lb(n)= 80.;
ub(n)= 110.;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Fossil energy emission factor trend'; 
ParameterUnits{n}='g C/J/yr';
ParameterLatexSymbol{n}='$T_{E_{ff}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iauthor_estimate=nSource;
Reference{nSource}='Author_estimate';nSource=nSource+1;
v(n) = 0.5e-7;
lb(n)= 0.0e-7;
ub(n)= 1.e-7;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Final fossil energy emission factor'; 
ParameterUnits{n}='g C/J';
ParameterLatexSymbol{n}='$E_{ff_f}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;%'http://www.ocean.washington.edu/courses/envir215/energynumbers.pdf'
[Dff0,~,~,ffd0] = calculate_historical_reserve_growth_rate();
lb(n)= gasEfactor;
ub(n)= coalEfactor; %g/J C, for coal
v(n)=ffd0;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Initial renewable unit cost'; 
ParameterUnits{n}='\$/MWh';
ParameterLatexSymbol{n}='$Pr_{nff_0}$ ';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iIEA_medium_term_market_report=nSource;
Reference{nSource}='IEA_medium_term_renewable_market_report_2014';nSource=nSource+1;
v(n) = 375.;
lb(n)= 250.;
ub(n)= 400.;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Minimum renewable unit cost'; 
ParameterUnits{n}='\% of initial cost';
ParameterLatexSymbol{n}='$Pr_{nff_{min}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
v(n) = 0.3;
lb(n)= 0.2;
ub(n)= 0.5;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Relative carbon tax ($>$1=tax, $<$1=subsidy)'; 
ParameterUnits{n}='\%';
ParameterLatexSymbol{n}='$S_{ff}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
v(n) = 1.;  
lb(n)= 0.8;
ub(n)= 1.2;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Rate of renewable cost decline';
ParameterUnits{n}='\$/MWh/yr';
ParameterLatexSymbol{n}='$T_{re}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iIEA_medium_term_market_report;%also: 'UofM Energy Institute Technical Paper "Renewable Energy Technology Review"';
v(n) = -3.;
lb(n)= -3.2;
ub(n)= -2.8;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Maximum population'; 
ParameterUnits{n}='Billion people';
ParameterLatexSymbol{n}='$P_{max}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iGerland_et_al_2014=nSource;
Reference{nSource}='Gerland_et_al_2014';nSource=nSource+1;
v(n) = 10.9;
lb(n)= 9.6;
ub(n)=12.3;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Population increase'; 
ParameterUnits{n}='\%/yr';
ParameterLatexSymbol{n}='$P_{inc}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iworld_bank=nSource;
Reference{nSource}='World_bank_data_2014';nSource=nSource+1;%'https://www.google.com/publicdata/explore?ds=d5bncppjof8f9_&ctype=l&strail=false&bcs=d&nselm=h&met_y=sp_pop_grow&scale_y=lin&ind_y=false&rdim=region&ifdim=region&tdim=true&hl=en&dl=en&ind=false';
v(n) = 0.015;
lb(n)= 0.01;
ub(n)= 0.02;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Maximum per-capita energy consumption'; 
ParameterUnits{n}='GJ/yr';
ParameterLatexSymbol{n}='$De_{{pc}_{max}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
v(n) = 3.2e11./1.e9 ;
lb(n)= 2.8e11./1.e9 ;
ub(n)= 3.6e11./1.e9 ;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Per-capita energy consumption increase'; 
ParameterUnits{n}='\%/yr';
ParameterLatexSymbol{n}='$De_{{pc}_{inc}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iIEA_data=nSource;
Reference{nSource}='EIA_data_2014';nSource=nSource+1;%'http://www.eia.gov/cfapps/ipdbproject/iedindex3.cfm?tid=44&pid=45&aid=2&cid=ww,&syid=1980&eyid=2011&unit=MBTUPP';
v(n) = 0.005 ;
lb(n)= 0.001 ;
ub(n)= 0.01 ;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Fossil fuel to renewables transfer delay';
ParameterUnits{n}='Unitless';
ParameterLatexSymbol{n}='$B$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
v(n) = 1.;
lb(n)=0.5;
ub(n)=1.5;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Fossil fuel to renewables transfer fade strength'; 
ParameterUnits{n}='Unitless';
ParameterLatexSymbol{n}='$C$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
v(n) = -5.; 
lb(n)=-6;
ub(n)=-4;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Ratio of cumulative emissions to net warming'; 
ParameterUnits{n}='$^\circ$C/Gt C';
ParameterLatexSymbol{n}='$TCRE$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iCollins_et_al_2013=nSource;
Reference{nSource}='Collins_et_al_2013';nSource=nSource+1;
v(n) = 1.5; 
lb(n)=0.8;
ub(n)=2.5;

%Convert data to Latex table
for nn=1:n
   ParamRange{nn}=strcat(num2str(lb(nn)),'-',num2str(ub(nn)),'$^',num2str(ParameterSource{nn}),'$');  %#ok<SAGROW>
end
data=[ParameterLatexSymbol',ParameterUnits',ParamRange'];
columnlabels={'Symbol','Units','Range'};

!rm *.tex
matrix2latex(data, 'paramtable.tex','rowLabels',ParameterName,'columnLabels',columnlabels,'alignment','c','size','tiny')
fileID = fopen('paramtable_caption.tex','w');
caption=fprintf(fileID,'\\caption{Table of parameters varied during latin hypercube sampling-based ensemble.  Values determined from following sources:  1: \\cite{%s}; 2: \\cite{%s}; 3: \\cite{%s}; 4: \\cite{%s}; 5: \\cite{%s}; 6: \\cite{%s}; 7: \\cite{%s}; 8: \\cite{%s}.\\label{table:free_parameters}}',Reference{1},Reference{2},Reference{3},Reference{4},Reference{5},Reference{6},Reference{7},Reference{8});
