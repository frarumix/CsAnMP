function ivp = prothero_robinson(lambda)
% PROTHERO_ROBINSON Create an IVP class object corresponding to the
% Prothero-Robinson problem:
%
%   y'(t) = lambda*(y - sin(t)) + cos(t),    t in [0, 2*pi]
%   y(0) = 0

arguments (Input)
    lambda (1,1) {mustBeReal}
end

import csanmp.IVP

ode = @(t,y) lambda*(y - sin(t)) + cos(t);
domain = [0, 2*pi];
initialValue = 0;
name = "Prothero-Robinson with \lambda = " + num2str(lambda);
solution = @(t) sin(t);

ivp = IVP(ode,domain,initialValue,name,"analytical",solution);

end