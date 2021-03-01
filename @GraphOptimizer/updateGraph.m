function updateGraph( obj, varargin)
    % UPDATEGRAPH() takes the SEARCHDIRECTION * STEPLENGTH and provides as an
    % increment to the variable nodes
    %
    % UPDATEGRAPH( increment) takes the INCREMENT column matrix and
    % adds the appropriate increments to each pose (it finds the appropriate
    % rows in INCREMENT).
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Parse input
    % Default increment is the search direction * step_length
    defaultIncrement = obj.m_search_direction * obj.m_step_length;
    % Validator
    isValidIncrement = @( increment) all( size( increment) == ...
        [ obj.m_num_cols_Jac, 1] ) && isreal( increment) ...
        && ~any( isnan( increment));
    % Input parser
    p = inputParser;
    addOptional( p, 'increment', defaultIncrement, isValidIncrement);
    parse( p, varargin{ :});
    increment = p.Results.increment;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Pseudocode
    %   - For each variable node in the list of variables
    %       - find the first row of the variable using obj.m_idx_Jac_cols
    %       - get the degree of freedom of that variable using
    %           m_info_variables.dof
    %       - construct the indices (rows) to extract from INCREMENT
    %       - increment to variable using '+'.
    
    for lv1 = 1 : obj.m_num_variable_nodes
        % Compute the row indices to extract from INCREMENT        
        idx_rows = obj.m_idx_Jac_cols( lv1) + ( 0 : ...
            obj.m_info_variables( lv1).dof - 1);
         
        % Increment the node in the graph. 
        %   The '+' operator is overloaded in the variable nodes. Furthermore,
        %   since we're passing the nodes by reference, then the updated value
        %   is stored in the variable node object.
        obj.node( obj.m_info_variables( lv1).name) + increment( idx_rows);
    end
end