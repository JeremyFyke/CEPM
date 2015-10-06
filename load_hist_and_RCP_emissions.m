%     Cumulative Emissions Projection Model (CEPM).
%     Copyright (C) 2015 Jeremy Fyke (fyke@lanl.gov)
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

%load RCP emission pathways
clear RCP*
RCPname={'RCP/ECP2.6 ' 'RCP/ECP4.5 ' 'RCP/ECP6.0 ' 'RCP/ECP8.5 '};
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
