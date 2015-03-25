%load RCP emission pathways
clear RCP*
RCPname={'RCP2.6' 'RCP4.5' 'RCP6.0' 'RCP8.5'};
RCPfilename={'RCP3PD_EMISSIONS' 'RCP45_EMISSIONS' 'RCP6_EMISSIONS' 'RCP85_EMISSIONS'};

for nRCP=1:length(RCPname);
   fname=strcat('data/',RCPfilename{nRCP},'.xls');
   sname=RCPfilename{nRCP};
   data=xlsread(fname,sname);
   RCPyear(nRCP,:)=data(13:end,1);
   RCP(nRCP,:)=data(13:end,2)./1000.;
end
cumRCP=cumsum(RCP,2);

data=load('data/global.1751_2010_jer_added_2011_2012.ems');
obs_emissions=data(end-30:end,2)./1.e6;
obs_time=data(end-30:end,1);
clear data