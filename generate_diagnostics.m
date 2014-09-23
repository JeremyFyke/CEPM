t_cross_over=nan(ensemble_size,1);
t_total_depletion=nan(ensemble_size,1);
t_fossil_fuel_emissions_stop=nan(ensemble_size,1);

%plot diagnostics versus input parameters
%%%diagnostics: 
%1) cross-over time
%2) cumulative emissions
close all

nparams=size(model_parameters,2);

ymin=mean([so.tot_emissions])-2.*std([so.tot_emissions]);
ymax=mean([so.tot_emissions])+2.*std([so.tot_emissions]);
for p=1:nparams
    plot(model_parameters(:,p),[so.tot_emissions],'.')
    xmin=min(model_parameters(:,p));
    xmax=max(model_parameters(:,p));
    lsline
    axis([xmin xmax ymin ymax]);
    xlabel(ParameterName{p});
    ylabel('Total emissions (Tt C)');
    print('-depsc',strcat('figs/',num2str(p),'_sensitivity'))
end

% clf
% hold on
% for n=1:ensemble_size
%     plot(so(n).time+present_year,so(n).cum_emissions)
%     xlabel('Year')
%     ylabel('Cumulative emissions (Tt C)')
% end
% print('-depsc','figs/cumulative_carbon_time_series')

clf
for n=1:ensemble_size
    cdfplot([so.tot_emissions])
    xlabel('Cumulative emissions (Tt C)')
    ylabel('Number of simulations')    
end
print('-depsc','figs/cumulative_carbon_cdf')

clf
for n=1:ensemble_size
    cdfplot([so.net_warming])
    xlabel('Net warming (C)')
    ylabel('Number of simulations')    
end
print('-depsc','figs/cumulative_warming_cdf')


clf
for n=1:ensemble_size
    subplot(2,1,1)
    cdfplot([so.t_cross_over]);
    xlabel('Year')
    ylabel('Number of simulations')
    title('Cross over year cdf')
    ax=axis;ax(1)=2050;ax(2)=2200;axis(ax);
    subplot(2,1,2)
    cdfplot([so.t_fossil_fuel_emissions_stop]);
    xlabel('Year')
    ylabel('Number of simulations')    
    title('Cessation of emissions year cdf')
    ax=axis;ax(1)=2050;ax(2)=2200;axis(ax);
end
print('-depsc','figs/cross_over_cdf')




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
