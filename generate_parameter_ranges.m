global ffef0 Dff0 ctax0

disp('Generating parameter sets...')

n=0;
nSource=1;
%%%%%%%%%%
n=n+1 ;
ParameterName{n}='Initial fossil fuel reservoir reserves'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$V_{ff}(0)$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iRogner_et_al_2012=nSource;
Reference{nSource}='Rogner_et_al_2012';nSource=nSource+1;
lb(n)=1.002;
ub(n)=1.94;

%%%%%%%%%%
n=n+1 ; 
ParameterName{n}='Maximum fossil fuel resources'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$V_{ff_{max}}$';
ParameterSource{n}=iRogner_et_al_2012;
lb(n)=2.535;
ub(n)=7.665; 
%lb(n)=2.535+.2;
%ub(n)=7.665+.2; 
%From Rogner, tho these values are quoted from IPCC AR5 WG3 Ch7, and coal
%resources reduced by 80% according to Rogner arguement on practical availability.
%Add 0.2 teratonnes if accounting for a 1985 start.

%%%%%%%%%% 
n=n+1 ;  
ParameterName{n}='Initial fossil fuel cost'; 
ParameterUnits{n}='\$/brl oil';
ParameterLatexSymbol{n}='$Pr_{ff}(0)$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iBP_review_2014=nSource;
Reference{nSource}='BP_statistical_review_2014';nSource=nSource+1;
lb(n)= 50.;
ub(n)= 100.;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Fossil energy emission factor trend'; 
ParameterUnits{n}='g C/J/yr';
ParameterLatexSymbol{n}='$T_{E_{ff}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iauthor_estimate=nSource;
Reference{nSource}='Author_estimate';nSource=nSource+1;
lb(n)= 0.6e-7;
ub(n)= 1.e-7;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Final fossil energy emission factor'; 
ParameterUnits{n}='g C/J';
ParameterLatexSymbol{n}='$E_{ff_f}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;%'http://www.ocean.washington.edu/courses/envir215/energynumbers.pdf'
[Dff0,~,~,ffef0] = calculate_historical_reserve_growth_rate();
lb(n)= gasEfactor; %g C/J
ub(n)= coalEfactor; %g C/J

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Initial non-fossil energy unit cost'; 
ParameterUnits{n}='\$/MWh';
ParameterLatexSymbol{n}='$Pr_{nff}(0)$ ';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iIEA_medium_term_market_report=nSource;
Reference{nSource}='IEA_medium_term_renewable_market_report_2014';nSource=nSource+1;
lb(n)= 300.;
ub(n)= 500.;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Minimum non-fossil energy unit cost'; 
ParameterUnits{n}='Fraction of initial cost';
ParameterLatexSymbol{n}='$Pr_{nff_{min}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
lb(n)= 0.1;
ub(n)= 0.3;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Maximum carbon tax'; 
ParameterUnits{n}='\$/T C';
ParameterLatexSymbol{n}='$S_{ff_{max}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iLontzek=nSource;
Reference{nSource}='Lontzek_et_al_2015';nSource=nSource+1;
lb(n)= ctax0; 
ub(n)= 650.;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='Carbon tax trend'; 
ParameterUnits{n}='\$/T C/yr';
ParameterLatexSymbol{n}='$T_{S_{ff}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iLontzek;
lb(n)= .5;
ub(n)= 4.;

%%%%%%%%%% 
n=n+1 ; 
ParameterName{n}='E-folding time of non-fossil energy cost decline';
ParameterUnits{n}='Yr';
ParameterLatexSymbol{n}='$T_{nff}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iIEA_medium_term_market_report;%also: 'UofM Energy Institute Technical Paper "Renewable Energy Technology Review"';
lb(n)= 10;
ub(n)= 20;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Maximum population'; 
ParameterUnits{n}='Billion people';
ParameterLatexSymbol{n}='$P_{max}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iGerland_et_al_2014=nSource;
Reference{nSource}='Gerland_et_al_2014';nSource=nSource+1;
lb(n)= 9.6;
ub(n)=12.3;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Population increase rate'; 
ParameterUnits{n}='\%/yr';
ParameterLatexSymbol{n}='$P_{inc}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iworld_bank=nSource;
Reference{nSource}='World_bank_data_2014';nSource=nSource+1;%'https://www.google.com/publicdata/explore?ds=d5bncppjof8f9_&ctype=l&strail=false&bcs=d&nselm=h&met_y=sp_pop_grow&scale_y=lin&ind_y=false&rdim=region&ifdim=region&tdim=true&hl=en&dl=en&ind=false';
lb(n)= 0.015;
ub(n)= 0.023;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Maximum per-capita energy consumption'; %Ranges between Euro and NA energy consumption
ParameterUnits{n}='GJ/yr';
ParameterLatexSymbol{n}='$De_{{pc}_{max}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iIEA_data=nSource;
Reference{nSource}='EIA_online';nSource=nSource+1;%'http://www.eia.gov/cfapps/ipdbproject/iedindex3.cfm?tid=44&pid=45&aid=2&cid=ww,&syid=1980&eyid=2011&unit=MBTUPP';
lb(n)= 133.e6*1055./1.e9 ;
ub(n)= 254.e6*1055./1.e9 ;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Per-capita energy consumption increase'; 
ParameterUnits{n}='\%/yr';
ParameterLatexSymbol{n}='$De_{pc_{inc}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iIEA_data;
lb(n)= 0.006 ;
ub(n)= 0.015 ;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Fossil to non-fossil energy transfer delay';
ParameterUnits{n}='Unitless';
ParameterLatexSymbol{n}='$B$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
lb(n)=0.2;
ub(n)=1.;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Fossil to non-fossil energy transfer fade strength'; 
ParameterUnits{n}='Unitless';
ParameterLatexSymbol{n}='$C$';
ParameterOutputFormat{n}='';
ParameterSource{n}=iauthor_estimate;
lb(n)=-6;
ub(n)=-4;

%%%%%%%%%% 
n=n+1; 
ParameterName{n}='Transient climate response to emissions'; 
ParameterUnits{n}='$^\circ$C/Gt C';
ParameterLatexSymbol{n}='$TCRE$';
ParameterOutputFormat{n}='';
ParameterSource{n}=nSource;
iCollins_et_al_2013=nSource;
Reference{nSource}='Collins_et_al_2013';nSource=nSource+1;
lb(n)=0.8;
ub(n)=2.5;

%% 

%First: define a vector of median values, for each parameter
mu=mean([ub' lb'],2);

%Next: extract standard deviation from the spread between the upper and lower
%bounds, assuming these bounds represent +/- 2-sigma (i.e. ~95%).
sigma=((ub'-lb')./4);

%Next: calculate covariance, as the squared of sigma
covariance=sigma.^2;

%Finally: generate model parameter sets, with each parameter varied
%according to an LHS sampling of parameter distributions.
model_parameters=lhsnorm(mu,diag(covariance),ensemble_size);

generate_latex_parameter_table

%Create pdf plots of all parameter distributions
for n=1:size(model_parameters,2)
    figure
    set(gcf,'Visible','Off')
    hist(squeeze(model_parameters(:,n)),100)
    axis tight
    title(sprintf('%s (%s)',ParameterName{n},ParameterUnits{n}),'interpreter','latex')
    xlabel(strcat('Mean=',num2str(mu(n)),...
                  ' Standard deviation=',num2str(sigma(n))))
    print('-depsc2',strcat('figs/',ParameterName{n},'_distribution'))
end

disp('Parameter ranges plotted to file.')
