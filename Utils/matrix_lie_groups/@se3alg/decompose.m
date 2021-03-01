function [xi_phi, xi_r] = decompose(element_se3)
%DECOMPOSE Break element of se3 up into its constituent parts. 
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se3 : [4 x 4] double
%     An element of se3.
%
% RETURNS
% -------
% xi_phi : [3 x 1] double
%     Rotation parameterization of Lie algebra.
% xi_r : [3 x 1] double
%     Position parameterization of Lie algebra.
% -------------------------------------------------------------------------
    xi_phi = [];
    xi_r = [];
    if se3alg.isValidElement(element_se3)
        xi_phi = so3alg.vee(element_se3(1:3, 1:3));
        xi_r = element_se3(1:3, 4);
    end
end

