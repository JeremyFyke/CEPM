global ffd0

n=0;
nSource=1;
%%%%%%%%%%
n=n+1 ; 
iV0 = n; 
ParameterName{n}='Initial fossil fuel reservoir volume'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$V_{ff_O}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;
iRogner_et_al_2012=nSource;
[lb(n),ub(n),tmp1,tmp2]=GEA_ff_reserves_and_resources();
v(n) = mean([lb(n) ub(n)]);
%%%%%%%%%%
n=n+1 ; 
iVmax = n; 
ParameterName{n}='Maximum remaining fossil fuel reservoir volume'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$V_{ff_max}$';
ParameterSource{n}=nSource;nSource=nSource+1;
iRogner_1997=nSource;
[tmp1,tmp2,lb(n),ub(n)]=GEA_ff_reserves_and_resources();
v(n) = mean([lb(n) ub(n)]);
%%%%%%%%%% 
n=n+1 ; 
iPr_ff0 = n ; 
ParameterName{n}='Initial fossil fuel cost'; 
ParameterUnits{n}='\$/bbl oil';
ParameterLatexSymbol{n}='$Pr_{ff_0}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;
iBP_review_2014=nSource;
v(n) = 90.;
lb(n)= 80.;
ub(n)= 110.;


%%%%%%%%%% 
n=n+1 ; 
iffdtre = n ;
ParameterName{n}='Average fossil energy density trend (inverse)'; 
ParameterUnits{n}='g C/kJ';
ParameterLatexSymbol{n}='$\sigma_{ff}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;
iauthor_estimate=nSource;
v(n) = 0.5e-7; %g/J/yr
lb(n)= 0.0e-7;
ub(n)= 1.e-7;

%%%%%%%%%% 
n=n+1 ; 
iffdfin = n ;
ParameterName{n}='Final fossil energy density (inverse)'; 
ParameterUnits{n}='g C/kJ';
ParameterLatexSymbol{n}='$\sigma_{ff}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;%'http://www.ocean.washington.edu/courses/envir215/energynumbers.pdf'
[tmp1,tmp2,tmp3,v(n)] = calculate_historical_reserve_growth_rate();
lb(n)= gasEdensity;
ub(n)= coalEdensity; %g/J C, for coal
ffd0=v(n);

%%%%%%%%%% 
n=n+1 ; 
iPr_re0 = n ; 
ParameterName{n}='Initial renewable unit cost'; 
ParameterUnits{n}='\$/MWh';
ParameterLatexSymbol{n}='$Pr_{ff_0}$ ';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;
iIEA_medium_term_market_report=nSource;
v(n) = 375.;
lb(n)= 250.;
ub(n)= 400.;

%%%%%%%%%% 
n=n+1 ; 
iPr_remin = n ; 
ParameterName{n}='Minimum renewable unit cost'; 
ParameterUnits{n}='\% of initial cost';
ParameterLatexSymbol{n}='$Pr_{re_{min}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
v(n) = 0.3;
lb(n)= 0.2;
ub(n)= 0.5;

%%%%%%%%%% 
n=n+1 ; 
ic_tax = n  ; 
ParameterName{n}='Relative carbon tax ($>$1=tax, $<$1=subsidy)'; 
ParameterUnits{n}='\%';
ParameterLatexSymbol{n}='$S_{ff}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
v(n) = 1.;  
lb(n)= 0.8;
ub(n)= 1.2;

%%%%%%%%%% 
n=n+1 ; iDff0 = n; 
ParameterName{n}='Initial fossil fuel discovery rate'; 
ParameterUnits{n}='Tt C/yr';
ParameterLatexSymbol{n}='$D_{ff_0}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iBP_review_2014;
[v(n),lb(n),ub(n),temp] = calculate_historical_reserve_growth_rate();

%%%%%%%%%% 
n=n+1 ; 
iCTre = n;
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
ipopmax = n;
ParameterName{n}='Maximum population'; 
ParameterUnits{n}='Billion people';
ParameterLatexSymbol{n}='$P_{max}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;%10.1126/science.1257469'http://www.sciencemag.org/content/early/2014/09/17/science.1257469.full.pdf (also there is a big Nature special issue on this)';
iGerland_et_al_2014=nSource;
v(n) = 10.9;
lb(n)= 9.6;
ub(n)=12.3;

%%%%%%%%%% 
n=n+1; 
ipopinc = n;
ParameterName{n}='Population increase'; 
ParameterUnits{n}='\%/yr';
ParameterLatexSymbol{n}='$P_{inc}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;%'https://www.google.com/publicdata/explore?ds=d5bncppjof8f9_&ctype=l&strail=false&bcs=d&nselm=h&met_y=sp_pop_grow&scale_y=lin&ind_y=false&rdim=region&ifdim=region&tdim=true&hl=en&dl=en&ind=false';
igoogle_public_data=nSource;
v(n) = 0.015;
lb(n)= 0.01;
ub(n)= 0.02;

%%%%%%%%%% 
n=n+1; 
ipcdmax = n; 
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
ipcdinc = n; 
ParameterName{n}='Per-capita energy consumption increase'; 
ParameterUnits{n}='\%/yr';
ParameterLatexSymbol{n}='$De_{{pc}_{inc}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;%'http://www.eia.gov/cfapps/ipdbproject/iedindex3.cfm?tid=44&pid=45&aid=2&cid=ww,&syid=1980&eyid=2011&unit=MBTUPP';
iIEA_data=nSource;
v(n) = 0.005 ;
lb(n)= 0.001 ;
ub(n)= 0.01 ;

%%%%%%%%%% 
n=n+1; 
ifffb = n; 
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
ifffcexp = n; 
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
icc2dT = n;
ParameterName{n}='Ratio of cumulative emissions to net warming'; 
ParameterUnits{n}='C/Gt C';
ParameterLatexSymbol{n}='$CCR$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;nSource=nSource+1;
iMatthews_et_al_2009=nSource;
v(n) = 1.5; 
lb(n)=1.;
ub(n)=2.1;

%Convert data to Latex table
for nn=1:n
   ParamRange{nn}=strcat(num2str(lb(nn)),'-',num2str(ub(nn)),'$^',num2str(ParameterSource{nn}),'$'); 
end
data=[ParameterLatexSymbol',ParameterUnits',ParamRange'];
columnlabels={'Symbol','Units','Range'};

matrix2latex(data, 'paramtable.tex','rowLabels',ParameterName,'columnLabels',columnlabels,'alignment','c','size','tiny')

clear tmp*