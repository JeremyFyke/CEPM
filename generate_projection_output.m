plot_params_vs_diags=0
plot_cum_carb_timeseries=0
plot_cumulative_emissions_and_warming_cdf=1
plot_crossover_cdf=0
plot_ensemble_member_details=0

t_cross_over=nan(ensemble_size,1);
t_total_depletion=nan(ensemble_size,1);
t_fossil_fuel_emissions_stop=nan(ensemble_size,1);

if plot_params_vs_diags
    %plot diagnostics versus input parameters
    %%%diagnostics:
    %1) cross-over time
    %2) cumulative emissions
    figure
    
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
end

if plot_cum_carb_timeseries
    figure
    hold on
    for n=1:ensemble_size
        plot(so(n).time+present_year,so(n).cum_emissions)
        xlabel('Year')
        ylabel('Cumulative emissions (Tt C)')
    end
    print('-depsc','figs/cumulative_carbon_time_series')
end

if plot_cumulative_emissions_and_warming_cdf
    figure
    for n=1:ensemble_size
        cdfplot([so.tot_emissions])
        xlabel('Cumulative emissions (Tt C)')
        ylabel('Number of simulations')
    end
    print('-depsc','figs/cumulative_carbon_cdf')
    
    figure
    for n=1:ensemble_size
        cdfplot([so.net_warming])
        xlabel('Net warming (C)')
        ylabel('Number of simulations')
    end
    print('-depsc','figs/cumulative_warming_cdf')
end

if plot_crossover_cdf
    figure
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
end

if plot_ensemble_member_details
    figure
    n=1;
    subplot(4,1,1)
    plot(so(n).cum_emissions)
    ylabel('cumulative emissions')
    axis tight
    subplot(4,1,2)
    hold on
    h(1)=plot(so(n).ff_pr,'r');
    h(2)=plot(so(n).re_pr,'g');
    legend(h,{'fossil fuel price','renewable price'})
    axis tight
    subplot(4,1,3)
    plot(so(n).ff_volume)
    ylabel('fossil fuel volume')
    axis tight
    subplot(4,1,4)
    hold on
    h(1)=plot(so(n).burn_rate,'r');
    h(2)=plot(so(n).discovery_rate,'b')  ;  
    legend({'burn rate','discovery rate'})
    axis tight
end



%%TO DO: compare CDIAC emission trends with initial burn rates, and burn
%%rate trends.


