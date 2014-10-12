t=1:1000;
K=12.e10;
r=0.01;
P0=3;
% Logistic growth     
%    using MATLAB for analytical solution                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/20 $
%--------------------------------------------------------------------------
T = 1000;                  % maximum time
r = 0.01;                   % rate 
kappa = 12.e10;               % capacity
c0 = 7.e10;;               % initial value

%----------------------execution-------------------------------------------

t = linspace (0,T,100);
e = exp(r*t);
c = c0*kappa*e./(kappa+c0*(e-1));

%---------------------- graphical output ----------------------------------

plot (t,c); grid;
xlabel ('time'); legend ('population');
title ('logistic growth');

