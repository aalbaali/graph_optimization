function element_se3 = synthesize(column_matrix)
%SYNTHESIZE Construct element of matrix Lie algebra se3.
% Enables instantiation of a Lie algebra element from a column matrix.
% Basically just call wedge().  
%
% PARAMETERS
% ----------
% column_matrix : [6 x 1] numeric
%     Column used for constructing se3 element.  Columns are given as: 
%
%     [ xi_phi; xi_r ],
%
%     xi_phi \in R^3 (rotation vector), xi_r \in R^3.
%
% RETURNS
% -------
% element_se3 : [4 x 4] double
%     The corresponding elment of se3.
% -------------------------------------------------------------------------
    if MLGUtils.isValidRealMat(column_matrix, 6, 1, 'se3 column')
        element_se3 = se3alg.wedge(column_matrix);
    end
end

