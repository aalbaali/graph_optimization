function se2_column = vee(element_se2)
%VEE The vee (columnizing) operator for se2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se2 : [3 x 3] double
%     An element of se2.
%
% RETURNS
% -------
% se2_column : [3 x 1] double
%     The R^3 parameterization of an element of se2.
% -------------------------------------------------------------------------
    se2_column = [];
    if se2alg.isValidElement(element_se2)
        [xi_theta, xi_r] = se2alg.decompose(element_se2);
        % Form the return
        se2_column = [xi_theta; xi_r];
    end
end

