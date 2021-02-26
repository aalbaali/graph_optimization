function initializeInternalParameters( obj)
    % Protected method.
    %
    % INITIALIZEINTERNALPARAMETERS() builds the skeleton of the parameters to be
    % used. These include
    %   - number of variables,
    %   - number of factors,
    %   - information on each variable node (name and dof), 
    %   - information on each factor node (name and dim), 
    %   - block-level sparse Jacobian matrix, and
    %   - empty sparse error Jacobian of the appropriate sizes.
    
    % Lambda function that returns the variable node object
    getVarNodeObject = @( var_node) struct( 'name', var_node.name, ...
        'dof', var_node.dof);
    
    % Cell of variable node names
    variable_node_names = obj.factor_graph.getVariableNodeNames();    
        
    % Number of variable nodes
    obj.m_num_variable_nodes = length( variable_node_names);        
    
    % Struct array of variable nodes
    obj.m_info_variables = ...
        cellfun( @( name) getVarNodeObject( obj.node( name)), variable_node_names);
    % Array of Jacobian column index for each variable. The variables are in
    % the same order as in m_info_factors
    obj.m_idx_Jac_variables = cumsum( [ obj.m_info_variables.dof]);
    
    
    % Lambda function that returns the factor node object
    getFactNodeObject = @( fact_node) struct( 'name', fact_node.name, ...
        'dim', fact_node.errDim);
    % Cell of factor node names
    factor_node_names   = obj.factor_graph.getFactorNodeNames();
    % Number of factor nodes
    obj.m_num_factor_nodes   = length( factor_node_names);
    
    % Initialize the block-level Jacobian with zeros.
    obj.m_werr_Jac_blocks = sparse( [], [], [], obj.m_num_factor_nodes, ...
        obj.m_num_variable_nodes);    
    for lv1 = 1 : obj.m_num_factor_nodes    
        % Get factor node
        factor_node_lv1 = obj.node( factor_node_names{ lv1});
        
        %Struct array of factor nodes
        obj.m_info_factors( lv1) = ...
            getFactNodeObject( factor_node_lv1);
        
        % Get end nodes
        end_nodes_lv1 = factor_node_lv1.end_nodes;
        
        % For each end_node, find column in the list of variable nodes
        for lv2 = 1 : length( end_nodes_lv1)
            % Find column index
            idx_col = strcmp( [ obj.m_info_variables.name], ...
                end_nodes_lv1{ lv2}.name);
            
            % Fill the sparse Jacobian with a 1
            obj.m_werr_Jac_blocks( lv1, idx_col) = 1;
        end
    end
    
    % Set the total number of rows and columns in the full Jacobian
    obj.m_num_rows_Jac = sum( [ obj.m_info_factors.dim]);
    obj.m_num_cols_Jac = sum( [ obj.m_info_variables.dof]);
    
    % Build an empty sparse FULL Jacobian
    obj.m_werr_Jac = sparse( [], [], [], obj.m_num_rows_Jac, obj.m_num_cols_Jac);    
end