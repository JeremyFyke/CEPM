%     Cumulative Emissions Projection Model (CEPM).
%     Copyright (C) 2015 Jeremy Fyke
%   
%     This file is part of CEPM.
% 
%     CEPM is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     CEPM is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CEPM.  If not, see <http://www.gnu.org/licenses/>.

relative_parameter_sensitivities_for_final_cumulative_carbon=0
    plot_parameter_value_vs_cumulative_emissions=0
relative_parameter_sensitivities_at_2100=0
plot_cumulative_emissions_and_warming_pdfs=0
plot_final_percent_reserves_depleted=0
plot_paintbrushes=0
plot_mean_ending_cum_emissions=0
plot_consumption_emission_validation=0
plot_diagnostic_output=0
plot_diversity_of_trajectories=0

t_cross_over=nan(c.ensemble_size,1);
t_total_depletion=nan(c.ensemble_size,1);
t_fossil_fuel_emissions_stop=nan(c.ensemble_size,1);

timeaxislimit=2500;

close all

if relative_parameter_sensitivities_for_final_cumulative_carbon
    figure
    
    for n=1:size(model_parameters,2)
        tmp=model_parameters(:,n);
        normalized_model_parameters(:,n) = (tmp-min(tmp)) ./ (max(tmp)-min(tmp));
    end
    
    X=[ones(c.ensemble_size,1) normalized_model_parameters];
    y=[so.net_warming]';
    a=X\y; %multiple linear regression, a are regression coefficients
    a=a(2:end);
    [a,I]=sort(abs(a));
    
    ParameterNameSorted={p(I).ParameterName}
    
    a(7)=sum(a(1:7));
    a(1:6)=[];
    ParameterNameSorted=ParameterNameSorted(7:end);
    ParameterNameSorted{1}='Remaining parameters';
    explode=zeros(length(a),1); %Set up TCRE to be detached from rest of pie
    explode(end)=1;
    
    h=pie(a,explode,ParameterNameSorted)
    set(h(2:2:end),'FontSize',20);
    
    %colormap(copper)
    
    print('-depsc','figs/param_sense.eps')
    
    figure
    h=pie(a)
    
    if plot_parameter_value_vs_cumulative_emissions
        net_warming=[so.net_warming];
        n=0;
        for pp=fliplr(I)'
	    n=n+1
            param=zeros(c.ensemble_size,1);
            for en=1:c.ensemble_size
                param(en)=so(en).LHSparams(pp);
            end

            figure
            colormap(copper(1000))
            scatter(param,net_warming,10,net_warming,'o','fill')
            axis tight
            P=polyfit(param,net_warming',1);
            xlabel(sprintf('%s (%s)',p(pp).ParameterName,p(pp).ParameterUnits))
            ylabel('Net warming (C)')
            text(0.1,0.9,sprintf('y=%fx+%f',P(1),P(2)),'Units','normalized','fontsize',30)
            
            print('-depsc',strcat('figs/parameter',num2str(n),'scatter.eps'))
            
        end
    end
    
    
end

if relative_parameter_sensitivities_at_2100
    
    figure
    X=[ones(c.ensemble_size,1) normalized_model_parameters];
    tmax=200;
    a=zeros(tmax,size(normalized_model_parameters,2));
    for t=1:tmax
        t
        n=0;
        ycorr=zeros(c.ensemble_size,1);
        xcorr=zeros(size(X));
        for en=1:c.ensemble_size
            if length(so(en).cum_emissions)>=t;
                n=n+1;
                ycorr(n)=so(en).cum_emissions(t);
                xcorr(n,:)=X(en,:);
            end
        end
        xcorr(n+1:c.ensemble_size,:)=[];
        ycorr(n+1:c.ensemble_size)=[];
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
        %frac_exceeded{t}=sum_exceeded./sum_exceeded(end);
        %frac_exceeded{t}(end)=[];
    end
    plevels=[5 50 95];
    nbins=100;
    
    bin_array=linspace(0,8,nbins);
    
    for param=1:1
        hhist=hist([so.tot_emissions],bin_array),shading flat;
        [n,x]=hist([so.tot_emissions],bin_array);
        dbin=mean(diff(bin_array))./2;
        for bin=1:nbins
         %identify all simulations that fall within bin range
         i=find([so.tot_emissions]>bin_array(bin)-dbin & [so.tot_emissions]>bin_array(bin)+dbin);
         
        end
        
    end
    
    figure
    hfig=subplot(2,1,1);
    hold on
    hist([so.tot_emissions],linspace(0,8,nbins)),shading flat
    set(findobj(gca,'Type','patch'),'FaceColor',[0 0 1]);
    
    qemissions=prctile([so.tot_emissions],plevels);
    ax=axis;
    
    dv=(ax(4)-ax(3))*.05;
    ax(4)=ax(4)+3.*dv;
    ax(4)=ax(4)+3.*dv; %expand upper axis boundary to fit threshold fade bars
    
    for t=1:Tlimlen;
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
    line([qemissions(1) qemissions(1)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    line([qemissions(2) qemissions(2)],[ax(3) ax(4)],'linestyle','-','color','k','linewidth',4)
    line([qemissions(3) qemissions(3)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    xlabel('Cumulative emissions (Tt C)')
    ylabel('# simulations')

    box on
    ax=axis
    ax(1)=0;ax(2)=7;
    axis(ax)
    
    subplot_label(hfig,-0.1,0.9,'(a)',20)
    %
    %      h=axes handle
    %  x=normalized distance from left
    %  y=normalized distance from bottom
    %  l=text
    %  s=text size
    
    hfig=subplot(2,1,2);
    
    hist([so.net_warming],linspace(0,15,nbins)),shading flat
    set(findobj(gca,'Type','patch'),'FaceColor',[0 0 1]);
        
    xlabel('Emissions-induced warming (^\circC)')
    ylabel('# simulations')
    ax=axis;
    ax(1)=0.;ax(2)=13.;
    axis(ax)
    qtemperature=prctile([so.net_warming],plevels);
    
    line([qtemperature(1) qtemperature(1)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    line([qtemperature(2) qtemperature(2)],[ax(3) ax(4)],'linestyle','-','color','k','linewidth',4)
    line([qtemperature(3) qtemperature(3)],[ax(3) ax(4)],'linestyle','--','color','k','linewidth',3)
    
    box on
    
    for t=1:length(Tlim);
        line([Tlim(t) Tlim(t)],[ax(3) ax(4)],'linestyle','-','color',Tcol{t},'linewidth',4)
    end
    
    subplot_label(hfig,-0.1,0.9,'(b)',20)

    
    print('-depsc','figs/cumulative_carbon_warming_pdfs')
    
    % SOME DISPLAY OUTPUT, AND OUTPUT WRITTEN TO .TEX FILE
    disp(['emissions 5/50/95 percentiles:',num2str(qemissions(1)),'/',num2str(qemissions(2)),'/',num2str(qemissions(3))])

    
    disp(['warming 5/50/95 percentiles:',num2str(qtemperature(1)),'/',num2str(qtemperature(2)),'/',num2str(qtemperature(3))])

    
    p_100=prctile([so.net_warming],1:100);
    for t=1:Tlimlen
        disp([num2str(t) ' threshold T percentile:' num2str(find(p_100<Tlim(t),1,'last'))])
        disp([num2str(t) 'threshold max safe emissions:' num2str(emissions{t}(end))]);
    end
    
end

if plot_diversity_of_trajectories
    q=prctile([so.tot_emissions],[49 51]);
    i49_51_percentiles=find([so.tot_emissions]>q(1) & [so.tot_emissions]<q(2));
    hold on
    for en=i49_51_percentiles
        plot(so(en).time+c.start_year,so(en).burn_rate,'k','linewidth',1)
    end
    title('49th-51th percentile simulations')
    xlabel('Year')
    ylabel('Emissions (Tt C/yr)')
    disp(['Maximum peak emissions within 49-51 percentile band=' num2str(max([so(i49_51_percentiles).burn_rate_max])) ])
    disp(['Minimum peak emissions within 49-51 percentile band=' num2str(min([so(i49_51_percentiles).burn_rate_max])) ])
end

if plot_final_percent_reserves_depleted
    for i=1:c.ensemble_size
        clear t
        t=find(so(i).burn_rate==so(i).burn_rate_max);
        cum_emissions_at_max_burn_rate(i)=so(i).cum_emissions(t);
        initial_volume(i)=so(i).LHSparams(1);
        max_volume(i)=so(i).LHSparams(2)+so(i).LHSparams(1);
        tot_emissions(i)=so(i).tot_emissions;
    end
    peak_ff=cum_emissions_at_max_burn_rate./tot_emissions;
    p_peak_ff=prctile(peak_ff,[5 50 95]);
    subplot(2,1,1)
    hist(peak_ff,40)
    shading flat
    title(['5/50/95 percentiles of peak_ff=',num2str(p_peak_ff)])
    subplot(2,1,2)
    clear percent_depleted
    percent_depleted=tot_emissions./max_volume;
    p_depleted_at_run_end=prctile(percent_depleted,[5 50 95]);
    hist(percent_depleted,40)
    shading flat
    title(['5/50/95 percentiles of ratio of total future emissions to max ff volume=',num2str(p_depleted_at_run_end)])
    
    i=find(percent_depleted>1.);
    for n=1:length(i);
        disp([num2str(tot_emissions(i(n))) '   ' num2str(max_volume(i(n))) '   ' num2str(percent_depleted(i(n)))])
    end
end

%common variables follow for paintbrush plots
c.ensemble_size=length(so);
nbins=2500;
cRCP=[128. 255. 0.;...
    255. 255. 0.;...
    255. 128 0.;...
    255. 0. 0.]./255.;

load_hist_and_RCP_emissions
RCPname{5}='historical ';

if plot_paintbrushes
    
    close all
    
    EndYear=floor([so.t_fossil_fuel_emissions_stop])
    TotEmissions=[so.tot_emissions];
    NetWarming=[so.net_warming];
    nCeasedEmissions=zeros(1,c.tf);
    IsMinRenewablesReached=zeros(1,c.ensemble_size);
    for en=1:c.ensemble_size
        FinalRePr(en)=so(en).re_pr(end);
        MinRePr(en)=so(en).LHSparams(7) .* so(en).LHSparams(6)./c.mwh_2_J;
    end
    IsMinRenewablesReached(FinalRePr<MinRePr.*1.001)=100.; %sets all of this array, where final renewable price is essentially at min, to 100%.
    for yr=1:c.tf
        i=find(EndYear==yr+c.start_year);
        nCeasedEmissions(yr)=numel(i);
        MeanTotCumEmissions(yr)=mean(TotEmissions(i));
        MeanNetWarming(yr)=mean(NetWarming(i));
        MeanIsRenewablesReached(yr)=mean(IsMinRenewablesReached(i)); %Describes % of runs that ended in a given year, that reached minimum value
    end
    year=(1:c.tf)+c.start_year;
    he=find(RCPyear(1,:)==2012);
    figure
    
    hfig=subplot(1,2,1);
    
    hold on
    
    emis_arr=nan(c.ensemble_size,c.tf);
    for en=1:c.ensemble_size
        emis_arr(en,1:length(so(en).burn_rate))=so(en).burn_rate;
    end
    
    bin_centers=linspace(0,nanmax(emis_arr(:)),nbins);
    hist_arr=nan(nbins,c.tf);
    for yr=1:c.tf
        e=emis_arr(:,yr);
        hist_arr(:,yr)=hist(e,bin_centers);
        emis_mean(yr)=median(e(~isnan(e)));
    end
    hist_arr(hist_arr==0)=nan;
    x=(1:c.tf)+c.start_year;
    y=bin_centers;
    pcolor(x,y,hist_arr),shading flat
    colormap(copper)
    caxis([0 200])
    
    %     hist_arrm=hist_arr(:);
    %     [yearm,emism]=meshgrid(1:c.tf,bin_centers);
    %     yearm=yearm(:); yearm(isnan(hist_arrm))=[];
    %     emism=emism(:); emism(isnan(hist_arrm))=[];
    %     hist_arrm(isnan(hist_arrm))=[];
    %
    %     NS=createns([yearm emism]);
    %     hold on
    %     for en=1:c.ensemble_size
    %         IDX=knnsearch(NS,[so(en).time so(en).burn_rate]);
    %         cline([so(en).time] + c.start_year, [so(en).burn_rate] , zeros(1,length([so(en).burn_rate])) , hist_arrm(IDX) , 'jet');
    %         if en==1
    %             caxis([1 5])
    %         end
    %     end
    
    xlabel('Year')
    ylabel('Annual emissions (Tt C per yr) ')
    hold on
    plot(x,emis_mean,'b','linewidth',6)
    
    clear h
    for nRCP=1:4
        h(nRCP)=plot(RCPyear(nRCP,he:end),squeeze(RCP(nRCP,he:end)),'color',cRCP(nRCP,:),'linestyle','--','linewidth',3);
    end
    h(5)=plot(RCPyear(1,1:he),RCP(1,1:he),'color','k','linestyle','--','linewidth',3);
    legend(h,RCPname,'location','Northeast')
    
    axis tight
    ax=axis;
    ax(1)=1950;ax(2)=timeaxislimit;ax(3)=-0.003;
    axis(ax)
    
    subplot_label(hfig,-0.2,0.9,'(a)',20)
    
    hfig=subplot(1,2,2);
    
    hold on
    
    cum_emis_arr=nan(c.ensemble_size,c.tf);
    cum_emis_arr_avg=nan(c.ensemble_size,c.tf);
    for en=1:c.ensemble_size
        en_len=length(so(en).cum_emissions);
        cum_emis_arr(en,1:en_len)=so(en).cum_emissions;
        cum_emis_arr_avg(en,1:en_len)=so(en).cum_emissions;
        cum_emis_arr_avg(en,en_len+1:c.tf)=so(en).cum_emissions(en_len);
    end
    bin_centers=linspace(0,nanmax(cum_emis_arr(:)),nbins);
    hist_arr=nan(nbins,c.tf);
    for yr=1:c.tf
        e=cum_emis_arr(:,yr);
        hist_arr(:,yr)=hist(e,bin_centers);
    end
    
    hist_arr(hist_arr==0)=nan;
    
    x=(1:c.tf)+c.start_year;
    y=bin_centers;
    pcolor(x,y,hist_arr),shading flat
    
    scatter(year,MeanTotCumEmissions,nCeasedEmissions.*5,'.b') %5 is to cosmetically scale the dot size.

    clear h
    for nRCP=1:4
        h(nRCP)=plot(RCPyear(nRCP,he:end),squeeze(cumRCP(nRCP,he:end)),'color',cRCP(nRCP,:),'linestyle','--','linewidth',3);
    end
    h(5)=plot(RCPyear(1,1:he),cumRCP(1,1:he),'color','k','linestyle','--','linewidth',3);
    legend(h,RCPname,'location','Northwest')
    axis tight
    ax=axis;
    ax(1)=1950;ax(2)=timeaxislimit;
    caxis([0 200])
    colormap(copper)
    axis(ax)
    
    %hist_arrm=hist_arr(:);
    %[yearm,cum_emism]=meshgrid(1:c.tf,bin_centers);
    %yearm=yearm(:); yearm(isnan(hist_arrm))=[];
    %cum_emism=cum_emism(:); cum_emism(isnan(hist_arrm))=[];
    %hist_arrm(isnan(hist_arrm))=[];
    %NS=createns([yearm cum_emism]);
    %hold on
    %for en=1:c.ensemble_size
    %    IDX=knnsearch(NS,[so(en).time so(en).cum_emissions]);
    %    cline([so(en).time] + c.start_year, [so(en).cum_emissions] , zeros(1,length([so(en).cum_emissions])) , hist_arrm(IDX) , 'jet');
    %    if en==1
    %      caxis([1 5])
    %    end
    %end
    
    %hc=colorbar;
    %ylabel(hc,'Ensemble density')
    xlabel('Year')
    ylabel('Cumulative emissions (Tt C) ')
    
    subplot_label(hfig,-0.2,0.9,'(b)',20)
    
    
    print('-depsc','figs/probabalistic_emissions')
    
end

if plot_mean_ending_cum_emissions

    figure
    
    EndYear=floor([so.t_fossil_fuel_emissions_stop]);
    TotEmissions=[so.tot_emissions];
    NetWarming=[so.net_warming];
    nCeasedEmissions=zeros(1,c.tf);
    IsMinRenewablesReached=zeros(1,c.ensemble_size);
    for en=1:c.ensemble_size
        FinalRePr(en)=so(en).re_pr(end);
        MinRePr(en)=so(en).LHSparams(7) .* so(en).LHSparams(6)./c.mwh_2_J;
    end
    IsMinRenewablesReached(FinalRePr<MinRePr.*1.001)=100.;
    for yr=1:c.tf
        i=find(EndYear==yr+c.start_year);
        nCeasedEmissions(yr)=numel(i);
        MeanTotCumEmissions(yr)=mean(TotEmissions(i));
        MeanNetWarming(yr)=mean(NetWarming(i));
        MeanIsRenewablesReached(yr)=mean(IsMinRenewablesReached(i));
    end
    year=(1:c.tf)+c.start_year;
    hold on
    %scatter(year,MeanTotCumEmissions,nCeasedEmissions.*5,MeanIsRenewablesReached,'filled')
    scatter(year,MeanTotCumEmissions,nCeasedEmissions.*20,'.k')
    ie=find(~isnan(MeanTotCumEmissions) & nCeasedEmissions>1);
    %py=polyfit(year(ie),MeanTotCumEmissions(ie),4);
    %plot(year(ie(1):ie(end)),polyval(p,year(ie(1):ie(end))),'k','linewidth',2)
    axis tight
    ax=axis;ax(2)=timeaxislimit;ax(4)=5.3;axis(ax)
    %colormap('jet')
    %hc=colorbar
    %ylabel(hc,'% of simulations reaching minimum renewable price')
    xlabel('Year')
    ylabel('Year-mean cumulative emissions (Tt C)')
    
    print('-depsc','figs/mean_ending_cum_emissions')
    
end

if plot_consumption_emission_validation
    
    if c.start_year > 2000.
        error('Looks like you are trying to print validation plot for a non-hindcast run..?')
    end
    
    figure
    
    h=subplot(2,1,1);
    subplot_label(h,-0.1,0.9,'a)',25)
    %Observed global consumption rates.
    data=xlsread('data/Total_Primary_Energy_Consumption_(Quadrillion_Btu).xls');
    obs_consumption=data(3,1:end-1).*c.quads_2_J./1.e18; %To EJ
    obs_time=data(1,1:end-1);
    iyear=find(obs_time==1980);
    observed_consumption_pf=polyfit(obs_time(iyear:end),obs_consumption(iyear:end),1);
    observedconsumptionpf=spa_sf(observed_consumption_pf(1),2);
    obs_consumption_fit=polyval(observed_consumption_pf,obs_time(iyear:end));
    nval=length(obs_consumption);
    
    %Weed out runs that finish before present day (outliers)
    i=find( ([so.t_fossil_fuel_emissions_stop]-c.start_year)>=nval );
    TotEnDemand=zeros(length(i),nval);
    TotEmissions=zeros(length(i),nval);
    FossilPricing=zeros(length(i),nval);
    FossilDiscovery=zeros(length(i),nval);
    for en=1:length(i)
        TotEnDemand(en,:)=so(i(en)).tot_en_demand(1:nval)./1.e18; %To EJ
        TotEmissions(en,:)=so(i(en)).burn_rate(1:nval);
        FossilPricing(en,:)=so(i(en)).ff_pr(1:nval);
        FossilDiscovery(en,:)=so(i(en)).discovery_rate(1:nval);
    end
    
    mod_time=so(en).time(1:nval)+c.start_year;
    MeanTotalEnergyDemand=mean(TotEnDemand,1);
    StdTotalEnergyDemand=std(TotEnDemand,1);
    minTotalEnergyDemand=MeanTotalEnergyDemand-StdTotalEnergyDemand;
    maxTotalEnergyDemand=MeanTotalEnergyDemand+StdTotalEnergyDemand;
    
    disp(['historical consumption trend=' num2str(observed_consumption_pf(1))])
    simulatedconsumptionpfmean=spa_sf(polyfit(mod_time,MeanTotalEnergyDemand',1), 2);
    simulatedconsumptionpfmean=simulatedconsumptionpfmean(1);
    disp(['simulated mean consumption trend=' num2str(simulatedconsumptionpfmean)])
    simulatedconsumptionpfmin=spa_sf(polyfit(mod_time,minTotalEnergyDemand',1), 2);
    simulatedconsumptionpfmin=simulatedconsumptionpfmin(1);
    disp(['simulated min consumption trend=' num2str(simulatedconsumptionpfmin)])
    simulatedconsumptionpfmax=spa_sf(polyfit(mod_time,maxTotalEnergyDemand',1), 2);
    simulatedconsumptionpfmax=simulatedconsumptionpfmax(1);    
    disp(['simulated max consumption trend=' num2str(simulatedconsumptionpfmax)])

    hold on
    h(1)=plot(obs_time(iyear:end),obs_consumption(iyear:end),'b--','linewidth',2);
    h(2)=plot(obs_time(iyear:end),obs_consumption_fit,'b','linewidth',2);
    h(3)=plot(mod_time,MeanTotalEnergyDemand,'r','linewidth',2);
    h(4)=plot(mod_time,minTotalEnergyDemand,'r--','linewidth',2);
    h(4)=plot(mod_time,maxTotalEnergyDemand,'r--','linewidth',2);
    legend(h,{'Observed consumption' 'Observed consumption trend' 'Simulated consumption mean'  'Simulated +/- 1-sigma consumption'},'Location','Northwest');
    axis tight
    ax=axis;
    ax(1)=c.start_year;
    axis(ax);
    xlabel('Year')
    ylabel('EJ per year')
    
    %%%
    h=subplot(2,1,2);
    subplot_label(h,-0.1,0.9,'b)',25)
    %Observed global emission rates, 1980-2010.
    data=load('data/global.1751_2010_jer_added_2011_2012.ems');%http://cdiac.ornl.gov/ftp/ndp030/global.1751_2010.ems.  I manually added 2011 and 2012
    obs_emissions=data(end-nval:end-1,2)./1.e6;
    obs_time=data(end-nval:end-1,1);

    mod_time=so(en).time(1:nval)+c.start_year;
    MeanTotalEmissions=mean(TotEmissions,1);
    StdTotalEmissions=std(TotEmissions,1);
    minTotalEmissions=MeanTotalEmissions-StdTotalEmissions;
    maxTotalEmissions=MeanTotalEmissions+StdTotalEmissions;
    
    observed_emissions_pf=polyfit(obs_time(iyear:end),obs_emissions(iyear:end),1);
    observedemissionspf=spa_sf(observed_emissions_pf(1).*c.thou,2);
    obs_emissions_fit=polyval(observed_emissions_pf,obs_time(iyear:end));
    disp(['historical emission trend=' num2str(observed_emissions_pf(1))])
    simulatedemissionspfmean=spa_sf(polyfit(mod_time,MeanTotalEmissions',1),2);
    simulatedemissionspfmean=simulatedemissionspfmean(1).*c.thou;
    disp(['simulated mean emission trend=' num2str(simulatedemissionspfmean)])
    simulatedemissionspfmin=spa_sf(polyfit(mod_time,minTotalEmissions',1),2);
    simulatedemissionspfmin=simulatedemissionspfmin(1).*c.thou;
    disp(['simulated min emission trend=' num2str(simulatedemissionspfmin)])
    simulatedemissionspfmax=spa_sf(polyfit(mod_time,maxTotalEmissions',1),2);
    simulatedemissionspfmax=simulatedemissionspfmax(1).*c.thou;
    disp(['simulated max emission trend=' num2str(simulatedemissionspfmax)])
    
    hold on
    h(1)=plot(obs_time(iyear:end),obs_emissions(iyear:end).*1000.,'b--','linewidth',2);
    h(2)=plot(obs_time(iyear:end),obs_emissions_fit.*1000.,'b','linewidth',2);
    h(3)=plot(mod_time,MeanTotalEmissions.*1000.,'r','linewidth',2);
    h(4)=plot(mod_time,minTotalEmissions.*1000.,'r--','linewidth',2);
    h(4)=plot(mod_time,maxTotalEmissions.*1000.,'r--','linewidth',2);
    
    legend(h,{'Observed emissions' 'Observed emissions trend' 'Simulated mean emissions' 'Simulated +/- 1-sigma emissions'},'Location','Northwest');
    axis tight
    ax=axis;
    ax(1)=1980;
    axis(ax);
    xlabel('Year')
    ylabel('Gt C per year')
    
    print('-depsc','figs/consumption_emission_validation')
    
    %Fossil price trends
    MeanFossilPrice=mean(FossilPricing,1);
    simulatedfossilpricespfmean=spa_sf(polyfit(mod_time,MeanFossilPrice',1),1);
    disp(['mean historical increase in fossil fuel pricing (%/yr)=',num2str(simulatedfossilpricespfmean(1)./mean(MeanFossilPrice).*100)])
    
    %Fossil discovery trends
    MeanFossilDiscovery=mean(FossilDiscovery,1);
    simulatedfossildiscoverypfmean=spa_sf(polyfit(mod_time,MeanFossilDiscovery',1),1);
    disp(['mean historical increase in fossil fuel discovery (%/yr)=',num2str(simulatedfossildiscoverypfmean(1)./mean(MeanFossilDiscovery).*100)])    
    
    if c.start_year<2000.
    latexcmd('output/modelhistoricaloutput',...
        observedconsumptionpf,...
        simulatedconsumptionpfmean,...
        simulatedconsumptionpfmin,...
        simulatedconsumptionpfmax,...
        observedemissionspf,...
        simulatedemissionspfmean,...
        simulatedemissionspfmin,...
        simulatedemissionspfmax)
    else
        error('Not printing validation output to .tex file, because this does not look like a validation hindcast due to late start date')
    end
end

%so.

if plot_diagnostic_output
    hold on
    for en=1:100
        plot(so(en).time,so(en).discovery_rate,'r','linewidth',1)
    end
end

%% Output parameters to .tex file
if c.start_year==2012
    if plot_final_percent_reserves_depleted==0 || ...
            plot_cumulative_emissions_and_warming_pdfs==0 || ...
            plot_diversity_of_trajectories==0
        
        error('Need one or more plotting options turned on to generate .tex output.')
        
    else
        
        emissionfifth  =spa_sf(qemissions(1),2);
        emissionfiftyth    =spa_sf(qemissions(2),2);
        emissionninetyfifth=spa_sf(qemissions(3),2);
        
        temperaturefifth      =spa_sf(qtemperature(1),2);
        temperaturefiftyth    =spa_sf(qtemperature(2),2);
        temperatureninetyfifth=spa_sf(qtemperature(3),2);
        
        firstthresholdT=find(p_100<Tlim(1),1,'last');
        secondthresholdT=find(p_100<Tlim(2),1,'last');
        thirdthresholdT=find(p_100<Tlim(3),1,'last');
        fourththresholdT=find(p_100<Tlim(4),1,'last');
        
        minburnrate=spa_sf(min([so(i49_51_percentiles).burn_rate_max]).*c.thou , 2 );
        maxburnrate=spa_sf(max([so(i49_51_percentiles).burn_rate_max]).*c.thou , 2 );
        
        pdepletedatrunend=spa_sf(p_depleted_at_run_end(2).*100.,2);
        
    end
    
    latexcmd('output/modeloutput',emissionfifth,emissionfiftyth,emissionninetyfifth,...
        temperaturefifth,temperaturefiftyth,temperatureninetyfifth,...
        firstthresholdT,secondthresholdT,thirdthresholdT,fourththresholdT,...
        minburnrate,maxburnrate,...
        pdepletedatrunend)
else
      warning('Initial model year is not 2012 - not printing .tex projection output.')
end
