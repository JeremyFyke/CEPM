function [so] = emissions_economy(c,args)

tm1=0;
ff_discovery_tot=0;

% Can Homo economicus save us from environmental apocolypse?

%Unpack LHS-varied parameters; assign LHS parameters to ensemble struture for diagnostics
n=0;
n=n+1;V0=args(n)        ;so.LHSparams(n)=V0;
n=n+1;Vmax=args(n)      ;so.LHSparams(n)=Vmax;
n=n+1;Pr_ff0=args(n)    ;so.LHSparams(n)=Pr_ff0;
n=n+1;ffeftre=args(n)   ;so.LHSparams(n)=ffeftre;
n=n+1;ffeffin=args(n)   ;so.LHSparams(n)=ffeffin;
n=n+1;Pr_re0=args(n)    ;so.LHSparams(n)=Pr_re0;
n=n+1;Pr_remin=args(n)  ;so.LHSparams(n)=Pr_remin;
n=n+1;ctaxmax=args(n)   ;so.LHSparams(n)=ctaxmax;
n=n+1;ctaxTre=args(n)   ;so.LHSparams(n)=ctaxTre;
n=n+1;CTre=args(n)      ;so.LHSparams(n)=CTre;
n=n+1;popmax=args(n)    ;so.LHSparams(n)=popmax;
n=n+1;popinc=args(n)    ;so.LHSparams(n)=popinc;
n=n+1;pcdmax=args(n)    ;so.LHSparams(n)=pcdmax;
n=n+1;ipcdinc=args(n)   ;so.LHSparams(n)=ipcdinc;
n=n+1;fffb=args(n)      ;so.LHSparams(n)=fffb;
n=n+1;fffcexp=args(n)   ;so.LHSparams(n)=fffcexp;
n=n+1;TCRE=args(n)      ;

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
%Ensure carbon tax trend ($/yr) is always positive.
ctaxTre=max(0.1,ctaxTre);
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
ctax0dpJ=c.ctax0./c.g_per_T.*c.ffef0;
ctaxTre=ctaxTre./c.g_per_T.*c.ffef0;
ctaxmax=ctaxmax./c.g_per_T.*c.ffef0;

%Convert initial cost (and tech improvement) of renewable fuels from
%$/MWh(/yr) to $/J(/yr)
Pr_re0 = Pr_re0 ./ c.mwh_2_J ;

%%%%%%%%%%% Do the integration %%%%%%%%%%%%%%%%%%%%%%%
% set some ODE solver options and do the numerical iteration

options = odeset('RelTol',1e-3,'AbsTol',1e-6,'Events',@events);
[so.time , so.ff_volume , so.event_times, so.solution_values, so.which_event] = ...
    ode45(@volume,c.t0:1:c.tf,V0,options);

%%%%%%%%%%% Calculate diagnostics %%%%%%%%%%%%%%%%%%%%%%%
%Post-calculate fossil fuel reserve evolution and diagnostics by re-calling
%volume, with time and ff_volume VECTORS.
[so.dVdt,diagnostics] = volume( so.time , so.ff_volume );
%concatenate diagnostics generated within 'volume' routine to output structure...
so=catstruct(so,diagnostics);
%...and recalculate some other diagnostics by conversion/value picking.

so.burn_rate=so.burn_rate.*so.ff_emission_factor/c.g_2_Tt;
so.discovery_rate=so.discovery_rate.*so.ff_emission_factor/c.g_2_Tt;

so.burn_rate_max=max(so.burn_rate);
so.cum_emissions=cumsum(so.burn_rate) + c.emissions_to_date;
so.event_times=so.event_times + c.present_year;
so.tot_emissions=so.cum_emissions(end);

%Scale TCRE if above the CE_TCRE saturation point (Leduc et al., 2015)
so.TCRE_damper=0.;
so.TCRE_orig=TCRE;
if so.tot_emissions>c.CE_TCRE_saturation_point
   so.TCRE_damper=(so.tot_emissions-c.CE_TCRE_saturation_point).*c.TCRE_dampening_factor; %TCRE_dampening_factor in units: (Tc C^-1)  
   TCRE=TCRE.*(1.-so.TCRE_damper);
end
so.LHSparams(n)=TCRE;

so.net_warming=so.tot_emissions.*TCRE;

so.consumption_init=so.tot_en_demand(1);
so.dconsumptiondt_init=so.tot_en_demand(2)-so.tot_en_demand(1);
so.burn_rate_init=so.burn_rate(1);
so.ff_fraction_init=so.ff_fraction(1);
so.ff_fractional_reservoir_depletion=so.ff_volume(end)./V0;

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
        
        diagnostics.burn_rate=burn_rate;
        diagnostics.ff_emission_factor=fossil_fuel_emission_factor(t);
        diagnostics.ff_pr=ff_price(V,t);
        diagnostics.re_pr=re_price(t);
        diagnostics.ff_fraction=frac_of_energy_from_ff(t,V);
        diagnostics.tot_en_demand=total_energy_demand(t);
        diagnostics.pop=population( t );
        diagnostics.per_cap_dem=per_cap_demand( t );
        diagnostics.discovery_rate=discovery_rate;
        diagnostics.carbon_tax=carbon_tax( t );
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
        
        ctax = ctax0dpJ + ctaxTre .* t ;
        
        ctax = min (ctax,ctaxmax);
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
        
        %first event: energy prices match
        value(1) =  ff_price(V,t) - re_price(t); %equate price of fossil fuel to price of renewable
        isterminal(1) = 0; %stop integration if 1
        direction(1) = 1; %only stop if crossing is hit in upward direction
        
        %second event: entire fossil fuel reserve is depleted
        value(2) = 0;
        isterminal(2) = 1; %stop integration if 1
        direction(2) = 1; %stop if crossing is hit in either direction
        
        %third event: <XXX% of energy fraction supplied by fossil fuels
        value(3) = frac_of_energy_from_ff(t,V)<0.05;
        isterminal(3) = 1; %stop integration if 1
        direction(3) = 0; %stop if crossing is hit in either direction
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end



