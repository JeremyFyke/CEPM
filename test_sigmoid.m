clear 
close all
ff_pr=linspace(-5.-9,5.-9,1000);
re_pr=linspace(5.-9,-5.-9,1000);
x=(re_pr-ff_pr)./ff_pr;
a = 1.;
b = 1.;
c = 1.e-4;
hold on
fff=a ./ (1 + b.*c.^(-x));
plot(x,fff,'k-','linewidth',2);

b = 0.1;
c = 1.e-4;
fff=a ./ (1 + b.*c.^(-x));
plot(x,fff,'r-*');

b = 10;
c = 1.e-4;
fff=a ./ (1 + b.*c.^(-x));
plot(x,fff,'r-*');

b = 1;
c = 1.e-2;
fff=a ./ (1 + b.*c.^(-x));
plot(x,fff,'b-+');

b = 1;
c = 1.e-6;
fff=a ./ (1 + b.*c.^(-x));
plot(x,fff,'b-+');

b = 0.1;
c = 1.e-2;
fff=a ./ (1 + b.*c.^(-x));
plot(x,fff,'g-+');

b = 10.;
c = 1.e-6;
fff=a ./ (1 + b.*c.^(-x));
plot(x,fff,'g-+');

grid on