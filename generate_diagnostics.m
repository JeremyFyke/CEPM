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
subplot(1,3,1)
hold on
h(1)=plot(obs_consumption,'b')
h(2)=plot(so(en).tot_en_demand,'r')
legend(h,{'observed global consumption' 'modeled global consumption'})
subplot(1,3,2)
plot(so(en).pop)
title('Population')
subplot(1,3,3)
plot(so(en).per_cap_dem)
title('Per cap demand')

figure
subplot(1,2,1)
hold on
h(1)=plot(so(en).ff_pr,'r');
h(2)=plot(so(en).re_pr,'b');
legend(h,{'Fossil price' 'Renewable price'})
subplot(1,2,2)
plot(so(en).ff_fraction)