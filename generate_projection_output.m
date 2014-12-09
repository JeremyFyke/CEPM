plot_params_vs_diags=0
plot_cumulative_emissions_and_warming_pdfs=0
plot_diversity_of_trajectories=0
plot_final_percent_reserves_depleted=0
plot_crossover_cdf=0
plot_ensemble_member_details=0
plot_probabalistic_cumulative_emissions_paintbrush=0
plot_probabalistic_emissions_paintbrush=1
plot_mean_ending_cum_emissions=0
plot_consumption_emission_validation=0


t_cross_over=nan(ensemble_size,1);
t_total_depletion=nan(ensemble_size,1);
t_fossil_fuel_emissions_stop=nan(ensemble_size,1);


close all

if plot_params_vs_diags  
    figure
    X=[ones(size(xn,1),1) xn];
    a=X\y; %multiple linear regression, a are regression coefficients
    a=a(2:end);
    [a,I]=sort(abs(a));
    ParameterNameSorted=ParameterName(I);
    a(7)=sum(a(1:7));
    a(1:6)=[];
    ParameterNameSorted=ParameterNameSorted(7:end);
    ParameterNameSorted{1}='Remaining parameters';
    explode=zeros(length(a),1);
    explode(end)=1;
    h=pie(a,explode,ParameterNameSorted)
    set(h(2:2:end),'FontSize',20);
end

if plot_cumulative_emissions_and_warming_pdfs
    
    tot_emissions=[so.tot_emissions];
    
    disp(['Cumulative emissions skew=',num2str(skewness(tot_emissions))])
 
    %determine some climate limits
    GIS_lim=1.6;
    cdf=cumsum([so.net_warming]<GIS_lim);%Robinson et al., 2012
    i=find(cdf==max(cdf),1,'first');
    GIS_lime=[so(i).tot_emissions so(i).tot_emissions];
 
    Mort_lim=7.;
    cdf=cumsum([so.net_warming]<Mort_lim);%Sherwood et al., 2010
    i=find(cdf==max(cdf),1,'first');
    Mort_lime=[so(i).tot_emissions so(i).tot_emissions];  
    
    Veg_C_lim=4.;
    cdf=cumsum([so.net_warming]<Veg_C_lim);%Friend et al., 2013
    i=find(cdf==max(cdf),1,'first');
    Veg_C_lime=[so(i).tot_emissions so(i).tot_emissions];      
    
    plevels=[5 50 95];
    
    figure
    subplot(2,1,1)
    hold on
    hist([so.tot_emissions],50)
    shading flat
    xlabel('Cumulative emissions (Tt C)')
    ylabel('Number of simulations')
    q=prctile([so.tot_emissions],plevels);
    
    line([q(1) q(1)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    line([q(2) q(2)],[ax(3) ax(4)],'linestyle','-','color','k','linewidth',4)
    line([q(3) q(3)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    
    box on
    
    disp(['emissions 5/50/95 percentiles:',num2str(q(1)),'/',num2str(q(2)),'/',num2str(q(3))])
    
    subplot(2,1,2)
    hist([so.net_warming],50)
    shading flat
    xlabel('Net warming (C)')
    ylabel('Number of simulations')
    ax=axis;
    
    q=prctile([so.net_warming],plevels);
    
    line([q(1) q(1)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    line([q(2) q(2)],[ax(3) ax(4)],'linestyle','-','color','k','linewidth',4)    
    line([q(3) q(3)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    
     box on
    
    disp(['warming 5/50/95 percentiles:',num2str(q(1)),'/',num2str(q(2)),'/',num2str(q(3))])    

    line([GIS_lim GIS_lim],[ax(3) ax(4)],'linestyle','-','color','r','linewidth',4)
    line([Mort_lim Mort_lim],[ax(3) ax(4)],'linestyle','-','color','y','linewidth',4)
    line([Veg_C_lim Veg_C_lim],[ax(3) ax(4)],'linestyle','-','color','g','linewidth',4)
    print('-depsc','figs/cumulative_carbon_warming_pdfs')
end

if plot_diversity_of_trajectories
    q=prctile([so.tot_emissions],[49 51]);
    i=find([so.tot_emissions]>q(1) & [so.tot_emissions]<q(2));
    hold on
    for en=i
        plot(so(en).time+present_year,so(en).burn_rate,'k','linewidth',1)
    end
    title('49th-51th percentile simulations')
    xlabel('Year')
    ylabel('Emissions (Tt C/yr)')
    
end

if plot_final_percent_reserves_depleted
    for i=1:ensemble_size
      initial_volume(i)=  so(i).LHSparams.V0;
      max_volume(i)=so(i).LHSparams.Vmax;
      tot_emissions(i)=so(i).tot_emissions-emissions_to_date;
    end
    percent_depleted=tot_emissions./initial_volume;
    p=prctile(percent_depleted,[5 50 95]);
    subplot(2,1,1)
    hist(percent_depleted,40)
    shading flat
    title(['5/50/95 percentiles of ratio of total future emissions to initial ff volume=',num2str(p)])
    subplot(2,1,2)
    percent_depleted=tot_emissions./max_volume;
    p=prctile(percent_depleted,[5 50 95]);
    hist(percent_depleted,40)
    shading flat
    title(['5/50/95 percentiles of ratio of total future emissions to max ff volume=',num2str(p)])
       
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
nbins=500;

if plot_probabalistic_cumulative_emissions_paintbrush
    
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
    
	pcolor(hist_arr),shading flat
	
    axis tight  
	ax=axis;
	ax(2)=550;
	axis(ax)
	tickvals=get(gca,'Ytick');
	set(gca,'YTicklabel',bin_centers(tickvals));
	tickvals=get(gca,'Xtick');
	set(gca,'XTicklabel',[tickvals+present_year])
	caxis([0 50])
    
    %hist_arrm=hist_arr(:);
    %[yearm,cum_emism]=meshgrid(1:tf,bin_centers);
    %yearm=yearm(:); yearm(isnan(hist_arrm))=[];
    %cum_emism=cum_emism(:); cum_emism(isnan(hist_arrm))=[];    
    %hist_arrm(isnan(hist_arrm))=[];
    %NS=createns([yearm cum_emism]);
    %hold on
    %for en=1:ensemble_size
    %    IDX=knnsearch(NS,[so(en).time so(en).cum_emissions]);
    %    cline([so(en).time] + present_year, [so(en).cum_emissions] , zeros(1,length([so(en).cum_emissions])) , hist_arrm(IDX) , 'jet');
    %    if en==1
    %      caxis([1 5])
    %    end
    %end
    
    %hc=colorbar;
    %ylabel(hc,'Ensemble density')
    xlabel('Year')
    ylabel('Cumulative emissions (Tt C)')
    
    print('-depsc','figs/probabalistic_cumulative_emissions')
    
end

if plot_probabalistic_emissions_paintbrush
    
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
    
    pcolor(hist_arr),shading flat
    ax=axis;
    axis tight
    ax(2)=550;
    ax(3)=0;
    axis(ax)
    tickvals=get(gca,'Ytick');
    tickvals=tickvals(2:end);
    ticklabels=bin_centers(tickvals-49);
    set(gca,'YTicklabel',ticklabels); %49 a little hacky here... just used to bump first index down to first bin...
    tickvals=get(gca,'Xtick');
    set(gca,'XTicklabel',tickvals+present_year)
    caxis([0 50])
    
%     hist_arrm=hist_arr(:);
%     [yearm,emism]=meshgrid(1:tf,bin_centers);
%     yearm=yearm(:); yearm(isnan(hist_arrm))=[];
%     emism=emism(:); emism(isnan(hist_arrm))=[];    
%     hist_arrm(isnan(hist_arrm))=[];
%     
%     NS=createns([yearm emism]);
%     hold on
%     for en=1:ensemble_size
%         IDX=knnsearch(NS,[so(en).time so(en).burn_rate]);
%         cline([so(en).time] + present_year, [so(en).burn_rate] , zeros(1,length([so(en).burn_rate])) , hist_arrm(IDX) , 'jet');
%         if en==1
%             caxis([1 5])
%         end
%     end
    
    %hc=colorbar;
    %ylabel(hc,'Ensemble density')
    %xlabel('Year')
    ylabel('Annual emissions (Tt C/yr)')
    
    print('-depsc','figs/probabalistic_emissions')
    
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
    hold on
    scatter(year,MeanTotCumEmissions,nCeasedEmissions.*5,MeanIsRenewablesReached,'filled')
    ie=find(~isnan(MeanTotCumEmissions) & nCeasedEmissions>1);
    p=polyfit(year(ie),MeanTotCumEmissions(ie),4);
    plot(year(ie(1):ie(end)),polyval(p,year(ie(1):ie(end))),'k','linewidth',2)
    axis tight
    ax=axis;ax(2)=max(year(ie));ax(4)=5.3;axis(ax)
    colormap('jet')
    hc=colorbar
    ylabel(hc,'% of simulations reaching minimum renewable price')
    xlabel('Year')
    ylabel('Year-mean cumulative emissions (Tt C)')
  
    print('-depsc','figs/mean_ending_cum_emissions')
    
end

if plot_consumption_emission_validation
    
    h=subplot(2,1,1)
    subplot_label(h,-0.1,0.9,'a)',25)
    %Observed global consumption rates, 1980-2012.
    data=xlsread('data/Total_Primary_Energy_Consumption_(Quadrillion_Btu).xls');
    obs_consumption=data(3,1:end-1).*quads_2_J./1.e18; %To EJ
    obs_time=data(1,1:end-1);
    p=polyfit(obs_time,obs_consumption,1);
    obs_consumption_fit=polyval(p,obs_time);
    nval=30;
    
    TotEnDemand=zeros(ensemble_size,nval);
    for en=1:ensemble_size
        TotEnDemand(en,:)=so(en).tot_en_demand(1:nval)./1.e18; %To EJ
    end
    mod_time=so(en).time(1:nval)+present_year;
    TEDMean=mean(TotEnDemand,1);
    TEDMin=min(TotEnDemand,[],1);
    TEDMax=max(TotEnDemand,[],1);
    
    disp(['historical consumption trend=' num2str(p(1))])
    p=polyfit(mod_time,TEDMean',1);
    disp(['simulated mean consumption trend=' num2str(p(1))]) 
    p=polyfit(mod_time,TEDMin',1);
    disp(['simulated min consumption trend=' num2str(p(1))])     
    p=polyfit(mod_time,TEDMax',1);
    disp(['simulated max consumption trend=' num2str(p(1))]) 
    
    hold on
    h(1)=plot(obs_time,obs_consumption,'b--','linewidth',2);
    h(2)=plot(obs_time,obs_consumption_fit,'b','linewidth',2);    
    h(3)=errorbar(mod_time,TEDMean,TEDMean-TEDMin,TEDMax-TEDMean,'r','linewidth',2);
    legend(h,{'Observed consumption' 'Observed consumption linear fit' 'Simulated consumption'},'Location','Northwest');
    axis tight
    %ax=axis;ax(3)=0;axis(ax)
    %title('Global energy demand')
    xlabel('Year')
    ylabel('Exajoules (EJ)')
    
    %%%
    h=subplot(2,1,2)
    subplot_label(h,-0.1,0.9,'b)',25)
    %Observed global emission rates, 1980-2010.
    data=load('data/global.1751_2010.ems');
    obs_emissions=data(end-30:end,2)./1.e6;
    obs_time=data(end-30:end,1);
    p=polyfit(obs_time,obs_emissions,1);
    obs_emissions_fit=polyval(p,obs_time);
    nval=30;
    
    TotEmissions=zeros(ensemble_size,nval);
    for en=1:ensemble_size
        TotEmissions(en,:)=so(en).burn_rate(1:nval);
    end
    mod_time=so(en).time(1:nval)+present_year;
    TEDMean=mean(TotEmissions,1);
    TEDMin=min(TotEmissions,[],1);
    TEDMax=max(TotEmissions,[],1);
    
    disp(['historical emission trend=' num2str(p(1))])
    p=polyfit(mod_time,TEDMean',1);
    disp(['simulated mean emission trend=' num2str(p(1))]) 
    p=polyfit(mod_time,TEDMin',1);
    disp(['simulated min emission trend=' num2str(p(1))])     
    p=polyfit(mod_time,TEDMax',1);
    disp(['simulated max emission trend=' num2str(p(1))]) 
    
    hold on
    h(1)=plot(obs_time,obs_emissions,'b--','linewidth',2);
    h(2)=plot(obs_time,obs_emissions_fit,'b','linewidth',2);    
    h(3)=errorbar(mod_time,TEDMean,TEDMean-TEDMin,TEDMax-TEDMean,'r','linewidth',2);
    legend(h,{'Observed emissions' 'Observed emissions linear fit' 'Simulated emissions'},'Location','Northwest');
    axis tight
    %ax=axis;ax(3)=0;axis(ax)
    %title('Global energy demand')
    xlabel('Year')
    ylabel('Tt C') 
    
    print('-depsc','figs/consumption_emission_validation')
    
end