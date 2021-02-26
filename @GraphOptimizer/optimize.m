function obj = optimize( obj)
    %OPTIMIZE() contains the main loop that optimizes over the graph.
    %
    %   OPTIMIZE('linear_solver', lin_solver) specifies the linear
    %   solver.

    % Check if graph is valid
    
    % Initialize internal parameters and Jacobian (does not fill in the Jacobian
    % values).
    obj.initializeInternalParameters();
    
    
%     obj.descend();
end