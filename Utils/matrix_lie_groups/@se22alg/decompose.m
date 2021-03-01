function [xi_theta, xi_v, xi_r] = decompose(element_se22)
%DECOMPOSE Break element of se22 up into its constituent parts. 
%
% PARAMETERS
% ----------
% element_se22 : [4 x 4] double
%     An element of se22.
%
% RETURNS
% -------
% xi_theta : double
%     Rotation parameterization of Lie algebra.
% xi_v : [2 x 1] double
%     Velocity parameterization of Lie algebra.
% xi_r : [2 x 1] double
%     Position parameterization of Lie algebra.
% -------------------------------------------------------------------------
    xi_theta = [];
    xi_v = [];
    xi_r = [];
    if se22alg.isValidElement(element_se22)
        xi_theta = so2alg.vee(element_se22(1:2, 1:2));
        xi_v = element_se22(1:2, 3);
        xi_r = element_se22(1:2, 4);
    end
end

