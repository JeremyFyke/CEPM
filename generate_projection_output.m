plot_params_vs_diags=0
plot_cumulative_emissions_and_warming_pdfs=0
plot_crossover_cdf=0
plot_ensemble_member_details=0
plot_probabalistic_cumulative_emissions=1
plot_probabalistic_emissions=0
plot_mean_ending_cum_emissions=0

t_cross_over=nan(ensemble_size,1);
t_total_depletion=nan(ensemble_size,1);
t_fossil_fuel_emissions_stop=nan(ensemble_size,1);

close all

if plot_params_vs_diags
    
    %USE THESE METHODS:
    %http://www.mathworks.com/help/stats/design-of-experiments-1.html
    
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

if plot_cumulative_emissions_and_warming_pdfs
    figure
    subplot(2,1,1)
    hist([so.tot_emissions],50)
    shading flat
    xlabel('Cumulative emissions (Tt C)')
    ylabel('Number of simulations')
    
    subplot(2,1,2)
    hist([so.net_warming],50)
    shading flat
    xlabel('Net warming (C)')
    ylabel('Number of simulations')

    print('-depsc','figs/cumulative_carbon_warming_pdfs')
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

%common variables follow for paintbrush plots
ensemble_size=length(so);
nbins=400;

if plot_probabalistic_cumulative_emissions
    
    figure
    
    cum_emis_arr=nan(ensemble_size,tf);
    for en=1:ensemble_size
        cum_emis_arr(en,1:length(so(en).cum_emissions))=so(en).cum_emissions;
    end
    
    bin_centers=linspace(0,nanmax(cum_emis_arr(:)),nbins);
    hist_arr=nan(nbins,tf);
    for yr=1:tf
        hist_arr(:,yr)=hist(cum_emis_arr(:,yr),bin_centers);
    end
    hist_arr(hist_arr==0)=nan;
    hist_arrm=hist_arr(:);
    [yearm,cum_emism]=meshgrid(1:tf,bin_centers);
    yearm=yearm(:); yearm(isnan(hist_arrm))=[];
    cum_emism=cum_emism(:); cum_emism(isnan(hist_arrm))=[];    
    hist_arrm(isnan(hist_arrm))=[];
    
    NS=createns([yearm cum_emism]);
    hold on
    for en=1:ensemble_size
        IDX=knnsearch(NS,[so(en).time so(en).cum_emissions]);
        cline([so(en).time] + present_year, [so(en).cum_emissions] , zeros(1,length([so(en).cum_emissions])) , hist_arrm(IDX) , 'jet');
    end
    
    hc=colorbar
    ylabel(hc,'Ensemble density')
    xlabel('Year')
    ylabel('Cumulative emissions (Tt C)')
    axis tight
    %print('-depsc','figs/plot_probabalistic_cumulative_emissions')
    
end

if plot_probabalistic_emissions
    
    figure
    
    emis_arr=nan(ensemble_size,tf);
    for en=1:ensemble_size
        emis_arr(en,1:length(so(en).burn_rate))=so(en).burn_rate;
    end
    
    bin_centers=linspace(0,nanmax(emis_arr(:)),nbins);
    hist_arr=nan(nbins,tf);
    for yr=1:tf
        hist_arr(:,yr)=hist(emis_arr(:,yr),bin_centers);
    end
    hist_arr(hist_arr==0)=nan;
    hist_arrm=hist_arr(:);
    [yearm,emism]=meshgrid(1:tf,bin_centers);
    yearm=yearm(:); yearm(isnan(hist_arrm))=[];
    emism=emism(:); emism(isnan(hist_arrm))=[];    
    hist_arrm(isnan(hist_arrm))=[];
    
    NS=createns([yearm emism]);
    hold on
    for en=1:ensemble_size
        IDX=knnsearch(NS,[so(en).time so(en).burn_rate]);
        cline([so(en).time] + present_year, [so(en).burn_rate] , zeros(1,length([so(en).burn_rate])) , hist_arrm(IDX) , 'jet');
    end
    
    hc=colorbar
    ylabel(hc,'Ensemble density')
    xlabel('Year')
    ylabel('Annual emissions (Tt C/yr)')
    axis tight
    print('-depsc','figs/plot_probabalistic_emissions')
    
end

if plot_mean_ending_cum_emissions
    
    figure
    
    EndYear=floor([so.t_fossil_fuel_emissions_stop]);
    TotEmissions=[so.tot_emissions];
    NetWarming=[so.net_warming];
    nCeasedEmissions=zeros(1,tf);
    IsMinRenewablesReached=zeros(1,tf);
    for en=1:ensemble_size
      FinalRePr(en)=so(en).re_pr(end);
      MinRePr(en)=so(en).LHSparams.Pr_remin .* so(en).LHSparams.Pr_re0./mwh_2_J;
    end
    IsMinRenewablesReached(FinalRePr==MinRePr)=100.;
    for yr=1:tf
      i=find(EndYear==yr+present_year);
      nCeasedEmissions(yr)=numel(i);
      MeanTotCumEmissions(yr)=mean(TotEmissions(i));
      MeanNetWarming(yr)=mean(NetWarming(i));
      MeanIsRenewablesReached(yr)=mean(IsMinRenewablesReached(i));
    end
    year=(1:tf)+present_year;
    
    scatter(year,MeanTotCumEmissions,nCeasedEmissions.*5,MeanIsRenewablesReached,'filled')
    axis tight
    colormap('autumn')
    hc=colorbar
    ylabel(hc,'% of simulations reaching minimum renewable price')
    xlabel('Year')
    ylabel('Cumulative emissions (C)')
  
    print('-depsc','figs/plot_mean_ending_cum_emissions')
    
end

