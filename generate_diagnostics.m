%Generate diagnostics to test ability of model to capture present day.

%Observed global consumption rates, 1971-2012 (min, max).
%Data source: IEA handbook 2014, converted to J using IEA converter:
%http://www.iea.org/statistics/resources/unitconverter/
obs_consumpt=[1.80032400e14 3.76812000e14].*1.e6 %J
mod_consumpt=mean([so.consumption_init])

