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

function [model_output] = emissions_economy(c,args)

% Can Homo economicus save us from environmental apocalypse?

tm1=0;
ff_discovery_tot=0;

%Unpack LHS-varied parameters; assign LHS parameters to ensemble member structure for later diagnostics
nLHS=0;
V0=c.V0;
Vmax=c.Vmax;
Pr_ff0=c.Pr_ff0;
ffeftre=c.ffeftre;
ffeffin=c.ffeffin;
Pr_re0=c.Pr_re0;
Pr_remin=c.Pr_remin;
cpricefinal=c.cpricefinal;
cpriceTre=c.cpriceTre;
CTre=c.CTre;
nLHS=nLHS+1;popmax=args(nLHS); model_output.LHSparams(nLHS)=popmax;
nLHS=nLHS+1;popinc=args(nLHS); model_output.LHSparams(nLHS)=popinc;
pcdmax=c.pcdmax;
ipcdinc=c.ipcdinc;
fffb=c.fffb;
fffcexp=c.fffcexp;
TCRE=c.TCRE;%TCRE is assigned to so structure below, after adjustment for saturation.

%Convert from billion people, to people
popmax=popmax.*c.bill;
%Convert from gigajoules to joules
pcdmax=pcdmax.*c.bill;
%Convert from Tt C to g C
V0=V0.*c.g_2_Tt;
Vmax=Vmax.*c.g_2_Tt;

%Ensure Vmax is greater than 120% of initial reserves
Vmax=max(Vmax,V0*1.2);
%Ensure E-folding time (yr) of renewable cost is not negative
CTre=max(1.0,CTre);
%Ensure carbon tax trend ($/yr) is not negative.
cpriceTre=max(0.0,cpriceTre);
%Ensure fossil to non-fossil transfer delay is above zero.
fffb=max(0.1,fffb);
%Ensure maximum per capita consumption is always .ge. than initial
pcdmax=max(pcdmax,c.GlobalpercapconsumpInit);
%Ensure TCRE is greater than 0
TCRE=max(TCRE,0.);

%Convert inital and maximum volume of fossil fuels to potential energy (J)

V0 = V0 ./ c.ffef0 ;
Vmax = Vmax ./ c.ffef0 ;

%Convert initial cost of fossil fuels from $/bbl to $/J
%bbl: gC/barrel of oil
Pr_ff0 = Pr_ff0 ./ c.bbl_2_gC ; % ($/gC)
Pr_ff0 = Pr_ff0 .* c.oilEfactor;   % ($/J)

%Convert initial carbon tax, carbon tax trend, and maximum carbon tax from $/T C to
%$/J
cprice0dpJ=c.cprice0./c.g_per_T.*c.ffef0;
cpriceTre=cpriceTre./c.g_per_T.*c.ffef0;
cpricefinal=cpricefinal./c.g_per_T.*c.ffef0;

%Convert initial cost (and tech improvement) of renewable fuels from
%$/MWh(/yr) to $/J(/yr)
Pr_re0 = Pr_re0 ./ c.mwh_2_J ;

%%%%%%%%%%% Do the integration %%%%%%%%%%%%%%%%%%%%%%%
% set some ODE solver options and do the numerical iteration

options = odeset('RelTol',1e-3,'AbsTol',1e-6,'Events',@events);
[model_output.time , model_output.ff_volume , model_output.event_times, model_output.solution_values, model_output.which_event] = ...
    ode45(@volume,c.t0:1:c.tf,V0,options);

%%%%%%%%%%% Calculate diagnostics %%%%%%%%%%%%%%%%%%%%%%%
%Post-calculate fossil fuel reserve evolution and diagnostics by re-calling
%volume, with time and ff_volume VECTORS.

EventTime=model_output.event_times(model_output.which_event==c.events.trivial_ff_energy_fraction);
if ~isempty(EventTime)
    EventTime=EventTime(1);
    iEventTime=find(model_output.time>EventTime,1,'first');
else
    EventTime=model_output.time(end);
    iEventTime=length(model_output.time);
end

[model_output.dVdt,diagnostics] = volume( model_output.time , model_output.ff_volume );
%concatenate diagnostics generated within 'volume' routine to output structure...
model_output=catstruct(model_output,diagnostics);
%...and recalculate some other diagnostics by conversion/value picking.

model_output.burn_rate=single(model_output.burn_rate.*model_output.ff_emission_factor/c.g_2_Tt);
model_output.discovery_rate=single(model_output.discovery_rate.*model_output.ff_emission_factor/c.g_2_Tt);

model_output.burn_rate_max=max(model_output.burn_rate);
model_output.cum_emissions=single(cumsum(model_output.burn_rate) + c.emissions_to_date);
model_output.tot_emissions=model_output.cum_emissions(iEventTime);
%scale event time to real years
model_output.event_times=model_output.event_times + c.start_year;
%Scale TCRE if above the CE_TCRE saturation point (Leduc et al., 2015)
model_output.TCRE_damper=0.;
model_output.TCRE_orig=TCRE;
if model_output.tot_emissions>c.CE_TCRE_saturation_point
    model_output.TCRE_damper=(model_output.tot_emissions-c.CE_TCRE_saturation_point).*c.TCRE_dampening_factor; %TCRE_dampening_factor in units: (Tc C^-1)
    TCRE=TCRE.*(1.-model_output.TCRE_damper);
end

model_output.LHSparams(nLHS)=TCRE;

model_output.net_warming=model_output.tot_emissions.*TCRE;

model_output.consumption_init=model_output.tot_en_demand(1);
model_output.dconsumptiondt_init=model_output.tot_en_demand(2)-model_output.tot_en_demand(1);
model_output.burn_rate_init=model_output.burn_rate(1);
model_output.ff_fraction_init=model_output.ff_fraction(1);
model_output.ff_fractional_reservoir_depletion=model_output.ff_volume(iEventTime)./V0;

i=find(model_output.which_event==c.events.energy_prices_match);
if (~isempty(i))
    model_output.t_cross_over=model_output.event_times(i);
else
    model_output.t_cross_over=[];
end
i=find(model_output.which_event==c.events.trivial_ff_energy_fraction);
if (~isempty(i))
    model_output.t_fossil_fuel_emissions_stop=model_output.event_times(i);
else
    model_output.t_fossil_fuel_emissions_stop=[];
end
i=find(model_output.which_event==c.events.total_ff_depletion);
if (~isempty(i))
    model_output.t_total_depletion=model_output.event_times(i);
else
    model_output.t_total_depletion=[];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Nested functions follow.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [dVdt,diagnostics] = volume( t , V )
        dt=t-tm1;
        tm1=t;
        
        %set fraction of energy demand derived from fossil fuels:
        %as the price of renewables goes down (or fossil fuels goes up), more
        %renewables are generated, so the demand for fossil fuels goes down.
        
        burn_rate = total_energy_demand(t) .* frac_of_energy_from_ff(t,V); %Joules
        discovery_rate=ff_discovery_rate(V,t,ff_discovery_tot); %Joules
        
        dVdt = discovery_rate - burn_rate; %Joules
        
        if isscalar(discovery_rate)
            ff_discovery_tot=ff_discovery_tot+discovery_rate.*dt;
        end
        
        %If being called for diagnostics (and not from the ode45 solver) save secondary fields (aside from dVdt) for diagnostics.  Note that in this case,
        %t and V are vectors.
        
        diagnostics.burn_rate=single(burn_rate);
        diagnostics.ff_emission_factor=single(fossil_fuel_emission_factor(t));
        diagnostics.ff_pr=single(ff_price(V,t));
        diagnostics.re_pr=single(re_price(t));
        diagnostics.ff_fraction=single(frac_of_energy_from_ff(t,V));
        diagnostics.tot_en_demand=single(total_energy_demand(t));
        diagnostics.pop=single(population( t ));
        diagnostics.per_cap_dem=single(per_cap_demand( t ));
        diagnostics.discovery_rate=single(discovery_rate);
        diagnostics.carbon_tax=single(carbon_tax( t ));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [dtot] = total_energy_demand(t)
        
        dtot = population(t) .* per_cap_demand(t) ;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [fff] = frac_of_energy_from_ff( t , V )
        
        bp = fffb;
        cp = 1.*10^fffcexp;
        ff_pr=ff_price(V,t);
        re_pr=re_price(t);
        x=(ff_pr-re_pr)./ff_pr;
        
        fff = c.ff_frac0 ./ (1 + bp.*cp.^(-x)); %sigmoid function
        
        if max(fff) > 1.
            error('fff > 1. in frac_of_energy_from_ff')
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [pop] = population( t )
        
        %Lotka population equation
        e = exp(popinc*t);
        pop = c.P0*popmax*e./(popmax+c.P0*(e-1));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [pcd] = per_cap_demand( t )
        
        pcd = c.GlobalpercapconsumpInit .* exp( t .* (ipcdinc));  % exponential per capita demand growth
        pcd = min( pcd , pcdmax) ;      %limit to maximum per capita demand
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [Pr_ff] = ff_price( V,t )
        
        Pr_ff =  (V0./ V) .* Pr_ff0 + carbon_tax ( t ); %  price change inverse to remaining reserve, V, and multiplied by carbon tax/subsidy.
        
        Pr_ff = max(0.,Pr_ff);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [ctax] = carbon_tax( t )
        
        %If final carbon price is GREATER (i.e. LESS-subsidized fossil fuels)
        %than the initial, then make cprice trend negative.  Also include equality
        %case here.
        if cpricefinal >= cprice0dpJ
            
            ctax = cprice0dpJ + cpriceTre .* t ; %increase ctax up towards cpricefinal
            ctax = min (ctax,cpricefinal); %upper-cap ctax to cpricefinal
            
            %Otherwise, if final carbon price is LESS (i.e. MORE-subsidized fossil fuels)
            %than the initial, then make cprice trend positive.
        else
            
            ctax = cprice0dpJ - cpriceTre .* t ; %decrease ctax up towards cpricefinal
            ctax = max (ctax,cpricefinal); %lower-cap ctax to cpricefinal
            
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [Pr_re] = re_price( t )
        
        Pr_remin_abs = Pr_re0 .* Pr_remin;
        Pr_re = Pr_remin_abs + (Pr_re0-Pr_remin_abs).*exp(-(1./CTre).*t);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [efac] = fossil_fuel_emission_factor( t )
        
        %trend initial emission factor (g/J) to final factor, hold constant once there
        if c.ffef0 > ffeffin
            efac = c.ffef0 - ffeftre .* t ;
            efac = max(efac,ffeffin);
        else
            efac = c.ffef0 + ffeftre .* t ;
            efac = min(efac,ffeffin);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [Dff] = ff_discovery_rate( V, t, ff_discovery_tot )
        
        r1=total_energy_demand(t)./total_energy_demand(1);
        r2=V0./V;
        r3=frac_of_energy_from_ff( t , V )./frac_of_energy_from_ff( 1 , V0 );
        num=Vmax-(ff_discovery_tot+V0);
        den=Vmax-V0;
        r4=num./den;%needs to approach 0, as V approaches V_max
        Dff0_in_Tt=c.Dff0.*c.g_2_Tt;
        Dff = Dff0_in_Tt.*r1.*r2.*r3.*r4;
        
        Dff = Dff./fossil_fuel_emission_factor( t ); %Convert to Joules
        %ensure Ctff doesn't go below 0 (implying negative discovery).
        Dff = max(0.,Dff);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [value,isterminal,direction] = events(t,V)
        
        %event: energy prices match
        value(c.events.energy_prices_match) =  ff_price(V,t) - re_price(t); %equate price of fossil fuel to price of renewable
        isterminal(c.events.energy_prices_match) = 0; %stop integration if 1
        direction(c.events.energy_prices_match) = 1; %only stop if crossing is hit in upward direction
        
        %event: <XXX% of energy fraction supplied by fossil fuels
        value(c.events.trivial_ff_energy_fraction) = frac_of_energy_from_ff(t,V)<c.energy_fraction;
        isterminal(c.events.trivial_ff_energy_fraction) = 0; %stop integration if 1
        direction(c.events.trivial_ff_energy_fraction) = 0; %stop if crossing is hit in either direction
        
        %event: entire fossil fuel reserve is depleted
        value(c.events.total_ff_depletion) = 0;
        isterminal(c.events.total_ff_depletion) = 1; %stop integration if 1
        direction(c.events.total_ff_depletion) = 0; %stop if crossing is hit in either direction
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end



