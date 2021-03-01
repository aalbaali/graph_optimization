function adj_se2 = adjoint(element_se2)
%ADJOINT Return the adjoint representation of the se2 element. 
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se2 : [[3 x 3] double] OR [[3 x 1] double]
%     An element of se2 or its column parameterization. 
%
% RETURNS
% -------
% adj_se2 : [3 x 3] double
%     The adjoint representation of the se2 element.
% -------------------------------------------------------------------------
    adj_se2 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se2, 3)
        element_se2 = se2alg.wedge(element_se2);
    end
    % If valid element, then form the adjoint.
    if se2alg.isValidElement(element_se2)
        [xi_theta, xi_r] = se2alg.decompose(element_se2);
        adj_se2 = [ zeros(1, 3)         ;
                    xi_r(2), 0, -xi_theta ;
                   -xi_r(1), xi_theta, 0 ];
    end
end

