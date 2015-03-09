relative_parameter_sensitivities_for_final_cumulative_carbon=0
relative_parameter_sensitivities_at_2100=2
plot_cumulative_emissions_and_warming_pdfs=0
plot_diversity_of_trajectories=0
plot_final_percent_reserves_depleted=0
plot_probabalistic_cumulative_emissions_paintbrush=0
plot_probabalistic_emissions_paintbrush=0
plot_mean_ending_cum_emissions=0
plot_consumption_emission_validation=0
plot_diagnostic_output=0

t_cross_over=nan(ensemble_size,1);
t_total_depletion=nan(ensemble_size,1);
t_fossil_fuel_emissions_stop=nan(ensemble_size,1);


close all

if relative_parameter_sensitivities_for_final_cumulative_carbon  
    figure
    X=[ones(ensemble_size,1) xn];
    y=[so.net_warming]';
    a=X\y; %multiple linear regression, a are regression coefficients
    a=a(2:end);
    [a,I]=sort(abs(a));
    ParameterNameSorted=ParameterName(I);
    a(7)=sum(a(1:7));
    a(1:6)=[];
    ParameterNameSorted=ParameterNameSorted(7:end);
    ParameterNameSorted{1}='Remaining parameters';
    explode=zeros(length(a),1); %Set up TCRE to be detached from rest of pie
    explode(end)=1;
    
    h=pie(a,explode,ParameterNameSorted)
    set(h(2:2:end),'FontSize',20);
    
    print('-depsc','figs/param_sense.eps')
    
    figure
    h=pie(a)
end

if relative_parameter_sensitivities_at_2100 

    figure
    X=[ones(ensemble_size,1) xn];
    tmax=200;
    a=zeros(tmax,size(xn,2));
    for t=1:tmax
        t
        n=0;
        ycorr=zeros(ensemble_size,1);
        xcorr=zeros(size(X));
        for en=1:ensemble_size
            if length(so(en).cum_emissions)>=t;
                n=n+1;
                ycorr(n)=so(en).cum_emissions(t);
                xcorr(n,:)=X(en,:);
            end
        end
        xcorr(n+1:ensemble_size,:)=[];
        ycorr(n+1:ensemble_size)=[];
        lr=xcorr\ycorr; %multiple linear regression, a are regression coefficients
        a(t,:)=abs(lr(2:end));
        a(t,:)=a(t,:)./sum(a(t,:));
    end
    
    [asrt,I]=sort(squeeze(a(end,:)));
    a=a(:,I);
    clear lab
    for n=1:length(I)
        lab{n}=ParameterName{I(n)};
    end
    bar(a,'stack')
    axis tight
    ax=axis;
    ax(1)=2;
    axis(ax)
    legend(lab,'Eastoutside')
    
    error()
    
    [a,I]=sort(abs(a));
    ParameterNameSorted=ParameterName(I);
    a(7)=sum(a(1:7));
    a(1:6)=[];
    ParameterNameSorted=ParameterNameSorted(7:end);
    ParameterNameSorted{1}='Remaining parameters';
    explode=zeros(length(a),1); %Set up TCRE to be detached from rest of pie
    explode(end)=1;
    
    h=pie(a,explode,ParameterNameSorted)
    set(h(2:2:end),'FontSize',20);
    
    print('-depsc','figs/param_sense_at_2100.eps')
    
    figure
    h=pie(a)
end

if plot_cumulative_emissions_and_warming_pdfs
    
    tot_emissions=[so.tot_emissions];
    disp(['Min cumulative emissions=' num2str(min(tot_emissions))]);
    disp(['Max cumulative emissions=' num2str(max(tot_emissions))]);    
    disp(['Cumulative emissions skew=',num2str(skewness(tot_emissions))])
 
    %determine some climate limits
    Tlim(1)=1.6;%Greenland, Robinson et al., 2012
    Tcol{1}=[1 1 0];
    Tlim(2)=2.0;%2C threshold, cite...
    Tcol{2}=[1 0.66 0];    
    Tlim(3)=4.5;%Veg C saturation, Friend et al., 2013
    Tcol{3}=[1 0.33 0];
    Tlim(4)=7.5;%Mammal mortality, Sherwood et al., 2010
    Tcol{4}=[1 0 0];
    Tlimlen=length(Tlim);
    
    [tot_emissions_sorted,I]=sort([so.tot_emissions]);
    net_warming=[so.net_warming];
    net_warming=net_warming(I);
    
    for t=1:Tlimlen
        net_warming_thresh_pass=net_warming>Tlim(t);
        is=find(net_warming_thresh_pass==1,1,'first')+1;
        ie=find(net_warming_thresh_pass==0,1,'last');
        sum_exceeded=cumsum(net_warming_thresh_pass(is:ie));
        emissions{t}=tot_emissions_sorted(is:ie-1);
        frac_exceeded{t}=sum_exceeded./sum_exceeded(end);
        frac_exceeded{t}(end)=[];
    end
    plevels=[5 50 95];
     
    figure
    subplot(2,1,1)
    hold on
    hist([so.tot_emissions],50),shading flat

    q=prctile([so.tot_emissions],plevels);
    ax=axis;
    
    dv=(ax(4)-ax(3))*.05;
    ax(4)=ax(4)+3.*dv;
    ax(4)=ax(4)+3.*dv; %expand upper axis boundary to fit threshold fade bars
    ax(2)=7.;
    for t=1:Tlimlen;
        emissions{t}(end)
        xfade=[emissions{t}(1) emissions{t}(end) emissions{t}(end) emissions{t}(1)];
        xsolid=[emissions{t}(end) ax(2) ax(2) emissions{t}(end)];
        tm1=t-1;
        y=[ax(4)-dv.*tm1 ax(4)-dv.*tm1 ax(4)-dv.*t ax(4)-dv.*t];
        hflfade=fill(xfade,y,'r');
        hflsolid=fill(xsolid,y,'r');
        set(hflfade,'FaceColor','interp','EdgeColor','none');
        set(hflfade,'FaceVertexCData',[1.0 1.0 1.0 ; Tcol{t} ; Tcol{t}; 1.0 1.0 1.0]);
        set(hflsolid,'EdgeColor','none','FaceColor',Tcol{t});
    end
   
    axis(ax)
    line([q(1) q(1)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    line([q(2) q(2)],[ax(3) ax(4)],'linestyle','-','color','k','linewidth',4)
    line([q(3) q(3)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    xlabel('Net cumulative emissions (Tt C)')
    set(gca,'Ytick',[])
    box on
    
    disp(['emissions 5/50/95 percentiles:',num2str(q(1)),'/',num2str(q(2)),'/',num2str(q(3))])

    subplot(2,1,2)
    hist([so.net_warming],50),shading flat
    set(gca,'ytick',[])
    
    p_100=prctile([so.net_warming],1:100);
    
    for t=1:Tlimlen
        disp([num2str(t) ' threshold T percentile:' num2str(find(p_100<Tlim(t),1,'last'))])
        disp([num2str(t) 'threshold max safe emissions:' num2str(emissions{t}(end))]);
    end
    
    xlabel('Net warming (^\circC)')
    ax=axis;
    ax(1)=0.5;ax(2)=13.;
    axis(ax)
    q=prctile([so.net_warming],plevels);
    
    line([q(1) q(1)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    line([q(2) q(2)],[ax(3) ax(4)],'linestyle','-','color','k','linewidth',4)    
    line([q(3) q(3)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    
    box on
    
    disp(['warming 5/50/95 percentiles:',num2str(q(1)),'/',num2str(q(2)),'/',num2str(q(3))])
    disp(['Min warming=' num2str(min([so.net_warming]))]);
    disp(['Max warming=' num2str(max([so.net_warming]))]);
    
    for t=1:length(Tlim);
        line([Tlim(t) Tlim(t)],[ax(3) ax(4)],'linestyle','-','color',Tcol{t},'linewidth',4)
    end
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
    max_burn_rate_49_51=[so(i).burn_rate_max];
    disp(['Maximum peak emissions within 49-51 percentile band=' num2str(max([so(i).burn_rate_max])) ])
    disp(['Minimum peak emissions within 49-51 percentile band=' num2str(min([so(i).burn_rate_max])) ])
end

if plot_final_percent_reserves_depleted
    for i=1:ensemble_size
        clear t
        t=find(so(i).burn_rate==so(i).burn_rate_max)
        cum_emissions_at_max_burn_rate(i)=so(i).cum_emissions(t);
        initial_volume(i)=so(i).LHSparams.V0;
        max_volume(i)=so(i).LHSparams.Vmax;
        tot_emissions(i)=so(i).tot_emissions;
    end
    peak_ff=cum_emissions_at_max_burn_rate./tot_emissions;
    p=prctile(peak_ff,[5 50 95]);
    subplot(2,1,1)
    hist(peak_ff,40)
    shading flat
    title(['5/50/95 percentiles of peak_ff=',num2str(p)])
    subplot(2,1,2)
    percent_depleted=tot_emissions./max_volume;
    p=prctile(percent_depleted,[5 50 95]);
    hist(percent_depleted,40)
    shading flat
    title(['5/50/95 percentiles of ratio of total future emissions to max ff volume=',num2str(p)])

end

%common variables follow for paintbrush plots
ensemble_size=length(so);
nbins=500;

if plot_probabalistic_cumulative_emissions_paintbrush
    
    figure
    hold on
    load_hist_and_RCP_emissions
    %interpolate RCP emissions to yearly frequency
    for nRCP=1:4
        RCPx(nRCP,:)=interp1(RCPyear,RCP(nRCP,:),2013:RCPyear(end));
    end
    RCPyearx=2013:RCPyear(end);
    RCPx=cumsum(RCPx,2);
   
    cum_emis_arr=nan(ensemble_size,tf);
    for en=1:ensemble_size
        cum_emis_arr(en,1:length(so(en).cum_emissions))=so(en).cum_emissions;
    end
    
    bin_centers=linspace(0,nanmax(cum_emis_arr(:)),nbins);
    hist_arr=nan(nbins,tf);
    for yr=1:tf
        e=cum_emis_arr(:,yr);
        hist_arr(:,yr)=hist(e,bin_centers);
        emis_mean(yr)=median(e(~isnan(e)));
    end
    hist_arr(hist_arr==0)=nan;
    
    x=(1:tf)+present_year;
    y=bin_centers;
    pcolor(x,y,hist_arr),shading flat
    plot(x,emis_mean,'b','linewidth',12)
    for nRCP=1:4
        plot(RCPyearx,squeeze(RCPx(nRCP,:)+emissions_to_date),'r','linewidth',4)
        text(RCPyearx(end),squeeze(RCPx(nRCP,end)+emissions_to_date),RCPname{nRCP},'fontsize',30,'color','r')
    end
    axis tight
    ax=axis;
    ax(2)=2300;
    caxis([0 100])
    colormap(copper)
    axis(ax)

    
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
    hold on
    
    load_hist_and_RCP_emissions
   
    emis_arr=nan(ensemble_size,tf);
    for en=1:ensemble_size
        emis_arr(en,1:length(so(en).burn_rate))=so(en).burn_rate;
    end
    
    bin_centers=linspace(0,nanmax(emis_arr(:)),nbins);
    hist_arr=nan(nbins,tf);
    for yr=1:tf
        e=emis_arr(:,yr);
        hist_arr(:,yr)=hist(e,bin_centers);
        emis_mean(yr)=median(e(~isnan(e)));
    end
    hist_arr(hist_arr==0)=nan;
    x=(1:tf)+present_year;
    y=bin_centers;
    pcolor(x,y,hist_arr),shading flat
    colormap(copper)
    caxis([0 100])

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

xlabel('Year')
ylabel('Annual emissions (Tt C/yr)')
hold on
plot(obs_time,obs_emissions,'r--','linewidth',4)
plot(x,emis_mean,'b','linewidth',12)

for nRCP=1:4
    plot(RCPyear(3:end),squeeze(RCP(nRCP,3:end)),'r','linewidth',4)
    text(RCPyear(end),squeeze(RCP(nRCP,end)),RCPname{nRCP},'fontsize',30,'color','r')
end

axis tight
ax=axis;
ax(1)=1980;ax(2)=2300;ax(3)=-0.003;
axis(ax)

print('-depsc','figs/probabalistic_emissions')

end

if plot_mean_ending_cum_emissions
    
    figure
    
    EndYear=floor([so.t_fossil_fuel_emissions_stop]);
    TotEmissions=[so.tot_emissions];
    NetWarming=[so.net_warming];
    nCeasedEmissions=zeros(1,tf);
    IsMinRenewablesReached=zeros(1,ensemble_size);
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
    ax=axis;ax(2)=2300;ax(4)=5.3;axis(ax)
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
    TEDStd=std(TotEnDemand,1);
    TEDMin=TEDMean-TEDStd;
    TEDMax=TEDMean+TEDStd;
    %TEDMin=min(TotEnDemand,[],1);
    %TEDMax=max(TotEnDemand,[],1);
    
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
    TEDStd=std(TotEmissions,1);
    TEDMin=TEDMean-TEDStd;
    TEDMax=TEDMean+TEDStd;
    %TEDMin=min(TotEmissions,[],1);
    %TEDMax=max(TotEmissions,[],1);
    
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

if plot_diagnostic_output
    hold on
    for en=1:ensemble_size
        plot(so(en).time,so(en).re_pr)
    end
end