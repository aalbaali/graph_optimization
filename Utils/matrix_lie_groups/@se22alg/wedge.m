function element_se22 = wedge(se22_column)
%WEDGE The wedge (expansion) operator for se22.
%
% PARAMETERS
% ----------
% se22_column : [5 x 1] double
%     The R^5 parameterization of an element of se22.
%
% RETURNS
% -------
% element_se22 : [4 x 4] double
%     An element of se22.
% -------------------------------------------------------------------------
    element_se22 = [];    
    % Check input
    if MLGUtils.isValidRealMat(se22_column, 5, 1, 'se22 column')
       % Construct the element of the Lie algebra.
       xi_theta = se22_column(1);
       xi_v     = se22_column(2:3);
       xi_r     = se22_column(4:5);
       % Form the return
       element_se22 = [ so2alg.wedge(xi_theta), xi_v, xi_r ;
                        zeros(2, 4)                       ];
    end
end

