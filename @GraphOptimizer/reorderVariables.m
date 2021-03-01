function reorderVariables( obj)
    %REORDERVARIABLES() finds a new variable ordering (i.e., block-wise Jacobian
    %column ordering) using colamd.
    
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