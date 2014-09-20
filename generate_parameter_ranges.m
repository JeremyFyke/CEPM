n= 0 ;

%%%%%%%%%%
n=n+1 ; 
iV0 = n; 
ParameterName{n}='Current (t=0) conventional reserves'; 
ParameterUnits{n}='Gt C';
ParameterSource{n}='http://archive.greenpeace.org/climate/science/reports/carbon/clfull-3.html#Heading23';
v(n) = 1.5e18; 
lb(n)= 1.0e18;
ub(n)= 2.0e18;

%%%%%%%%%% 
n=n+1 ; 
iPr_ff0 = n ; 
ParameterName{n}='Initial fossil energy unit cost'; 
ParameterUnits{n}='$/bbl oil';
ParameterSource{n}='';
v(n) = 90.;
lb(n)= 100.;
ub(n)= 80.;

%%%%%%%%%% 
n=n+1 ; 
iFF_Eden = n ;
ParameterName{n}='Average fossil energy density (inverse)'; 
ParameterUnits{n}='g C/J';
ParameterSource{n}='http://www.ocean.washington.edu/courses/envir215/energynumbers.pdf';
v(n) = 2.0e-5;
lb(n)= 1.4e-5;
ub(n)= 2.4e-5;

%%%%%%%%%% 
n=n+1 ; 
iPr_re0 = n ; 
ParameterName{n}='Initial renewable unit cost'; 
ParameterUnits{n}='$/MWh';
ParameterSource{n}='UofM Energy Institute Technical Paper "Renewable Energy Technology Review"';
v(n) = 375.;
lb(n)= 350.;
ub(n)= 400.;

%%%%%%%%%% 
n=n+1 ; 
ic_tax = n  ; 
ParameterName{n}='Relative carbon tax (>1=tax, <1=subsidy)'; 
ParameterUnits{n}='%';
ParameterSource{n}='';
v(n) = 1.;  
lb(n)= 0.8;
ub(n)= 1.2;

%%%%%%%%%% 
n=n+1 ; icCTff = n; 
ParameterName{n}='Technology rate improvement to fossil fuel extraction'; 
ParameterUnits{n}='% (J/yr)';
ParameterSource{n}='';
v(n) = 1.e20;
lb(n)= 0.8e20;
ub(n)= 1.2e20;

%%%%%%%%%% 
n=n+1 ; 
iCTre = n;
ParameterName{n}='Rate change of renewable cost';
ParameterUnits{n}='$/MWh/yr';
ParameterSource{n}='UofM Energy Institute Technical Paper "Renewable Energy Technology Review"';
v(n) = -3.;
lb(n)= -3.2;
ub(n)= -2.8;

%%%%%%%%%% 
n=n+1; 
ipopmax = n;
ParameterName{n}='Projected maximum population'; 
ParameterUnits{n}='People';
ParameterSource{n}='Nature climate change population special issue';
v(n) = 9.e9;
lb(n)= 7.5e9;
ub(n)=10.5e9;

%%%%%%%%%% 
n=n+1; 
ipcdmax = n; 
ParameterName{n}='Projected maximum per-capita energy consumption'; 
ParameterUnits{n}='J/yr';
ParameterSource{n}='typical North American energy annual consumption in tons of oil, multiplied by energy density of oil';
v(n) = 8..*42.e9 ;
lb(n)= 7..*42.e9 ;
ub(n)= 9..*42.e9 ;

%%%%%%%%%% 
n=n+1; 
ifffb = n; 
ParameterName{n}='Fossil fuel to renewables transfer delay parameter';
ParameterUnits{n}='Unitless';
ParameterSource{n}='';
v(n) = 1.;
lb(n)=0.5;
ub(n)=1.5;

%%%%%%%%%% 
n=n+1; 
ifffcexp = n; 
ParameterName{n}='Fossil fuel to renewables transfer fade strength parameter'; 
ParameterUnits{n}='Unitless';
ParameterSource{n}='';
v(n) = -4.; 
lb(n)=-3;
ub(n)=-5;

