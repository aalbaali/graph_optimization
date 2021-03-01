function element_so3 = wedge(phi)
%WEDGE The wedge (expansion) operator for so3.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% phi : [3 x 1] double
%     The R^3 parameterization of an element of so3 (rotation matrix).
%
% RETURNS
% -------
% element_so3 : [3 x 3] double
%     An element of so3.
% -------------------------------------------------------------------------
    element_so3 = [];
    % Check input
    if MLGUtils.isValidRealMat(phi, 3, 1, 'so3 column')
       % Construct the element of the Lie algebra.
       element_so3 = [ 0, -phi(3), phi(2) ;
                       phi(3), 0, -phi(1) ;
                      -phi(2), phi(1), 0 ];
    end
end

