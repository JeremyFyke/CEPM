function [totreserves_lb,totreserves_ub,totresources_lb,totresources_ub]=GEA_ff_reserves_and_resources()

set_global_constants

ioil=1;
igas=2;
icoal=3;

%From GEA report (ROGNER 2012), an assessment of oil, gas, and goal reserves and
%resources.  First index is lower bound, second index is higher bound . In
%the case of oil and gas, X+Y indicates conventional+unconventional.
%All units in EJ

%%%%NOTE: USE OF THIS ROUTINE HAS BEEN REPLACED WITH DIRECT QUOTES FROM IPCC AR5 WG3, Ch.7

reserves(ioil,:)=[4900+3750 7610+5600];
resources(ioil,:)=[4170+11280 6150+14800];

reserves(igas,:)=[5000+7100 20100+67100];
resources(igas,:)=[7200+40200 8900+121900];

reserves(icoal,:)=[17300 21000];
resources(icoal,:)=[291000 435000].*.2;

%Convert reserves and resources (units Exajoules) to gT C

%Convert to terajoules
reserves=reserves.*1.e6;
resources=resources.*1.e6;

%Convert to Tt C
reserves(ioil,:)=reserves(ioil,:).*oilEfactor./1.e12;
reserves(igas,:)=reserves(igas,:).*gasEfactor./1.e12;
reserves(icoal,:)=reserves(icoal,:).*coalEfactor./1.e12;

%Convert to Tt C
resources(ioil,:)=resources(ioil,:).*oilEfactor./1.e12;
resources(igas,:)=resources(igas,:).*gasEfactor./1.e12;
resources(icoal,:)=resources(icoal,:).*coalEfactor./1.e12;

totreserves_lb=sum(reserves(:,1));
totreserves_ub=sum(reserves(:,2));

totresources_lb=sum(resources(:,1)+reserves(:,1));
totresources_ub=sum(resources(:,2)+reserves(:,2));
