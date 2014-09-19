t_cross_over=nan(length(n_samples));
t_total_depletion=nan(length(n_samples));
fossil_fuel_emissions_stop=nan(length(n_samples));
for n=1:n_samples
    i=find(which_event{n}==1);
    if (~isempty(i))
        t_cross_over(n)=event_times{n}(i);
    end
    i=find(which_event{n}==2); 
    if (~isempty(i))
        t_total_depletion(n)=event_times{n}(i);
    end    
    i=find(which_event{n}==3); 
    if (~isempty(i))
        t_fossil_fuel_emissions_stop(n)=event_times{n}(i);
    end      
end

%plot diagnostics versus input parameters
%%%diagnostics: 
%1) cross-over time
%2) cumulative emissions
%%%input parameters:
%x
close all

nparams=size(x,2);
for p=1:nparams
    figure
    plot(x(:,p),tot_emissions,'.')
    axis tight
    xlabel(ParameterName{p})
    ylabel('Total emissions (gt C)')
end

figure
for n=1:n_samples
    plot(cum_emissions{n})
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
