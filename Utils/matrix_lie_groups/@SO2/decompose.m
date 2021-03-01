function theta = decompose(element_SO2)
%DECOMPOSE Break element of SO2 up into its constituent parts.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO2 : [2 x 2] double
%     An element of SO2.
%
% RETURNS
% -------
% theta : scalar
%     The rotation angle, in radians.
% -------------------------------------------------------------------------
    theta = [];
    if SO2.isValidElement(element_SO2)
        theta = acos(element_SO2(1, 1));
        if abs(theta) <= MLGUtils.tol_small_angle
            theta = 0; 
        elseif abs(pi - theta) <= MLGUtils.tol_small_angle  
            theta = pi;           
        elseif asin(element_SO2(2, 1)) < 0
            theta = -theta;
        end
    end
end

