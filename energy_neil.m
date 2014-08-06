function [g_warm]  = energy( c_tax )
% Can Homo economicus save us from environmental apocolypse?
% Constants defined here, the functional forms are set up at the bottom
% Most units in grams of carbon, except prices, which is in dollars / gram. 

% Define constants
%
  V0 = 15e17 ; % Initial volume of ff (number is for global conventional oil)
%
  Pr_ff0 = 4.5e-4; % inital cost of fossil fuels (dollars per gram of carbon; number here assumes $50/bbl oil)
%
  t0 = 0 ; % start-time (years since 1850)
%
  tf = 200 ; % end-time (years after 1850)
%
  Cpc = 170 ; % Per capita carbon demand doubling time (linear/constant if inf)
%
  C0 = 1.1e6 / exp( tf * ( log(2) / Cpc) )  ; % original per capita demand (modern global mean emissions are ~4 mt CO2 / person / year,
  %which yields 4e6 * 12/44 = 1.1e6 gC/person/year modern, and we back track to t0 assuming exponential growth )
%
% c_tax = 1.5 ; % taxes increases ff prices if greater than 1, a c_tax of less than 1 implies a ff subsidy.
%
  P0 = 1e9 ; %original population (1e9 is roughly the 1850 pop)
%
  Cpop = 54 ; % population doubling time in years, assuming exponential growth.
%
  CT = 0 ; % technology growth rate (linear)
%
 P_renew = Pr_ff0*2 ; % Price for renewables, random set at double intial ff price


%%%%%%%%%%% Begin the integration %%%%%%%%%%%%%%%%%%%%%%%
% some ODE solver options
  options = odeset('RelTol',1e-4,'AbsTol',[1e-4]);

% Do the numerical interation
  [ t , V ] = ode45(@volume,[t0 tf],[V0],options, CT, Cpc, Cpop, P0 , C0);
  [DVdt,pop] = volume(t, V , CT , Cpc , Cpop , P0 , C0 );

 yr = 1850 + t ;

% Define the price of fossil fuels

 P_ff =  (V0./ V).*Pr_ff0*c_tax  ; %  price change inverse to remaining reserve, V.

% Find where P_ff exceeds P_renew and calculate the C emissions and global warming

 cross_over = min( find( P_ff > P_renew) ) ; % where the prices cross

 c_emitted = V0 - V( cross_over ) ; % How much has been emitted until the cross-over;
 
 g_warm = c_emitted * 1.5 / 1e18 ; % Global warming from these cumulative emissions from CCR (MAthews et al. 2009)  

 g_warm_evolve =  ( V0 - V ) * 1.5 / 1e18 ; % history of the warming

disp( [ 'The amount of carbon emitted before rewables became cheaper: ' num2str(c_emitted/1e18) ' Tt'] )
disp('')
disp(['This would have caused a global warming of ' num2str( g_warm ) ' degrees since pre-industrial'])

disp('')
disp([ '2011 global temp anomaly: ' num2str( g_warm_evolve( yr >= 2010 & yr <= 2013 ) ) ] )
 
% plot up some results
 plot(yr,pop./1e9)
 ylabel('Population (Billions)')
 xlabel('year')

figure
  plot(yr,V)
  xlabel('year')
  ylabel('V, volume of FF remaining')

figure
  plot( yr , (0.*t + P_renew) , '-g' )
  hold on
  plot( yr , P_ff ,'-k')
  xlabel('year')
  ylabel('price')
  legend('renewables','fossils')

figure
  plot( yr , g_warm_evolve )
  xlabel('year')  
  ylabel('Global mean temperature anomaly (^oC)')

%%%%%%%% SET UP THE FUNCTIONS %%%%%%%%%

function [dVdt , pop] = volume( t , y , CT, Cpc , Cpop , P0 , C0)
   	
% DVdt = T - D
%      = CT - pop(t)*Cpc(t)

% Population growth and per capita consuption are being setup as exponential functions here, but could easily be changed.

  pop = P0.* exp( t .* ( log(2) / Cpop) ) ; % exponential population growth  
  
  pcd = C0 .* exp( t .* ( log(2) / Cpc) ) ; % exponential per capita demand growth
   
  dVdt = CT .* t -  pop .* pcd ;
