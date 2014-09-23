function [so] = emissions_economy(args)

% Can Homo economicus save us from environmental apocolypse?

%source global constants
set_global_constants

%unpack LHS-varied parameters
n_unpacked_params=0;
global V0;      n_unpacked_params=n_unpacked_params+1;V0=args(n_unpacked_params);
global Pr_ff0;  n_unpacked_params=n_unpacked_params+1;Pr_ff0=args(n_unpacked_params);
global iFF_Eden;n_unpacked_params=n_unpacked_params+1;iFF_Eden=args(n_unpacked_params);
global Pr_re0;  n_unpacked_params=n_unpacked_params+1;Pr_re0=args(n_unpacked_params);
global c_tax;   n_unpacked_params=n_unpacked_params+1;c_tax=args(n_unpacked_params);
global cCTff;   n_unpacked_params=n_unpacked_params+1;cCTff=args(n_unpacked_params);
global CTre;    n_unpacked_params=n_unpacked_params+1;CTre=args(n_unpacked_params);
global popmax;  n_unpacked_params=n_unpacked_params+1;popmax=args(n_unpacked_params);
global pcdmax;  n_unpacked_params=n_unpacked_params+1;pcdmax=args(n_unpacked_params);
global fffb;    n_unpacked_params=n_unpacked_params+1;fffb=args(n_unpacked_params);
global fffcexp; n_unpacked_params=n_unpacked_params+1;fffcexp=args(n_unpacked_params);

%Convert volume of fossil fuels to potential energy (J)
V0 = V0 ./ iFF_Eden ;
%Convert initial cost of fossil fuels from $/bbl to $/J
Pr_ff0 = Pr_ff0 ./ bbl_2_gC ; % ($/gC)
Pr_ff0 = Pr_ff0 .* iFF_Eden ;  % ($/J)
%Convert initial cost (and tech improvement) of renewable fuels from
%$/MWh(/yr) to $/J(/yr)
Pr_re0 = Pr_re0 ./ mwh_2_J ;
CTre = CTre ./ mwh_2_J ;

%%%%%%%%%%% Do the integration %%%%%%%%%%%%%%%%%%%%%%%
% set some ODE solver options and do the numerical iteration
options = odeset('RelTol',1e-5,'AbsTol',1e-3,'Events',@events);
[ so.time , so.ff_volume , so.event_times, so.solution_values, so.which_event] = ...
    ode45(@volume,t0:1:tf,V0,options);

%Post-calculate some output variables by re-calling volume evolution...
[so.dVdt,so.burn_rate,so.ff_fraction,so.ff_pr,so.re_pr] = volume( so.time , so.ff_volume );
%...and others by conversion
so.burn_rate=so.burn_rate.*iFF_Eden./g_2_Tt;
so.cum_emissions=cumsum(so.burn_rate) + emissions_to_date;
so.event_times=so.event_times + present_year;
so.tot_emissions=so.cum_emissions(end);

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


%Worker functions follow.


function [dVdt,burn_rate,ff_fraction,ff_pr,re_pr] = volume( t , V )

%set fraction of energy demand derived from fossil fuels:
%as the price of renewables goes down (or fossil fuels goes up), more
%renewables are generated, so the demand for fossil fuels goes down.

burn_rate = total_energy_demand(t) .* frac_of_energy_from_ff(t,V);
dVdt = ff_discovery_rate(V,t) - burn_rate;

%save for output
ff_pr=ff_price(V);
re_pr=re_price(t);
ff_fraction=frac_of_energy_from_ff(t,V);

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
x=(ff_pr-re_pr)./ff_pr;

fff = a ./ (1 + b.*c.^(-x)); %sigmoid function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pop] = population( t )

global P0 Cpop popmax

pop = P0 .* exp( t .* ( log(2) / Cpop) ) ; %exponential population growth
pop = min( popmax , pop );                  %limit to maximum population

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pcd] = per_cap_demand( t )

global Cpc pcdmax iFF_Eden
C0 = 1.1e6 ./ iFF_Eden ;
pcd = C0 .* exp( t .* ( log(2) / Cpc) ) ; % exponential per capita demand growth
pcd = min( pcd , pcdmax) ;      %limit to maximum per capita demand

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pr_ff] = ff_price( V )

global V0 Pr_ff0 c_tax

Pr_ff =  (V0./ V) .* Pr_ff0 .* c_tax  ; %  price change inverse to remaining reserve, V, and multiplied by carbon tax/subsidy.

Pr_ff = max(0.,Pr_ff);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pr_re] = re_price( t )

global Pr_re0 CTre

Pr_re = Pr_re0 + CTre .* t ;  %assumes simulation starts at year 2000.

Pr_re = max(0.1.*Pr_re0,Pr_re);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Ctff] = ff_discovery_rate( V, t )

global V0 cCTff

%discovery of new reserves increases with increasing demand and decreasing
%reserves.

Ctff = 0.5.*total_energy_demand(t)/total_energy_demand(1) .* frac_of_energy_from_ff( t , V ) .* V0./V ;

%scale to relevant units.
Ctff = Ctff .* cCTff ;
%ensure Ctff doesn't go below 0 (implying negative discovery).
Ctff = max(0,Ctff);

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
value(3) = frac_of_energy_from_ff(t,V)>0.01;
isterminal(3) = 1; %stop integration if 1
direction(3) = 0; %stop if crossing is hit in either direction

