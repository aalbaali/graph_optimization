function element_se3r3r3 = synthesize(column_matrix)
%SYNTHESIZE Construct element of matrix Lie algebra se3r3r3.
% Enables instantiation of a Lie algebra element from a column matrix.
% Basically just call wedge().  
%
% PARAMETERS
% ----------
% column_matrix : [12 x 1] numeric
%     Column used for constructing se3r3r3 element.  Columns are given as: 
%
%     [ xi_phi; xi_r; xi_beta1; xi_beta2 ],
%
%     xi_phi \in R^3 (rotation vector), xi_r \in R^3, xi_beta1 \in R^3,
%     xi_beta2 \in R^3.
%
% RETURNS
% -------
% element_se3r3r3 : [9 x 9] double
%     The corresponding elment of se3r3r3.
% -------------------------------------------------------------------------
    if MLGUtils.isValidRealMat(column_matrix, 12, 1, 'se3r3r3 column')
        element_se3r3r3 = se3r3r3alg.wedge(column_matrix);
    end
end

