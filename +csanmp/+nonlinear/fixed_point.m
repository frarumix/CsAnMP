function [fixedPoint, iterations] = fixed_point(func, start, maxIter, tol)
%FIXED_POINT Fixed-point iterations.
%   Solve a nonlinear equation f(x) = 0 by finding the fixed point of a
%   funcion g such that f(a) = 0 iff g(a) = a. The fixed point can be
%   approximated by iterating x_n+1 = g(x_n). A sufficient condition for
%   convergence is g being a contraction.
%
% Input:
%   func        g as above
%   start       Initial value x_0
%   maxIter     Maximum number of iterations a stopping criterion; the
%               method will fail whenever an acceptable approximation is
%               not found.
%   tol         Tolerance as a stopping criterion; the method will be
%               successful whenever the difference between two consecutive
%               approximations becomes smaller that the tolerance.
%
% Output:
%   fixedPoint
%   iterations

iterations = 0;
diff = inf;
fixedPoint = start;

while iterations <= maxIter && diff >= tol
    fixedPoint = func(start);
    diff = abs(fixedPoint - start);
    start = fixedPoint;
    iterations = iterations + 1;
end

if iterations >= maxIter
    iterations = -1;
    fixedPoint(:) = NaN;
end

end
