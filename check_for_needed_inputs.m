
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
%     along with CEPM.  If not, see <http://www.gnu.org/licenses/

%Check that all m-files and Toolboxes not included with CEPM distribution are present.


files={'catstruct.m' 'matrix2latex.m' };
err=0;
for f=1:length(files)
    if not(isfile(files{f}))
        disp([f ' is missing.  Download from Matlab Exchange.'])
        err=1;
    end
end

if not(isfolder('data'))
   disp('Local input data directory does not exist.')
   err=1;
end

if err
    error('One or more necessary m-files or input file directories not found.')
else
    disp('Seems like all necessary m-files and input data directories are present.')
end

if ~exist('figs','dir')
    [~,~,~] = mkdir('figs');
end
if ~exist('output','dir')
   [~,~,~]=mkdir('output');
end



