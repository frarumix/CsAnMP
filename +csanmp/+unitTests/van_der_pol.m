function ivp = van_der_pol(epsilon)
% VAN_DER_POL Create an IVP class object corresponding to the following 
% Van der Pol Oscillator:
%
%   y1'(t) = y_2,
%   epsilon*y2'(t) = (1 - y1^2)*y2 - y1,    t in [0, 2]
%   y1(0) = 2,
%   y2(0) = -2/3.

arguments
    epsilon (1,1) {mustBeReal}
end

import csanmp.IVP

ode = @(t,y) [y(2); ((1 - y(1)^2)*y(2) - y(1))/epsilon];
domain = [0, 2];
initialValue = [2; -2/3];
name = ['Van der Pol with epsilon = ' num2str(epsilon)];
nameLaTeX = ['Van der Pol with $\epsilon =' num2str(epsilon) '$'];

ivp = IVP(ode,domain,initialValue,name,nameLaTeX);

end