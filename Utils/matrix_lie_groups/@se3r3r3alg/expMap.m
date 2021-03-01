function element_SE3R3R3 = expMap(element_se3r3r3)
%EXPMAP Map element of the matrix Lie algebra se3r3r3 to associated matrix
%Lie group SE3 x R3 x R3.
%
% PARAMETERS
% ----------
% element_se3r3r3 : [[9 x 9] double] OR [[12 x 1] double]
%     An element of se3r3r3 or its column parameterization. 
%
% RETURNS
% -------
% element_SE3 : [9 x 9] double
%     An element of SE3 x R3 x R3.
% -------------------------------------------------------------------------
    element_SE3R3R3 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se3r3r3, 12)
        element_se3r3r3 = se3r3r3alg.wedge(element_se3r3r3);
    end
    % If valid element, then form the Lie group element
    if se3r3r3alg.isValidElement(element_se3r3r3)
        [xi_phi, xi_r, xi_beta1, xi_beta2] = se3r3r3alg.decompose(element_se3r3r3);
        C = so3alg.expMap(xi_phi);
        J = SO3.computeJLeft(xi_phi);
        r = J * xi_r;
        element_SE3R3R3 = [ C, r, zeros(3, 5)                        ;
                            zeros(1, 3), 1, zeros(1, 5)              ;
                            zeros(3, 4), eye(3), xi_beta1, xi_beta2  ; 
                            zeros(2, 7), eye(2)                     ];
    end
end

