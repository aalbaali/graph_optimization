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
    
    obj_val = [];
    for kk = 1 : 1e3
        % Get descent direction
        obj.descend();
        
        if norm( obj.m_werr_val' * obj.m_werr_Jac) <= 1e-5
            disp('Solution found');
            break;
        end
        
        obj_val = [ obj_val; obj.getObjectiveValue()];
    end
    
    % Check if things are well (objective function decreased)
    
end