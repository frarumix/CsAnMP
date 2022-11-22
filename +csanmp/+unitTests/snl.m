function ivp = snl()
% SNL Create an IVP class object corresponding to the following initial
% value problem:
%
%   y'(t) = 4*t*sqrt(y),    t in [0, 1]
%   y(0) = 1.

import csanmp.IVP

ode = @(t,y) 4*t*sqrt(y);
domain = [0, 1];
initialValue = 1;
name = "snl";
solution = @(t) (1 + t^2)^2;

ivp = IVP(ode,domain,initialValue,name,"analytical",solution);

end