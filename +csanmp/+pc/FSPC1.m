function [nodes,solution] = FSPC1(ode,domain,initialValue,step, iterations)
% PCEULERFS Predictor-corrector method based on the explicit/implicit Euler
% couple, with fixed step.
%
% Input:
%   ode             Function f(t,y(t)) from the problem.
%   domain          Domain of the t variable.
%   initialValue    Initial value row vector (y1(0), y2(0), ..., yn(0)).
%   step            Constant step h.
%   iterations      How many corrector iterations.
%
% Output:
%   nodes           Grid nodes column.
%   solution        Approximate solution matrix, where each column
%                   corresponds to a solution component.

arguments (Input)
    ode function_handle
    domain (1,2) {mustBeReal}
    initialValue (1,:) {mustBeReal}
    step (1,1) {mustBePositive}
    iterations (1,1) {mustBeInteger,mustBeNonnegative} = 2
end
arguments (Output)
    nodes (:,1) {mustBeReal}
    solution (:,:) {mustBeReal}
end

nodes = (domain(1):step:domain(2))';
solution = zeros(length(nodes),length(initialValue));
solution(1,:) = initialValue;

for i = 2:length(nodes)
    % Predictor: explicit Euler
    predictor = solution(i-1,:) + step*ode(nodes(i-1),solution(i-1,:))';
    
    % Corrector: implicit Euler
    for j = 1:iterations
        corrector = solution(i-1,:) + step*ode(nodes(i),predictor)';
        predictor = corrector;
    end
    solution(i,:) = corrector;
end

end