function ivp = brussellator(A,B)
% BRUSSELLATOR Create and IVP class object corresponding to the
% Brussellator's kinetic model:
%
%   y1'(t) = A + (y1^2)*y2 - (B + 1)*y1,
%   y2'(t) = B*y1 - (y1^2)*y2,    t in [0, 20]
%   y1(0) = 1.5,
%   y2(0) = 3.

arguments
    A, B (1,1) {mustBeReal}
end

import csanmp.IVP

ode = @(t,y) [A + y(1)^2*y(2) - (B + 1)*y(1)
              B*y(1) - y(1)^2*y(2)];
domain = [0, 20];
initialValue = [1.5; 3];
name = "Brussellator with A = " + num2str(A) + ", B = " + num2str(B);
solution = [0.4986370713; 4.596780349];

ivp = IVP(ode,domain,initialValue,name,"numerical",solution);

end