function [nodes,solution] = euler_exp(ode,domain,initialValue,step)
% EULER_EXP Explicit Euler method for initial value problems.
%   The explicit Euler method is given by the formula y_n+1 = y_n + h*f_n.
%   It's a first-order explicit method.
%
% Input:
%   ode             Function f(t,y(t)) that defines the problem.
%   domain          Domain of the t variable.
%   initialValue    Initial value y_0 = y(x_0).
%   step            Constant step h.
%
% Output:
%   nodes           Grid nodes (column) vector
%   solution        Approximate solution (column) vector

nodes = (domain(1):step:domain(2))';
solution = zeros(length(nodes),1);
solution(1) = initialValue;

for i = 2:length(nodes)
    solution(i) = solution(i-1) + step*ode(nodes(i-1),solution(i-1));
end

end