function se22_column = vee(element_se22)
%VEE The vee (columnizing) operator for se22.
%
% PARAMETERS
% ----------
% element_se22 : [4 x 4] double
%     An element of se22.
%
% RETURNS
% -------
% se22_column : [5 x 1] double
%     The R^5 parameterization of an element of se22.
% -------------------------------------------------------------------------
    se22_column = [];
    if se22alg.isValidElement(element_se22)
        [xi_theta, xi_v, xi_r] = se22alg.decompose(element_se22);
        % Form the return
        se22_column = [xi_theta; xi_v; xi_r];
    end
end

