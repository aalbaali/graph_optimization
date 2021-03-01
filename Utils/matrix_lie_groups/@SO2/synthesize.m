function element_SO2 = synthesize(theta)
%SYNTHESIZE Given an input angle, return an element of SO2.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% theta : scalar numeric
%     Rotation angle in radians.
%
% RETURNS
% -------
% element_SO2 : [2 x 2] double
%     An element of SO2 constructed from the input.
% -------------------------------------------------------------------------
    element_SO2 = [];
    % Check input
    if MLGUtils.isValidRealMat(theta, 1, 1, 'SO2')
        element_SO2 = so2alg.expMap(theta);
    end
end

