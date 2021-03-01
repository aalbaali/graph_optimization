function element_se22 = synthesize(column_matrix)
%SYNTHESIZE Construct element of matrix Lie algebra se22.
% Enables instantiation of a Lie algebra element from a column matrix.
% Basically just call wedge().  
%
% PARAMETERS
% ----------
% column_matrix : [5 x 1] numeric
%     Column used for constructing se22 element.  Columns are given as: 
%
%     [ xi_theta; xi_v; xi_r ],
%
%     xi_theta \in R^1 (rotation angle), xi_v \in R^2, xi_r \in R^2.
%
% RETURNS
% -------
% element_se22 : [4 x 4] double
%     The corresponding elment of se22.
% -------------------------------------------------------------------------
    if MLGUtils.isValidRealMat(column_matrix, 5, 1, 'se22 column')
        element_se22 = se22alg.wedge(column_matrix);
    end
end

