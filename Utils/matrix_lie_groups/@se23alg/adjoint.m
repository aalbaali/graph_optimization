function adj_se23 = adjoint(element_se23)
%ADJOINT Return the adjoint representation of the se23 element. 
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se23 : [[5 x 5] double] OR [[9 x 1] double]
%     An element of se23 or its column parameterization. 
%
% RETURNS
% -------
% adj_se23 : [9 x 9] double
%     The adjoint representation of the se23 element.
% -------------------------------------------------------------------------
    adj_se23 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se23, 9)
        element_se23 = se23alg.wedge(element_se23);
    end
    % If valid element, then form the adjoint.
    if se23alg.isValidElement(element_se23)
        [xi_theta, xi_v, xi_r] = se23alg.decompose(element_se23);
        adj_se23 = [ so3alg.cross(xi_theta), zeros(3), zeros(3)            ;
                     so3alg.cross(xi_v), so3alg.cross(xi_theta), zeros(3)  ;
                     so3alg.cross(xi_r), zeros(3), so3alg.cross(xi_theta) ];
    end
end

