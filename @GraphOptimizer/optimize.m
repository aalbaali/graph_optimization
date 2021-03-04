function [ success, optim_stats] = optimize( obj)
    %   OPTIMIZE() contains the main loop that optimizes over the graph. Returns
    %   a boolean indicating if a solution is found (success=true) or not and
    %   optimization status struct.
    %
    
    % Check number of output arguments. If it's less than 2, then no need to
    % compute optimization stats
    store_optim_stats = (nargout >= 2);
    
    % Default value is false (no solution).
    success = false;
    
    % Check if a factor graph exists
    if isempty( obj.factor_graph)
        error( "Factor graph not initialized");
    end
    
    obj.printf( 'Checking graph validity\n');
    % Check if graph is valid. Pass the verbosity
    checkFactorGraph( obj.factor_graph, obj.verbosity);
    
    % Initialize internal parameters and Jacobian (does not fill in the Jacobian
    % values).
    obj.printf( 'Initializing parameters and matrices\n');
    obj.initializeInternalParameters();

    % Reorder variables (block-wise Jacobian columns)
    if obj.reorder_variables        
        obj.reorderVariables();
    end
    
    if store_optim_stats
        % Pre-allocate memory to improve efficiency
        obj_val = nan( 1, floor( obj.optim_params.max_iterations / 10));
    end
    % Create a variable that stores the objective value at the previous
    % iteration
    obj_val_km1 = inf;    
    
    obj.printf('Starting main optimization loop\n');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Main optimization loop
    for lv1 = 1 : obj.optim_params.max_iterations
        
        if rem( lv1, obj.optim_params.disp_iteration) == 0
            obj.printf('Starting iteration \t%i\n', lv1);
        end
        % Compute search direction
        obj.computeSearchDirection();

        % Check if the search direction is a valid descent direction
        if obj.m_werr_val' * obj.m_werr_Jac * obj.m_search_direction >= 0
            warning('Might not be a descent direction');
        end

        % Compute step length    
        obj.computeStepLength();    
        % Temporary: use constant step length
%         obj.m_step_length = 1e-2;
        
        obj_val_k = obj.getObjectiveValue();
        if store_optim_stats
            obj_val( lv1) = obj_val_k;
        end
        
        % Generate a warning if objective value did not decrease
        if obj_val_k >= obj_val_km1
            warning('Objective value increased');
        end
        % Set the objective value at km1
        obj_val_km1 = obj_val_k;
        
        if norm( obj.m_werr_val' * obj.m_werr_Jac) ...
                <= ( obj.optim_params.tol_norm_obj_grad * obj.m_num_cols_Jac)
            % Succesffully found a solution
            success = true;
            obj.printf('Solution found after %i iterations\n', lv1);
            break;
        end
    end
    
    
    if store_optim_stats 
        % Remove unnecessary values from the array of objective values
        if length( obj_val) > lv1
            obj_val( lv1 + 1 : end) = [];
        end
        
        % Store optimization stats in a struct
        optim_stats = struct( 'success', success, ...
            'obj_val_arr', obj_val, ...
            'norm_obj_grad', norm( obj.m_werr_val' * obj.m_werr_Jac));
    end
end