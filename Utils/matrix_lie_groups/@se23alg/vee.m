function se23_column = vee(element_se23)
%VEE The vee (columnizing) operator for se23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se23 : [5 x 5] double
%     An element of se23.
%
% RETURNS
% -------
% se23_column : [9 x 1] double
%     The R^9 parameterization of an element of se23.
% -------------------------------------------------------------------------
    se23_column = [];
    if se23alg.isValidElement(element_se23)
        [xi_phi, xi_v, xi_r] = se23alg.decompose(element_se23);
        % Form the return
        se23_column = [xi_phi; xi_v; xi_r];
    end
end

