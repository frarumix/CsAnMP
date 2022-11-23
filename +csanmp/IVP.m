classdef IVP < handle
    % Generic Initial Value Problem class.

    properties
        ode                 % Function f(t,y(t)) that defines the problem.
        domain              % Domain of the variable t.
        initialValue        % Initial value row vector (y1(0), ..., yn(0)).
        name                % Problem's name.
        nameLaTeX           % Problem's name with LaTeX formatting.
        analyticalSolution  % Analytical solution to the problem.
        numericalSolution   % Value of the solution in the last grid node.
    end

    methods
        function obj = IVP(ode,domain,initialValue,name,nameLaTeX,solution)
            arguments
                ode function_handle
                domain (1,2) {mustBeReal}
                initialValue (:,1) {mustBeReal}
                name string = '~'
                nameLaTeX string = name
                solution.analytical = missing
                solution.numerical (:,1) {mustBeReal} = double(missing)
            end
            
            obj.ode = ode;
            obj.domain = domain;
            obj.initialValue = initialValue;
            obj.name = name;
            obj.nameLaTeX = nameLaTeX;
            obj.analyticalSolution = solution.analytical;
            obj.numericalSolution = solution.numerical;
        end

        function computeSolution(obj)
            % COMPUTESOLUTION If the numerical solution to the problem is
            % missing, compute it by evaluating the analytical solution in
            % the domain's right end. If the analytical solution is also
            % missing, raise an error.

            if ismissing(obj.numericalSolution)
                if ismissing(obj.analyticalSolution)
                    error('No analytical solution available.')
                else
                    obj.numericalSolution = obj.analyticalSolution(...
                        obj.domain(2));
                end
            end
        end
    end
end