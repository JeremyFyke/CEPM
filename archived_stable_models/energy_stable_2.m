function energy
clear all
close all
% Can Homo economicus save us from environmental apocolypse?
% Constants defined here, the functional forms are set up at the bottom
% Main units are Joules.

global  J_2_gC...
        V0...
        Pr_ff0...
        CTff...        
        Pr_re0...
        CTre...
        t0...
        tf...
        Cpc...
        C0...
        c_tax...
        P0...
        Cpop...
    
%%%% Define constants %%%%
J_2_gC =        2.0e-5;  %gC/Joule based on conventional oil energy density
bbl_2_gC =      1.14e5 ; %gC/barrel
%Initial volume of fossil fuels (J)
V0 = 15.e17 ;         % Conventional reserves (gC)
V0 = V0 ./ J_2_gC ;   % Conventional reserves (J)
%Initial cost of fossil fuels ($/J)
Pr_ff0 = 50. ;        % ($/bbl oil)
Pr_ff0 = Pr_ff0 .* bbl_2_gC ; % ($/gC)
Pr_ff0 = Pr_ff0 .* J_2_gC ; % ($/J)
%Price for renewables, random set at double intial ff price
Pr_re0 = Pr_ff0*2 ;
%Start-time, end-time (0 = year 1850)
t0 = 0. ;
tf = 200. ;
%Per capita carbon demand doubling time (linear/constant if inf).
%Original per capita demand (modern global mean emissions are ~4 mt CO2 / person / year,
%which yields 4e6 * 12/44 = 1.1e6 gC/person/year modern, and we back track
%to t0 at 1850 assuming exponential growth )
Cpc = 170. ; % (yr)
C0 = 1.1e6 ./ J_2_gC ./ exp( 150. * ( log(2) / Cpc) )  ;
%Taxes increases ff prices if greater than 1, a c_tax of less than 1 implies a ff subsidy.
c_tax = 1. ; % (%)
%Original population (1e9 is roughly the 1850 pop)
P0 = 1.e9 ;
%Population doubling time in years, assuming exponential growth.
Cpop = 54 ;
%Rate of fossil fuel reservoir increase (J/yr).  Proxy for technology
%improvements to fossil fuel extraction.
CTff = 0. ;
%Linear renewable technology cost evolution rate ($/J/yr)
CTre = - Pr_re0*5.e-4 ; %Jer: random number here
 
%%%%%%%%%%% Do the integration %%%%%%%%%%%%%%%%%%%%%%%
% set some ODE solver options and do the numerical interation
options = odeset('RelTol',1e-4,'AbsTol',1e-4,'Events',@events);
[ t , V ] = ode45(@volume,t0:1:tf,V0,options);
%
%%%%%%%%%%% Make some output %%%%%%%%%%%%%%%%%%%%%%%
yr = 1850 + t ;
%Calculate cumulative emissions
yearly_emissions = population(t) .* per_cap_demand(t) .* J_2_gC ;
cum_emissions = cumsum ( yearly_emissions ) ;
g_warm = cum_emissions (end) * 1.5 / 1e18 ; % Global warming from these cumulative emissions from CCR (MAthews et al. 2009)
g_warm_evolve =  ( cum_emissions ) * 1.5 / 1.e18 ; % history of the warming

disp( [ 'The year renewables became cheaper than fossil fuel: ' num2str(floor(yr(end)))] )
disp('')
disp( [ 'The amount of carbon emitted before renewables became cheaper: ' num2str(cum_emissions(end)/1.e18) ' Tt'] )
disp('')
disp(['This would cause an equilibrium global warming of ' num2str( g_warm ) ' degrees since pre-industrial'])
disp('')
disp([ '2011 global temp anomaly: ' num2str( g_warm_evolve( yr == 2011 ) ) ] )

% plot up some results

fig1=figure;
scnsize=get(0,'Monitorpositions');
set(fig1,'Position',scnsize(1,:));
subplot(3,2,1)
plot(yr,cum_emissions)
ylabel('Cumulative emissions (gC)')
xlabel('year')
axis tight
subplot(3,2,2)
plot(yr,yearly_emissions)
ylabel('Yearly emissions (gC/yr)')
xlabel('year')
axis tight
subplot(3,2,3)
plot(yr,population(t)./1e9)
ylabel('Population (Billions)')
xlabel('year')
axis tight
subplot(3,2,4)
plot(yr,V.* J_2_gC)
xlabel('year')
axis tight
ylabel('V, volume of FF remaining (gC)')
subplot(3,2,5)
plot( yr , ff_price( V ) , '-g' )
hold on
plot( yr , re_price( t ) ,'-k')
xlabel('year')
ylabel('Price')
legend('fossils','renewables', 'Location','Southeast')
axis tight
hold off
subplot(3,2,6)
plot( yr , g_warm_evolve )
xlabel('year')
ylabel('Global mean temperature anomaly (^oC)')
axis tight

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dVdt] = volume( t , V )

global CTff

% DVdt = T - D
%      = CT - pop(t)*Cpc(t)

dVdt = CTff .* t -  population(t) .* per_cap_demand(t) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pop] = population( t )

global P0 Cpop 

pop = P0 .* exp( t .* ( log(2) / Cpop) ) ; % exponential population growth
pop = min( 14.e9 , pop );                  %maximum population of 14 billion people

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pcd] = per_cap_demand( t ) 

global C0 Cpc

pcd = C0 .* exp( t .* ( log(2) / Cpc) ) ; % exponential per capita demand growth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pr_ff] = ff_price( V )
 
global V0 Pr_ff0 c_tax

Pr_ff =  (V0./ V) .* Pr_ff0 .* c_tax  ; %  price change inverse to remaining reserve, V.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pr_re] = re_price( t )

global Pr_re0 CTre

Pr_re = Pr_re0 + CTre .*t ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [value,isterminal,direction] = events(t,V)

%first event: energy prices match
value(1) =  ff_price(V) - re_price(t); %equate price of fossil fuel to price of renewable
isterminal(1) = 1; %stop integration if crossing is found
direction(1) = 0; %stop if crossing is hit in either direction

%second event: entire fossil fuel reserve is depleted
value(2) = 0;
isterminal(2) = 1; %stop integration if crossing is found
direction(2) = 0; %stop if crossing is hit in either direction


