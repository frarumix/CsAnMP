classdef IVP
    % IVP Generic IVP (Initial Value Problem) class.

    properties
        ode
        domain
        initialValue
        name
        nameLaTeX
        analyticalSolution
        numericalSolution
    end

    methods
        function obj = IVP(ode,domain,initialValue,name,nameLaTeX,solution)

            arguments
                ode function_handle
                domain (1,2) {mustBeReal}
                initialValue (:,1) {mustBeReal}
                name string = "~"
                nameLaTeX string = name
                solution.analytical function_handle = @() NaN
                solution.numerical (:,1) {mustBeReal} = NaN
            end
            
            obj.ode = ode;
            obj.domain = domain;
            obj.initialValue = initialValue;
            obj.name = name;
            obj.nameLaTeX = nameLaTeX;
            obj.analyticalSolution = solution.analytical;
            obj.numericalSolution = solution.numerical;
        end
    end

end