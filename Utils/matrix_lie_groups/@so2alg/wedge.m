function element_so2 = wedge(theta)
%WEDGE The wedge (expansion) operator for so2.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% theta : scalar
%     The R^1 parameterization of an element of so2.
%
% RETURNS
% -------
% element_so2 : [2 x 2] double
%     An element of so2.
% -------------------------------------------------------------------------
    element_so2 = [];
    % Check input
    if MLGUtils.isValidRealMat(theta, 1, 1, 'so2 column')
       % Construct the element of the Lie algebra.
       element_so2 = [ 0, -theta ; 
                       theta, 0 ];
    end
end

