function [nodes,solution,accepted,rejected,fEvals] = VSPC1(ode,domain,...
    initialValue,tol,step,iterations, facmi, facma)
% VSPC1 Predictor-corrector method based on the explicit/implicit Euler
% couple, with variable step.
%
% Input:
%   ode             Function f(t,y(t)) that defines the problem.
%   domain          Domain of the t variable.
%   initialValue    Initial value row vector (y1(0), y2(0), ..., yn(0)).
%   tol             Step evaluation tolerance.
%   step            Initial step h0.
%   iterations      How many corrector iterations.
%   facmi
%   facma           Parameters to compute the optimal step.
%
% Output:
%   nodes           Grid nodes column.
%   solution        Approximate solution matrix, where each column
%                   corresponds to a solution component.
%   accepted        How many accepted steps.
%   rejected        How many refused steps.
%   fEvals          How many times the ode has been evaluated.           

arguments (Input)
    ode function_handle
    domain (1,2) {mustBeReal}
    initialValue (1,:) {mustBeReal}
    tol (1,1) {mustBePositive}
    step (1,1) {mustBePositive} = 0.01*tol
    iterations (1,1) {mustBeInteger,mustBeNonnegative} = 2
    facmi (1,1) {mustBeReal} = 0.5
    facma (1,1) {mustBeInRange(facma,1.5,5)} = 1.5
end
arguments (Output)
    nodes (:,1) {mustBeReal}
    solution (:,:) {mustBeReal}
    accepted (1,1) {mustBeInteger,mustBePositive}
    rejected (1,1) {mustBeInteger,mustBeNonnegative}
    fEvals (1,1) {mustBeInteger,mustBePositive}
end

import csanmp.pc.milne

accepted = 0; rejected = 0; fEvals = 0;
n = 1; % Nodes counter
nodes(1) = domain(1);
solution = zeros(length(nodes),length(initialValue));
solution(1,:) = initialValue;

while nodes(n) < domain(2)
    % Define a test node with the initial step
    testNode = nodes(n) + step;

    % Apply the p/c method in the test node. An auxiliary variable y0 is
    % needed to preserve the predictor for Milne's LTE estimate
    predictor = solution(n,:) + step*ode(nodes(n),solution(n,:))';
    fEvals = fEvals + 1;
    y0 = predictor;
    for j = 1:iterations
        corrector = solution(n,:) + step*ode(testNode,y0)';
        fEvals = fEvals + 1;
        y0 = corrector;
    end

    % Milne's LTE estimate
    lte = milne(0.5,-0.5,predictor,corrector);

    % Optimal step for the next iteration
    optimalStep = step*min(facma,max(facmi,0.9*sqrt(tol/lte)));

    % Step evaluation
    if lte <= tol % Step accepted
        accepted = accepted + 1;
        n = n+1;
        nodes(n) = testNode; % Update nodes vector with the accepted node
        solution(n,:) = corrector; % Update solution matrix
        step = min(optimalStep,domain(2) - nodes(n)); % Step for next iter
    else % Step rejected
        rejected = rejected + 1;
        step = optimalStep; % Repeat this iteration with a smaller step
    end
end

end