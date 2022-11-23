classdef IVP
    % IVP Generic IVP (Initial Value Problem) class.

    properties
        ode
        domain
        initialValue
        analyticalSolution
        numericalSolution
        name
    end
    methods
        function obj = IVP(ode,domain,initialValue,name,solution)

            arguments
                ode function_handle
                domain (1,2) {mustBeReal}
                initialValue (:,1) {mustBeReal}
                name string = "~"
                solution.analytical function_handle = @() NaN
                solution.numerical (:,1) {mustBeReal} = NaN
            end
            
            obj.ode = ode;
            obj.domain = domain;
            obj.initialValue = initialValue;
            obj.name = name;
            obj.analyticalSolution = solution.analytical;
            obj.numericalSolution = solution.numerical;
        end
    end
end