clear RCP*
RCPname={'RCP2.6' 'RCP4.5' 'RCP6.0' 'RCP8.5'};
%load RCP emission pathways
data=xlsread('data/rcp_db.xls','data');
ts=5;
te=16;
RCPyear=data(1,ts:te);
RCP(1,:)=data(4,ts:te)./1000.;
RCP(2,:)=data(3,ts:te)./1000.;
RCP(3,:)=data(2,ts:te)./1000.;
RCP(4,:)=data(5,ts:te)./1000.;
data=load('data/global.1751_2010.ems');
obs_emissions=data(end-30:end,2)./1.e6;
obs_time=data(end-30:end,1);