function element_se23 = synthesize(column_matrix)
%SYNTHESIZE Construct element of matrix Lie algebra se23.
% Enables instantiation of a Lie algebra element from a column matrix.
% Basically just call wedge().  
%
% PARAMETERS
% ----------
% column_matrix : [9 x 1] numeric
%     Column used for constructing se23 element.  Columns are given as: 
%
%     [ xi_phi; xi_v; xi_r ],
%
%     xi_phi \in R^3 (rotation vector), xi_v \in R^3, xi_r \in R^3.
%
% RETURNS
% -------
% element_se23 : [5 x 5] double
%     The corresponding elment of se23.
% -------------------------------------------------------------------------
    if MLGUtils.isValidRealMat(column_matrix, 9, 1, 'se23 column')
        element_se23 = se23alg.wedge(column_matrix);
    end
end

