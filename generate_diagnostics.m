%Generate diagnostics to test ability of model to capture present day.

figure
subplot(1,2,1)
hold on
h(1)=plot(so(en).ff_pr,'r');
h(2)=plot(so(en).re_pr,'b');
legend(h,{'Fossil price' 'Renewable price'})
subplot(1,2,2)
plot(so(en).ff_fraction)
