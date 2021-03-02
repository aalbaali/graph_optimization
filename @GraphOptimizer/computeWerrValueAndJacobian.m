function computeWerrValueAndJacobian( obj, varargin)
    % COMPUTEWERRVALUEANDJACOBIAN() construct the weighted error vector and
    % Jacobians from the factor graph
    % 
    % COMPUTEWERRVALUEANDJACOBIAN( 'compute_jac', false) constructs the weighted
    % error column matrix without the Jacobians. Default value is true.
    
    % Pseudocode
    % - Go over each factor in the list. 
    %   - Get the indices of the Jacobian rows to fill (from m_info_factors)
    %   - get the Jacobians (cell) from the factor
    %   - For each end node names from the factor (array)
    %       - find the node index location within the m_info_variables
    %       - use that location to find the columns to fill the Jacobian (using
    %           m_info_variables)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Input parser
    p = inputParser;
    defaultComputeJac = true;
    isDefaultComputeJac = @( err_only) islogical( err_only);
    addParameter( p, 'compute_jac', defaultComputeJac, isDefaultComputeJac);
    parse( p, varargin{ :});
    compute_jac = p.Results.compute_jac;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for lv1 = 1 : obj.m_num_factor_nodes        
        % Get the factor node
        factor_node = obj.m_info_factors( lv1).node;
        
        % Get the Jacobian row indices.
        idx_rows = obj.m_idx_Jac_rows( lv1) + ( 0 : ...
            obj.m_info_factors( lv1).dim - 1);
        
        if compute_jac
            % Get Jacobians of the error function w.r.t. variables
            jacobian_cells = factor_node.werr_Jacobians;
        end
        
        % Get the end node names
        end_nodes = factor_node.end_nodes;
        
        for lv2 = 1 : length( end_nodes)
            % Find the variable node from the variable node information array 
            idx = end_nodes{ lv2}.params.GraphOptimization.idx_info_variables;
            
            % Get column indices
            idx_cols = obj.m_idx_Jac_cols( idx) ...
                + ( 0 : obj.m_info_variables( idx).dof - 1);
            
            if compute_jac
                % Assign Jacobian
                obj.m_werr_Jac( idx_rows, idx_cols) = jacobian_cells{ lv2};
            end
        end
        
        % Update the weighted error column matrix
        obj.m_werr_val( idx_rows) = factor_node.werr_val;
    end
end