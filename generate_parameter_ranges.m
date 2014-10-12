n= 0 ;

%%%%%%%%%%
n=n+1 ; 
iV0 = n; 
ParameterName{n}=' Initial fossil fuel reservoir volume'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$V_{ff_O}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='http://archive.greenpeace.org/climate/science/reports/carbon/clfull-3.html#Heading23';
v(n) = 1.5; 
lb(n)= 1.2;
ub(n)= 1.8;

%%%%%%%%%% 
n=n+1 ; 
iPr_ff0 = n ; 
ParameterName{n}='Initial fossil fuel cost'; 
ParameterUnits{n}='\$/bbl oil';
ParameterLatexSymbol{n}='$Pr_{ff_0}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='';
v(n) = 90.;
lb(n)= 80.;
ub(n)= 100.;

%%%%%%%%%% 
n=n+1 ; 
iffde = n ;
ParameterName{n}='Average fossil energy density (inverse)'; 
ParameterUnits{n}='g C/kJ';
ParameterLatexSymbol{n}='$\sigma_{ff}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='http://www.ocean.washington.edu/courses/envir215/energynumbers.pdf';
v(n) = 2.0e-5.*1.e3;
lb(n)= 1.4e-5.*1.e3;
ub(n)= 2.4e-5.*1.e3;

%%%%%%%%%% 
n=n+1 ; 
iPr_re0 = n ; 
ParameterName{n}='Initial renewable unit cost'; 
ParameterUnits{n}='\$/MWh';
ParameterLatexSymbol{n}='$Pr_{ff_0}$ ';
ParameterOutputFormat{n}='';
ParameterSource{n}='UofM Energy Institute Technical Paper "Renewable Energy Technology Review"';
v(n) = 375.;
lb(n)= 350.;
ub(n)= 400.;

%%%%%%%%%% 
n=n+1 ; 
iPr_remin = n ; 
ParameterName{n}='Minimum renewable unit cost'; 
ParameterUnits{n}='\% of initial cost';
ParameterLatexSymbol{n}='$Pr_{re_{min}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='';
v(n) = 0.3;
lb(n)= 0.25;
ub(n)= 0.35;

%%%%%%%%%% 
n=n+1 ; 
ic_tax = n  ; 
ParameterName{n}='Relative carbon tax (>1=tax, <1=subsidy)'; 
ParameterUnits{n}='\%';
ParameterLatexSymbol{n}='$S_{ff}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='';
v(n) = 1.;  
lb(n)= 0.8;
ub(n)= 1.2;

%%%%%%%%%% 
n=n+1 ; iDff0 = n; 
ParameterName{n}='Initial fossil fuel discovery rate'; 
ParameterUnits{n}='Tt C';
ParameterLatexSymbol{n}='$D_{ff_0}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='';
v(n) = calculate_historical_reserve_growth_rate();
lb(n)= v(n)+0.1.*v(n);
ub(n)= v(n)-0.1.*v(n);

%%%%%%%%%% 
n=n+1 ; 
iCTre = n;
ParameterName{n}='Rate of renewable cost decline';
ParameterUnits{n}='\$/MWh/yr';
ParameterLatexSymbol{n}='$T_{re}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='UofM Energy Institute Technical Paper "Renewable Energy Technology Review"';
v(n) = -3.;
lb(n)= -3.2;
ub(n)= -2.8;

%%%%%%%%%% 
n=n+1; 
ipopmax = n;
ParameterName{n}='Projected maximum population'; 
ParameterUnits{n}='Billion people';
ParameterLatexSymbol{n}='$P_{max}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='http://www.sciencemag.org/content/early/2014/09/17/science.1257469.full.pdf (also there is a big Nature special issue on this)';
v(n) = 10.9;
lb(n)= 9.6;
ub(n)=12.3;

%%%%%%%%%% 
n=n+1; 
ipopinc = n;
ParameterName{n}='Population annual increase'; 
ParameterUnits{n}='\%';
ParameterLatexSymbol{n}='$P_{inc}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='https://www.google.com/publicdata/explore?ds=d5bncppjof8f9_&ctype=l&strail=false&bcs=d&nselm=h&met_y=sp_pop_grow&scale_y=lin&ind_y=false&rdim=region&ifdim=region&tdim=true&hl=en&dl=en&ind=false';
v(n) = 0.015;
lb(n)= 0.01;
ub(n)= 0.02;

%%%%%%%%%% 
n=n+1; 
ipcdmax = n; 
ParameterName{n}='Projected maximum per-capita energy consumption'; 
ParameterUnits{n}='GJ/yr';
ParameterLatexSymbol{n}='$De_{{pc}_{max}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='?';
v(n) = 3.2e11./1.e9 ;
lb(n)= 2.8e11./1.e9 ;
ub(n)= 3.6e11./1.e9 ;

%%%%%%%%%% 
n=n+1; 
ipcdinc = n; 
ParameterName{n}='Per-capita energy consumption annual increase'; 
ParameterUnits{n}='\%';
ParameterLatexSymbol{n}='$De_{{pc}_{inc}}$';
ParameterOutputFormat{n}='';
ParameterSource{n}='http://www.eia.gov/cfapps/ipdbproject/iedindex3.cfm?tid=44&pid=45&aid=2&cid=ww,&syid=1980&eyid=2011&unit=MBTUPP';
v(n) = 0.005 ;
lb(n)= 0.001 ;
ub(n)= 0.01 ;

%%%%%%%%%% 
n=n+1; 
ifffb = n; 
ParameterName{n}='Fossil fuel to renewables transfer delay parameter';
ParameterUnits{n}='Unitless';
ParameterLatexSymbol{n}='$B$';
ParameterOutputFormat{n}='';
ParameterSource{n}='';
v(n) = 1.;
lb(n)=0.5;
ub(n)=1.5;

%%%%%%%%%% 
n=n+1; 
ifffcexp = n; 
ParameterName{n}='Fossil fuel to renewables transfer fade strength parameter'; 
ParameterUnits{n}='Unitless';
ParameterLatexSymbol{n}='$C$';
ParameterOutputFormat{n}='';
ParameterSource{n}='';
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
ParameterSource{n}='Matthews et al., 2009 10.1038/nature08047';
v(n) = 1.5; 
lb(n)=1.;
ub(n)=2.1;

%Convert data to Latex table
for nn=1:n
   ParamRange{nn}=strcat(num2str(lb(nn)),'/',num2str(ub(nn))); 
end
data=[ParameterLatexSymbol',ParameterUnits',ParamRange'];
columnlabels={'Symbol','Units','Range'};

matrix2latex(data, 'paramtable.tex','rowLabels',ParameterName,'columnLabels',columnlabels,'alignment','c','size','tiny')
