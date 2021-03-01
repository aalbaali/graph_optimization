function [xi_theta, xi_r] = decompose(element_se2)
%DECOMPOSE Break element of se2 up into its constituent parts. 
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se2 : [3 x 3] double
%     An element of se2.
%
% RETURNS
% -------
% xi_theta : scalar
%     Rotation parameterization of Lie algebra.
% xi_r : [2 x 1] double
%     Position parameterization of Lie algebra.
% -------------------------------------------------------------------------
    xi_theta = [];
    xi_r = [];
    if se2alg.isValidElement(element_se2)
        xi_theta = element_se2(2, 1);
        xi_r = element_se2(1:2, 3);
    end
end

