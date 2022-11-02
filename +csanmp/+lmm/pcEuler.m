function [nodes, solution] = pcEuler(ode, domain, initialValue, step, ...
    correctorIter)
%PCEULER
%
import csanmp.nonlinear.fixed_point

nodes = (domain(1):step:domain(2))';
solution = zeros(length(nodes),1);
solution(1) = initialValue;

for i = 2:length(nodes)
    predictor = solution(i-1) + step*ode(nodes(i-1), solution(i-1));
    fpFunction = @(y) solution(i-1) + step*ode(nodes(i),y);
    solution(i) = fixed_point(fpFunction, predictor, correctorIter, inf);
end

end