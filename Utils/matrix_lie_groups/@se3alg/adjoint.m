function adj_se3 = adjoint(element_se3)
%ADJOINT Return the adjoint representation of the se3 element. 
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se3 : [[4 x 4] double] OR [[6 x 1] double]
%     An element of se3 or its column parameterization. 
%
% RETURNS
% -------
% adj_se3 : [6 x 6] double
%     The adjoint representation of the se3 element.
% -------------------------------------------------------------------------
    adj_se3 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se3, 6)
        element_se3 = se3alg.wedge(element_se3);
    end
    % If valid element, then form the adjoint.
    if se3alg.isValidElement(element_se3)
        [xi_phi, xi_r] = se3alg.decompose(element_se3);
        adj_se3 = [ so3alg.cross(xi_phi), zeros(3)            ;
                    so3alg.cross(xi_r), so3alg.cross(xi_phi) ];
    end
end

