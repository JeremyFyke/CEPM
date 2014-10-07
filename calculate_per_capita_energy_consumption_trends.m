close all
clear all

%Read 1980-2011
data=xlsread('Total_Primary_Energy_Consumption_per_Capita_(Million_Btu_per_Person).xls');
pc_consumption=data(5,:);
dpc=diff(pc_consumption);
percent_change=dpc./pc_consumption(1:end-1);
plot(percent_change)
mean(percent_change)
std(percent_change)



