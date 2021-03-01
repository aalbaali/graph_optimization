function element_se3 = wedge(se3_column)
%WEDGE The wedge (expansion) operator for se3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% se3_column : [6 x 1] double
%     The R^6 parameterization of an element of se3.
%
% RETURNS
% -------
% element_se3 : [4 x 4] double
%     An element of se3.
% -------------------------------------------------------------------------
    element_se3 = [];    
    % Check input
    if MLGUtils.isValidRealMat(se3_column, 6, 1, 'se3 column')
       % Construct the element of the Lie algebra.
       xi_phi = se3_column(1:3);
       xi_r   = se3_column(4:6);
       % Form the return
       element_se3 = [ so3alg.cross(xi_phi), xi_r ;
                       zeros(1, 4)               ];
    end
end

