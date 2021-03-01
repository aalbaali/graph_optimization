function element_se2 = synthesize(column_matrix)
%SYNTHESIZE Construct element of matrix Lie algebra se2.
% Enables instantiation of a Lie algebra element from a column matrix.
% Basically just call wedge().  
%
% PARAMETERS
% ----------
% column_matrix : [3 x 1] numeric
%     Column used for constructing se2 element.  Columns are given as: 
%
%     [ xi_theta; xi_r ],
%
%     xi_theta \in R, xi_r \in R^2.
%
% RETURNS
% -------
% element_se2 : [3 x 3] double
%     The corresponding elment of se2.
% -------------------------------------------------------------------------
    if MLGUtils.isValidRealMat(column_matrix, 3, 1, 'se2 column')
        element_se2 = se2alg.wedge(column_matrix);
    end
end

