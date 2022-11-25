classdef IVP
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

        function obj = computeSolution(obj)
            % COMPUTESOLUTION If the numerical solution to the problem is
            % missing, update the object's properties by evaluating the
            % analytical solution in the domain's right end. If the
            % analytical solution is also missing, raise an error.

            if ismissing(obj.numericalSolution)
                if ismissing(obj.analyticalSolution)
                    error('No analytical solution available.')
                else
                    obj.numericalSolution = obj.analyticalSolution(...
                        obj.domain(2));
                end
            end
        end

        function [obj,nodes,solution] = computeSolutionODE(obj,mode,...
                tol,step)
            % COMPUTESOLUTIONODE Update the object's properties by
            % computing a numerical solution with a chosen MATLAB ode
            % solver. The parameter must be passed as a string and may be
            %
            %   23, 113, 23s, 15s
            %
            % and chooses the method to solve the IVP. Tolerance and
            % initial step may be passed to override the defaults.
            %
            %   obj = COMPUTESOLUTIONODE(...) updates the IVP with the
            %   numerical solution.
            %
            %   [obj,nodes,solution] = COMPUTESOLUTIONODE(...) to also save
            %   all the nodes and values computed by the ODE solver.
            
            arguments (Input)
                obj
                mode string = "23"
                tol (1,1) {mustBePositive} = 1e-4
                step (1,1) {mustBePositive} = 0.01*tol
            end
            arguments (Output)
                obj
                nodes (:,1) {mustBeReal}
                solution (:,:) {mustBeReal}
            end

            opts = odeset('Stats','on','AbsTol',tol,'InitialStep',step);
            cmd = "ode" + mode;
            if ismember(mode,["23" "113" "23s" "15s"]) == false
                error(cmd + " is not a valid command.")
            end
            cmd = cmd + "(obj.ode,obj.domain,obj.initialValue,opts)";
            [nodes,solution] = eval(cmd);
            obj.numericalSolution = solution(end,:);
        end
    end
end