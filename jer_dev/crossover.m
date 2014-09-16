%% Run energy crossover model multiple times for a range of parameters.
%% Plot resulting spread in crossover times and cumulative emissions.

close all
clear all

set_global_constants

%Set median values
n= 0 ;
n=n+1 ; iV0 = n     ; v(n) = 1.5e18 ;    % Conventional reserves (gC, http://archive.greenpeace.org/climate/science/reports/carbon/clfull-3.html#Heading23)
n=n+1 ; iPr_ff0 = n ; v(n) = 50.    ;    % Initial cost of fossil fuels ($/bbl oil, typical numbers)
n=n+1 ; iPr_re0 = n ; v(n) = 350.   ;    % Initial cost of renewables ($/MWh, from UofM Energy Institute Technical Paper "Renewable Energy Technology Review")
n=n+1 ; ic_tax = n  ; v(n) = 1.     ;    %Taxes increase ff prices if greater than 1, a c_tax of less than 1 implies a ff subsidy.
n=n+1 ; icCTff = n  ; v(n) = 1.e20  ;    %(J/yr) %'efficiency' of technology improvements to fossil fuel extraction.  Arbitrary and not yet constrained by data.
n=n+1 ; iCTre = n   ; v(n) = -3.    ;    %($/MWh/yr) % rate of price change of renewables (roughly from UofM Energy Institute Technical Paper "Renewable Energy Technology Review")
n=n+1 ; ipopmax = n ; v(n) = 9.e9  ;     %projected maximum population (Nature climate change population special issue)
n=n+1 ; ipcdmax = n ; v(n) = 8..*42.e9 ; %projected maximum per-capita energy consumption (typical North American energy consumption in tons of oil, multiplied by energy density of oil)

variable_scale = 0.4 ; %assign uniform multiplicative spread to each variable
lb = v - v.*variable_scale ;
ub = v + v.*variable_scale ;

%Set ensemble size
n_samples = 500 ;

%generate parameter arrays
disp('Generating Latin Hypercube...')
xn = lhsdesign(n_samples,n);
x = bsxfun(@plus,lb,bsxfun(@times,xn,(ub-lb)));

for n=1:n_samples
    disp(['Running ensemble number' num2str(n)])
    [time{n},...
        ff_volume{n},...
        event_times{n},...
        solution_values{n},...
        which_event{n},...
        dVdt{n},...
        burn_rate{n},...
        ff_fraction{n},...
        ff_pr{n},...
        re_pr{n}]...
        = energy(x(n,:));
        
        emissions{n}=burn_rate{n}.* J_2_gC ./ 1.e18 ;
        cum_emissions{n}=cumsum(emissions{n}) + emissions_to_date;
        event_times{n}=event_times{n} + present_year;
        tot_emissions(n)=cum_emissions{n}(end);
        
end

hold on
for n=1:n_samples
    which_event{n}
    event_times{n}
    plot(emissions{n})
end
figure
for n=1:n_samples
    hist(tot_emissions,30)
end

%     %Output some results here
%     if time(end)<tf;
%         disp( [ 'The year renewables became cheaper than fossil fuel: ' num2str(floor(yr(end)))] )
%         disp('')
%         disp( [ 'The amount of carbon emitted before emission end: ' num2str(cum_emissions(end)) ' Tt'] )
%         disp('')
%         disp(['This would cause an equilibrium global warming of ' num2str( g_warm(end) ) ' degrees since pre-industrial'])
%         disp('')
%         disp([ '2011 global temp anomaly: ' num2str( g_warm( yr == 2011 ) ) ] )
%         disp('')
%         disp([ '2011 cumulative emissions: ' num2str( cum_emissions( yr == 2011 ) ) ] )
%     else
%         disp( [ 'Fossil fuels were still cheaper than renewables at end of integration (year ' num2str(cross_date) ')' ] )
%     end
%     fig1=figure;
%     scnsize=get(0,'Monitorpositions');
%     set(fig1,'Position',scnsize(1,:));
%     subplot(2,4,1)
%     plot(yr(2:end),cum_emissions)
%     ylabel('Cumulative emissions (Tt C)')
%     xlabel('year')
%     axis tight
%     subplot(2,4,2)
%     plot(yr(2:end),yearly_emissions)
%     ylabel('Yearly emissions (Tt C/yr)')
%     xlabel('year')
%     axis tight
%     subplot(2,4,3)
%     plot(yr,population(t) ./ 1e9)
%     ylabel('Population (Billions)')
%     xlabel('year')
%     axis tight
%     subplot(2,4,4)
%     plot(yr,ff_volume.* J_2_gC ./ 1.e18)
%     xlabel('year')
%     axis tight
%     ylabel('V, volume of FF remaining (Tt C)')
%     subplot(2,4,5)
%     plot( yr , ff_price( ff_volume ) .* kwh_2_J .* 100. , '-g' )
%     hold on
%     plot( yr , re_price( t ) .* kwh_2_J .* 100. ,'-k')
%     xlabel('year')
%     ylabel('Price (cents per kilowatt hour)')
%     legend('fossils','renewables', 'Location','Southeast')
%     axis tight
%     hold off
%     subplot(2,4,6)
%     plot( yr(2:end) , g_warm )
%     xlabel('year')
%     ylabel('Equilib temperature anomaly (^oC)')
%     axis tight
%     subplot(2,4,7)
%     plot( yr , res_increase )
%     xlabel('year')
%     ylabel('Increase in fossil fuel reservoir (Tt C)')
%     axis tight
%
%     fig1=figure;
%     scnsize=get(0,'Monitorpositions');
%     set(fig1,'Position',scnsize(1,:));
%     subplot(3,1,1)
%     scatter(cross_dates(:),total_emissions(:),'Filled','SizeData',2)
%     xlabel('Cross-over year'),ylabel('Total emissions (Gt C)')
%     subplot(3,1,2)
%     histfit(cross_dates,100,'gamma')
%     xlabel('Cross-over (year)'),ylabel('# of models')
%     title(['50^{th} percentile crossover year: ' num2str(round(prctile(cross_dates,50)))])
%     subplot(3,1,3)
%     histfit(total_emissions,50,'gamma')
%     title(['50^{th} percentile cumulative emissions: ' num2str(round(prctile(total_emissions,50).*10.)./10.) ' Tt C'])
%     xlabel('Total emissions (Tt C)'),ylabel('# of models')
%
% elseif run_type == 1
%
%     %run one model, with median values.  Note output for single runs experiments is
%     %within the energy routine at the moment.
%     [total_emissions,cross_dates] = energy(v);
%
% end
