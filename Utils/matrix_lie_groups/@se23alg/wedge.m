function element_se23 = wedge(se23_column)
%WEDGE The wedge (expansion) operator for se23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% se23_column : [9 x 1] double
%     The R^9 parameterization of an element of se23.
%
% RETURNS
% -------
% element_se23 : [5 x 5] double
%     An element of se23.
% -------------------------------------------------------------------------
    element_se23 = [];    
    % Check input
    if MLGUtils.isValidRealMat(se23_column, 9, 1, 'se23 column')
       % Construct the element of the Lie algebra.
       xi_phi = se23_column(1:3);
       xi_v   = se23_column(4:6);
       xi_r   = se23_column(7:9);
       % Form the return
       element_se23 = [ so3alg.cross(xi_phi), xi_v, xi_r ;
                        zeros(2, 5)                     ];
    end
end

