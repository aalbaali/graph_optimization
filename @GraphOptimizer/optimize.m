function obj = optimize( obj)
    %OPTIMIZE() contains the main loop that optimizes over the graph.
    %
    %   OPTIMIZE('linear_solver', lin_solver) specifies the linear
    %   solver.

    % Check if a factor graph exists
    if isempty( obj.factor_graph)
        error( "Factor graph not initialized");
    end
    
    % Check if graph is valid
    obj.checkFactorGraph( obj.factor_graph);
    
    % Initialize internal parameters and Jacobian (does not fill in the Jacobian
    % values).
    obj.initializeInternalParameters();
    
    % Reorder columns
    obj.reorderColumns();
    
    %%%%%%%%%%warning('The following should be implemented in a loop');
    
    % Get descent direction
    obj.descend();
    
    % Check if things are well (objective function decreased)
    
end