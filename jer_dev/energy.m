function [total_emissions,cross_date] = energy(args)

% Can Homo economicus save us from environmental apocolypse?
% Constants defined here, the functional forms are set up at the bottom
% Main units are Joules.

global  run_type...
        J_2_gC...
        kwh_2_J...
        V0...
        Pr_ff0...       
        Pr_re0...
        t0...
        tf...
        Cpc...
        C0...
        pcdmax...
        P0...
        popmax...
        cCTff...
        CTre...
        c_tax...
        Cpop...
        
    %unpack dummy arguments.
    n=0;
    n=n+1;V0=args(n);
    n=n+1;Pr_ff0=args(n);
    n=n+1;Pr_re0=args(n);
    n=n+1;c_tax=args(n);
    n=n+1;cCTff=args(n);
    n=n+1;CTre=args(n);
    n=n+1;popmax=args(n);
    n=n+1;pcdmax=args(n);
    
    %Set run-time.
    t0 = 0. ; %t0=year 2000.
    tf = 2000 ;
    %%%% Define constants %%%%
    J_2_gC =        2.0e-5;  %gC/Joule based on conventional oil energy density
    bbl_2_gC =      1.14e5 ; %gC/barrel
    kwh_2_J =       3.6e6 ;  %J/kwh
    mwh_2_J =       3.6e9 ;  %J/mwh
    tons_oil_2_J =  42.e9 ;  %J/ton
    log2=log(2) ;
    %Convert volume of fossil fuels to potential energy (J)
    V0 = V0 ./ J_2_gC ;
    %Convert initial cost of fossil fuels from $/bbl to $/J
    Pr_ff0 = Pr_ff0 ./ bbl_2_gC ; % ($/gC)
    Pr_ff0 = Pr_ff0 .* J_2_gC ;  % ($/J)
    %Convert initial cost (and tech improvement) of renewable fuels from
    %$/MWh(/yr) to $/J(/yr)
    Pr_re0 = Pr_re0 ./ mwh_2_J ;
    CTre = CTre ./ mwh_2_J ;
    %Per capita carbon demand doubling time (linear/constant if inf).
    %Original per capita demand (modern global mean emissions are ~4 mt CO2 / person / year,
    %which yields 4e6 * 12/44 = 1.1e6 gC/person/year modern
    Cpc = 170. ; % (yr)
    rCpc = 1./Cpc ;
    C0 = 1.1e6 ./ J_2_gC ;
    %Original population (7e9 is roughly the 2000 pop)
    P0 = 7.e9 ;
    Cpop = 54. ; %Population doubling time in years, assuming exponential growth.
    rCpop = 1./Cpop ;
    %%%%%%%%%%% Do the integration %%%%%%%%%%%%%%%%%%%%%%%
    % set some ODE solver options and do the numerical iteration
    options = odeset('RelTol',1e-11,'AbsTol',1e-11,'Events',@events);
    [ t , V , TE, YE, IE] = ode45(@volume,t0:1:tf,V0,options);
    
    yr = 2000 + t ;
    %Post-calculate cumulative emissions
    yearly_emissions = -V(2:end)+V(1:end-1) + ff_discovery_rate(V(2:end),t(2:end)) ;
    yearly_emissions = yearly_emissions .* J_2_gC ./ 1.e18 ;
    %yearly_emissions = population(t) .* per_cap_demand(t) .* J_2_gC ./ 1.e18 ;
    cum_emissions = cumsum ( yearly_emissions ) + .5; %add on 0.5 Tt emissions-to-date.
    g_warm =  cum_emissions .* 1.5 ; % convert cumulative emissions to equilib warming (Matthews et al., 2009).
    if t(end)<tf;
        total_emissions = cum_emissions(end);
        cross_date = yr(end) ;
    else
        total_emissions = nan ;
        cross_date = nan ;
    end
    %Post-calculate discovery of new fossil fuel resources
    res_increase=cumsum (ff_discovery_rate( V, t )) .* J_2_gC ./ 1.e18;

    %% Single-run output here
    
    if run_type == 1
        %Output some results here
        if t(end)<tf;
            disp( [ 'The year renewables became cheaper than fossil fuel: ' num2str(floor(yr(end)))] )
            disp('')
            disp( [ 'The amount of carbon emitted before renewables became cheaper: ' num2str(cum_emissions(end)) ' Tt'] )
            disp('')
            disp(['This would cause an equilibrium global warming of ' num2str( g_warm(end) ) ' degrees since pre-industrial'])
            disp('')
            disp([ '2011 global temp anomaly: ' num2str( g_warm( yr == 2011 ) ) ] )
             disp('')
            disp([ '2011 cumulative emissions: ' num2str( cum_emissions( yr == 2011 ) ) ] )                   
        else
            disp( [ 'Fossil fuels were still cheaper than renewables at end of integration (year ' num2str(cross_date) ')' ] )
        end
        fig1=figure;
        scnsize=get(0,'Monitorpositions');
        set(fig1,'Position',scnsize(1,:));
        subplot(2,4,1)
        plot(yr(2:end),cum_emissions)
        ylabel('Cumulative emissions (Tt C)')
        xlabel('year')
        axis tight
        subplot(2,4,2)
        plot(yr(2:end),yearly_emissions)
        ylabel('Yearly emissions (Tt C/yr)')
        xlabel('year')
        axis tight
        subplot(2,4,3)
        plot(yr,population(t) ./ 1e9)
        ylabel('Population (Billions)')
        xlabel('year')
        axis tight
        subplot(2,4,4)
        plot(yr,V.* J_2_gC ./ 1.e18)
        xlabel('year')
        axis tight
        ylabel('V, volume of FF remaining (Tt C)')
        subplot(2,4,5)
        plot( yr , ff_price( V ) , '-g' )
        hold on
        plot( yr , re_price( t ) ,'-k')
        xlabel('year')
        ylabel('Price ($/J)')
        legend('fossils','renewables', 'Location','Southeast')
        axis tight
        hold off
        subplot(2,4,6)
        plot( yr(2:end) , g_warm )
        xlabel('year')
        ylabel('Equilib temperature anomaly (^oC)')
        axis tight
        subplot(2,4,7)
        plot( yr , res_increase )
        xlabel('year')
        ylabel('Increase in fossil fuel reservoir (Tt C)')
        axis tight
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  
function [dtot] = total_energy_demand(t)

dtot = population(t) .* per_cap_demand(t) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fff] = frac_of_energy_from_ff( t , V )

fff = 1 - ( ff_price(V) ./ (ff_price(V) + re_price(t)) ) ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dVdt] = volume( t , V )

%set fraction of energy demand derived from fossil fuels:
%as the price of renewables goes down (or fossil fuels goes up), more
%renewables are generated, so the demand for fossil fuels goes down.

dVdt = ff_discovery_rate(V,t) -  total_energy_demand(t) .* frac_of_energy_from_ff(t,V) ;

%dVdt = ff_discovery_rate(V,t) - P0 .* C0 .* exp ( t .* log2 .* ( RCpop + RCpc ) ) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pop] = population( t )

global P0 Cpop popmax

pop = P0 .* exp( t .* ( log(2) / Cpop) ) ; %exponential population growth
pop = min( popmax , pop );                  %limit to maximum population

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pcd] = per_cap_demand( t ) 

global C0 Cpc pcdmax

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

Pr_re = max(0.,Pr_re);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Ctff] = ff_discovery_rate( V, t )

global V0 cCTff

%discovery of new reserves increases with increasing demand and decreasing
%reserves.

Ctff = total_energy_demand(t)/total_energy_demand(1) .* frac_of_energy_from_ff( t , V ) .* V0./V ;

%scale to relevant units.
Ctff = Ctff .* cCTff ;
%ensure Ctff doesn't go below 0 (implying negative discovery).
Ctff = max(0,Ctff);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [value,isterminal,direction] = events(t,V)

%first event: energy prices match
value(1) =  ff_price(V) - re_price(t); %equate price of fossil fuel to price of renewable
isterminal(1) = 1; %stop integration if crossing is found
direction(1) = 1; %only stop if crossing is hit in upward direction

%second event: entire fossil fuel reserve is depleted
value(2) = 0;
isterminal(2) = 1; %stop integration if crossing is found
direction(2) = 0; %stop if crossing is hit in either direction


