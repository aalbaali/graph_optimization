function se3r3r3_column = vee(element_se3r3r3)
%VEE The vee (columnizing) operator for se3r3r3.
%
% PARAMETERS
% ----------
% element_se3r3r3 : [9 x 9] double
%     An element of se3r3r3.
%
% RETURNS
% -------
% se3r3r3_column : [12 x 1] double
%     The R^12 parameterization of an element of se3r3r3.
% -------------------------------------------------------------------------
    se3r3r3_column = [];
    if se3r3r3alg.isValidElement(element_se3r3r3)
        [xi_phi, xi_r, xi_beta1, xi_beta2] = ...
            se3r3r3alg.decompose(element_se3r3r3);
        % Form the return
        se3r3r3_column = [xi_phi; xi_r; xi_beta1; xi_beta2];
    end
end

