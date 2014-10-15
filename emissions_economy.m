function [so] = emissions_economy(args)

% Can Homo economicus save us from environmental apocolypse?

%source global constants
set_global_constants

%unpack LHS-varied parameters
n_unpacked_params=0;
global V0;      n_unpacked_params=n_unpacked_params+1;V0=args(n_unpacked_params);
global Pr_ff0;  n_unpacked_params=n_unpacked_params+1;Pr_ff0=args(n_unpacked_params);
global FF_Eden;n_unpacked_params=n_unpacked_params+1;FF_Eden=args(n_unpacked_params);
global Pr_re0;  n_unpacked_params=n_unpacked_params+1;Pr_re0=args(n_unpacked_params);
global Pr_remin;n_unpacked_params=n_unpacked_params+1;Pr_remin=args(n_unpacked_params);
global c_tax;   n_unpacked_params=n_unpacked_params+1;c_tax=args(n_unpacked_params);
global Dff0;   n_unpacked_params=n_unpacked_params+1;Dff0=args(n_unpacked_params);
global CTre;    n_unpacked_params=n_unpacked_params+1;CTre=args(n_unpacked_params);
global popmax;  n_unpacked_params=n_unpacked_params+1;popmax=args(n_unpacked_params);
global popinc;  n_unpacked_params=n_unpacked_params+1;popinc=args(n_unpacked_params);
global pcdmax;  n_unpacked_params=n_unpacked_params+1;pcdmax=args(n_unpacked_params);
global ipcdinc;  n_unpacked_params=n_unpacked_params+1;ipcdinc=args(n_unpacked_params);
global fffb;    n_unpacked_params=n_unpacked_params+1;fffb=args(n_unpacked_params);
global fffcexp; n_unpacked_params=n_unpacked_params+1;fffcexp=args(n_unpacked_params);
global icc2dT; n_unpacked_params=n_unpacked_params+1;icc2dT=args(n_unpacked_params);

%Convert from billion people, to people
popmax=popmax.*1.e9;
%Convert from gigajoules to joules
pcdmax=pcdmax.*1.e9;
%Convert from g/kJ to g/J
FF_Eden=FF_Eden./1.e3;
%Convert from Tt C to g C
V0=V0.*1.e18;

%Convert volume of fossil fuels to potential energy (J)
V0 = V0 ./ FF_Eden ;
%Convert initial cost of fossil fuels from $/bbl to $/J
Pr_ff0 = Pr_ff0 ./ bbl_2_gC ; % ($/gC)
Pr_ff0 = Pr_ff0 .* FF_Eden ;  % ($/J)
%Convert initial cost (and tech improvement) of renewable fuels from
%$/MWh(/yr) to $/J(/yr)
Pr_re0 = Pr_re0 ./ mwh_2_J ;
CTre = CTre ./ mwh_2_J ;

%%%%%%%%%%% Do the integration %%%%%%%%%%%%%%%%%%%%%%%
% set some ODE solver options and do the numerical iteration
options = odeset('RelTol',1e-6,'AbsTol',1e-6,'Events',@events);
[ so.time , so.ff_volume , so.event_times, so.solution_values, so.which_event] = ...
    ode45(@volume,t0:1:tf,V0,options);

%%%%%%%%%%% Calculate diagnostics %%%%%%%%%%%%%%%%%%%%%%%
%Post-calculate fossil fuel reserve evolution and diagnostics by re-calling
%volume...
[so.dVdt,diagnostics] = volume( so.time , so.ff_volume );
%concatenate diagnostics generated within 'volume' routine to output structure...
so=catstruct(so,diagnostics);
%...and recalculate some other diagnostics by conversion/value picking.

%so.burn_rate=so.burn_rate.*FF_Eden./g_2_Tt;

so.burn_rate_max=max(so.burn_rate);
so.cum_emissions=cumsum(so.burn_rate) + emissions_to_date;
so.event_times=so.event_times + present_year;
so.tot_emissions=so.cum_emissions(end);
so.net_warming=so.tot_emissions.*icc2dT;

so.consumption_init=so.tot_en_demand(1);
so.dconsumptiondt_init=so.tot_en_demand(2)-so.tot_en_demand(1);
so.burn_rate_init=so.burn_rate(1);
so.ff_fraction_init=so.ff_fraction(1);

i=find(so.which_event==1);
if (~isempty(i))
    so.t_cross_over=so.event_times(i);
end
i=find(so.which_event==2);
if (~isempty(i))
    so.t_total_depletion=so.event_times(i);
end
i=find(so.which_event==3);
if (~isempty(i))
    so.t_fossil_fuel_emissions_stop=so.event_times(i);
end

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Private functions follow.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dVdt,diagnostics] = volume( t , V )

%set fraction of energy demand derived from fossil fuels:
%as the price of renewables goes down (or fossil fuels goes up), more
%renewables are generated, so the demand for fossil fuels goes down.

burn_rate = total_energy_demand(t) .* frac_of_energy_from_ff(t,V); %Joules
dVdt = ff_discovery_rate(V,t) - burn_rate; %Joules

%save secondary fields (aside from dVdt) for diagnostics
diagnostics.burn_rate=burn_rate;
diagnostics.ff_pr=ff_price(V);
diagnostics.re_pr=re_price(t);
diagnostics.ff_fraction=frac_of_energy_from_ff(t,V);
diagnostics.tot_en_demand=total_energy_demand(t);
diagnostics.pop=population( t );
diagnostics.per_cap_dem=per_cap_demand( t );
diagnostics.discovery_rate=ff_discovery_rate(V,t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dtot] = total_energy_demand(t)

dtot = population(t) .* per_cap_demand(t) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fff] = frac_of_energy_from_ff( t , V )

global fffb fffcexp

a = 1.0;
b = fffb;
c = 1.*10^fffcexp;
ff_pr=ff_price(V);
re_pr=re_price(t);
scalefac=2;
x=(ff_pr-re_pr)./ff_pr.*scalefac;

fff = a ./ (1 + b.*c.^(-x)); %sigmoid function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pop] = population( t )

global P0 popinc popmax


e = exp(popinc*t);
pop = P0*popmax*e./(popmax+P0*(e-1));

popdub=log(2)./(log(1+P0));
%pop = P0 .* exp( t .* ( log(2) / popdub) ) ; %exponential population growth
%pop = min( popmax , pop );                  %limit to maximum population

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pcd] = per_cap_demand( t )

global ipcdinc pcdmax Globalpercapconsump2013
pcddub=log(2)./(log(1+ipcdinc));
pcd = Globalpercapconsump2013 .* exp( t .* ( log(2) / pcddub) );  % exponential per capita demand growth
pcd = min( pcd , pcdmax) ;      %limit to maximum per capita demand

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pr_ff] = ff_price( V )

global V0 Pr_ff0 c_tax

Pr_ff =  (V0./ V) .* Pr_ff0 .* c_tax  ; %  price change inverse to remaining reserve, V, and multiplied by carbon tax/subsidy.

Pr_ff = max(0.,Pr_ff);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pr_re] = re_price( t )

global Pr_re0 CTre Pr_remin

Pr_re = Pr_re0 + CTre .* t ;  %assumes simulation starts at year 2000.

Pr_re = max(Pr_remin.*Pr_re0,Pr_re);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Dff] = ff_discovery_rate( V, t )

global V0 Dff0 FF_Eden
r1=total_energy_demand(t)./total_energy_demand(1);
r2=frac_of_energy_from_ff( t , V )./frac_of_energy_from_ff( 1 , V0 );
r3=V0./V;
Dff = Dff0./FF_Eden.*r1.*r2.*r3;
        
%ensure Ctff doesn't go below 0 (implying negative discovery).
Dff = max(0.,Dff);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [value,isterminal,direction] = events(t,V)

%first event: energy prices match
value(1) =  ff_price(V) - re_price(t); %equate price of fossil fuel to price of renewable
isterminal(1) = 0; %stop integration if 1
direction(1) = 1; %only stop if crossing is hit in upward direction

%second event: entire fossil fuel reserve is depleted
value(2) = 0;
isterminal(2) = 1; %stop integration if 1
direction(2) = 1; %stop if crossing is hit in either direction

%third event: <1% of energy fraction supplied by fossil fuels
value(3) = frac_of_energy_from_ff(t,V)<0.01;
isterminal(3) = 1; %stop integration if 1
direction(3) = 0; %stop if crossing is hit in either direction

