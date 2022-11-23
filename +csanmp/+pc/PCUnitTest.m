classdef PCUnitTest < handle
    % Unit test class to take a generic predictor-corrector method for IVPs
    % and test it against some premade problems.

    properties
        method  % Numerical method to be tested, as a function handle.
        ivp     % IVP to test the method against (see csanmp.IVP).
    end
    
    methods
        function obj = PCUnitTest(method,ivp)
            arguments
                method function_handle
                ivp csanmp.IVP
            end

            obj.method = method;
            obj.ivp = ivp;
        end

        function [nodes,solution,accepted,rejected,fEvals,digits] = ...
                apply(obj,tol,step,iterations,facmi,facma)
            % APPLY Apply the method to the IVP to compute an approximated
            % solution and useful infos such as accepted and rejected
            % steps, function evaluations and correct decimal digits.
            %
            % Input:
            %   tol             Step evaluation tolerance.
            %   step            Initial step h0.
            %   iterations      How many corrector iterations.
            %   facmi
            %   facma           Parameters to compute the optimal step.
            %
            % Output:
            %   nodes           Grid nodes column.
            %   solution        Approximate solution matrix, where each
            %                   column corresponds to a solution component.
            %   accepted        How many accepted steps.
            %   rejected        How many refused steps.
            %   fEvals          How many times the ode has been evaluated.
            %   digits          How many correct decimal digits, with
            %                   respect to a known solution.

            arguments (Input)
                obj
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
                digits (1,1) %{mustBeNonnegative}
            end
            
            [nodes,solution,accepted,rejected,fEvals] = obj.method(...
                obj.ivp.ode,obj.ivp.domain,obj.ivp.initialValue,tol,...
                step,iterations,facmi,facma);
            obj.ivp.computeSolution();
            digits = -log10(norm(obj.ivp.numericalSolution - solution(...
                end,:)',"inf"));
        end

        function plotSolution(obj)
            % PLOTSOLUTION Shortcut to quickly plot the computed solution
            % with fixed parameters tol=1e-4, step=0.01*tol, iterations=2,
            % facmi=0.5, facma=1.5 (see csanmp.pc.PCUnitTest.apply).
            
            figure();
            [nodes, solution] = obj.apply(1e-4);
            labels = cell(length(obj.ivp.initialValue),1);
            for i = 1:length(obj.ivp.initialValue)
                plot(nodes,solution);
                labels{i} = ['$y_' num2str(i) '$'];
            end            
            legend(labels,Location='best')
            title(obj.ivp.nameLaTeX)
            xlabel('$t$')
            ylabel('$y$')
        end
    end
end