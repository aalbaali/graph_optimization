function element_se3r3r3 = wedge(se3r3r3_column)
%WEDGE The wedge (expansion) operator for se3r3r3.
%
% PARAMETERS
% ----------
% se3r3r3_column : [12 x 1] double
%     The R^12 parameterization of an element of se3r3r3.
%
% RETURNS
% -------
% element_se3r3r3 : [9 x 9] double
%     An element of se3r3r3.
% -------------------------------------------------------------------------
    element_se3r3r3 = [];    
    % Check input
    if MLGUtils.isValidRealMat(se3r3r3_column, 12, 1, 'se3r3r3 column')
       % Construct the element of the Lie algebra.
       xi_phi   = se3r3r3_column(1:3);
       xi_r     = se3r3r3_column(4:6);
       xi_beta1 = se3r3r3_column(7:9);
       xi_beta2 = se3r3r3_column(10:12);
       % Form the return
       element_se3r3r3 = [ so3alg.cross(xi_phi), xi_r, zeros(3, 5)  ;
                           zeros(1, 9)                              ;
                           zeros(3, 7), xi_beta1, xi_beta2          ;
                           zeros(2, 9)                             ];  
    end
end

