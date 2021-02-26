function reorderColumns( obj)
    %REORDERCOLUMNS() finds a new ordering for the graph using some ordering
    %such as COLAMD on a *block level*. 
    
    % Find the column ordering of the block-level Jacobian
    idx_cols = colamd( obj.m_werr_Jac_blocks);
    
    % Update necessary variables
    %   1. the block-level Jacobian
    obj.m_werr_Jac_blocks = obj.m_werr_Jac_blocks( :, idx_cols);
    
    %   2. the variable node information    
    obj.m_info_variables = obj.m_info_variables( idx_cols);
    
    %   3. the indices of the array of Jacobian column index for each variable
    obj.updateJacobianColIndices();
end