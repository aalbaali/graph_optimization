function [xi_phi, xi_v, xi_r] = decompose(element_se23)
%DECOMPOSE Break element of se23 up into its constituent parts. 
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se23 : [5 x 5] double
%     An element of se23.
%
% RETURNS
% -------
% xi_phi : [3 x 1] double
%     Rotation parameterization of Lie algebra.
% xi_v : [3 x 1] double
%     Velocity parameterization of Lie algebra.
% xi_r : [3 x 1] double
%     Position parameterization of Lie algebra.
% -------------------------------------------------------------------------
    xi_phi = [];
    xi_v = [];
    xi_r = [];
    if se23alg.isValidElement(element_se23)
        xi_phi = so3alg.vee(element_se23(1:3, 1:3));
        xi_v = element_se23(1:3, 4);
        xi_r = element_se23(1:3, 5);
    end
end

