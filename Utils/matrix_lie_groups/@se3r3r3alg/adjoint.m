function adj_se3r3r3 = adjoint(element_se3r3r3)
%ADJOINT Return the adjoint representation of the se3r3r3 element. 
%
% PARAMETERS
% ----------
% element_se3r3r3 : [[9 x 9] double] OR [[12 x 1] double]
%     An element of se3r3r3 or its column parameterization. 
%
% RETURNS
% -------
% adj_se3 : [12 x 12] double
%     The adjoint representation of the se3r3r3 element.
% -------------------------------------------------------------------------
    adj_se3r3r3 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se3r3r3, 12)
        element_se3r3r3 = se3r3r3alg.wedge(element_se3r3r3);
    end
    % If valid element, then form the adjoint.
    if se3r3r3alg.isValidElement(element_se3r3r3)
        [xi_phi, xi_r, xi_beta1, xi_beta2] = ...
            se3r3r3alg.decompose(element_se3r3r3);
        adj_se3r3r3 = [ so3alg.cross(xi_phi), zeros(3, 9)                                 ;
                        so3alg.cross(xi_r), so3alg.cross(xi_phi), zeros(3, 6)             ;
                        so3alg.cross(xi_beta1), zeros(3), so3alg.cross(xi_phi), zeros(3)  ;
                        so3alg.cross(xi_beta2), zeros(3, 6), so3alg.cross(xi_phi)        ];
    end
end

