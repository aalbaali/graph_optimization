function element_se2 = wedge(se2_column)
%WEDGE The wedge (expansion) operator for se2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% se2_column : [3 x 1] double
%     The R^3 parameterization of an element of se2.
%
% RETURNS
% -------
% element_se2 : [3 x 3] double
%     An element of se2.
% -------------------------------------------------------------------------
    element_se2 = [];    
    % Check input
    if MLGUtils.isValidRealMat(se2_column, 3, 1, 'se2 column')
       % Construct the element of the Lie algebra.
       xi_theta = se2_column(1);
       xi_r     = se2_column(2:3);
       % Form the return
       element_se2 = [ so2alg.wedge(xi_theta), xi_r ;
                       zeros(1, 3)                 ];
    end
end

