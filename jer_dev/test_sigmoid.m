clear all
clf
ff_pr=linspace(-2.-9,2.-9,100);
re_pr=linspace(2.-9,-2.-9,100);
x=(re_pr-ff_pr)./ff_pr;
a = 1.;
b = 1.;
c = 1.e-11;
fff=a ./ (1 + b.*c.^(-x));
hold on
plot(x,fff,'-*')

grid on