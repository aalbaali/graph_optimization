function se3_column = vee(element_se3)
%VEE The vee (columnizing) operator for se3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se3 : [4 x 4] double
%     An element of se3.
%
% RETURNS
% -------
% se3_column : [6 x 1] double
%     The R^6 parameterization of an element of se3.
% -------------------------------------------------------------------------
    se3_column = [];
    if se3alg.isValidElement(element_se3)
        [xi_phi, xi_r] = se3alg.decompose(element_se3);
        % Form the return
        se3_column = [xi_phi; xi_r];
    end
end

