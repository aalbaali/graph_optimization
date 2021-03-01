function [xi_phi, xi_r, xi_beta1, xi_beta2] = decompose(element_se3r3r3)
%DECOMPOSE Break element of se3r3r3 up into its constituent parts. 
%
% PARAMETERS
% ----------
% element_se3r3r3 : [9 x 9] double
%     An element of se3r3r3.
%
% RETURNS
% -------
% xi_phi : [3 x 1] double
%     Rotation parameterization of Lie algebra.
% xi_r : [3 x 1] double
%     Position parameterization of Lie algebra.
% xi_beta1 : [3 x 1] double
%     Bias 1 parameterization of Lie algebra.
% xi_beta2 : [3 x 1] double
%     Bias 2 parameterization of Lie algebra.
% -------------------------------------------------------------------------
    xi_phi = [];
    xi_r = [];
    xi_beta1 = [];
    xi_beta2 = [];
    if se3r3r3alg.isValidElement(element_se3r3r3)
        xi_phi = so3alg.vee(element_se3r3r3(1:3, 1:3));
        xi_r = element_se3r3r3(1:3, 4);
        xi_beta1 = element_se3r3r3(5:7, 8);
        xi_beta2 = element_se3r3r3(5:7, 9);
    end
end

