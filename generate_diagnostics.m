%Generate diagnostics to test ability of model to capture present day.

%Observed global consumption rates, 1980-2012.
data=xlsread('data/Total_Primary_Energy_Consumption_(Quadrillion_Btu).xls');
obs_consumption=data(3,:).*quads_2_J;
obs_time=data(1,:);

%fit=polyfit(obs_time,log(obs_consumption),1);
%plot(obs_time, obs_consumption, 'o', obs_time, exp(fit(2)).*exp(fit(1)*obs_time))
%fit_consumption_recent=exp(fit(2)).*exp(fit(1)*obs_time(end)) 

nanmean(diff(obs_consumption(end-10:end)))
mean([so.dconsumptiondt_init])

close all

en=2;

nval=25;
TotEnDemand=zeros(ensemble_size,nval);
for en=1:ensemble_size
    TotEnDemand(en,:)=so(en).tot_en_demand(1:nval);
end
mod_time=so(en).time(1:nval)+present_year;
TEDMean=mean(TotEnDemand,1);
TEDMin=min(TotEnDemand,[],1);
TEDMax=max(TotEnDemand,[],1);

%subplot(1,3,1)
hold on
h(1)=plot(obs_time,obs_consumption,'b')
errorbar(mod_time,TEDMean,TEDMean-TEDMin,TEDMax-TEDMean,'r')

%h(2)=plot(so(en).time(1:30)+present_year,so(en).tot_en_demand(1:30),'r')
% legend(h,{'observed global consumption' 'modeled global consumption'})
% subplot(1,3,2)
% plot(so(en).pop)
% title('Population')
% subplot(1,3,3)
% plot(so(en).per_cap_dem)
ax=axis;
ax(3)=0;
axis(ax)
title('Global energy demand')
xlabel('Year')
ylabel('Joules')

figure
subplot(1,2,1)
hold on
h(1)=plot(so(en).ff_pr,'r');
h(2)=plot(so(en).re_pr,'b');
legend(h,{'Fossil price' 'Renewable price'})
subplot(1,2,2)
plot(so(en).ff_fraction)

%%TO DO: compare CDIAC emission trends with initial burn rates, and burn
%%rate trends.