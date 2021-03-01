function element_SE3 = expMap(element_se3)
%EXPMAP Map element of the matrix Lie algebra se3 to associated matrix Lie
%group SE3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se3 : [[4 x 4] double] OR [[6 x 1] double]
%     An element of se3 or its column parameterization. 
%
% RETURNS
% -------
% element_SE3 : [4 x 4] double
%     An element of SE3.
% -------------------------------------------------------------------------
    element_SE3 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se3, 6)
        element_se3 = se3alg.wedge(element_se3);
    end
    % If valid element, then form the Lie group element
    if se3alg.isValidElement(element_se3)
        [xi_phi, xi_r] = se3alg.decompose(element_se3);
        C = so3alg.expMap(xi_phi);
        J = SO3.computeJLeft(xi_phi);
        r = J * xi_r;
        element_SE3 = [C, r            ;
                       zeros(1, 3), 1 ];
    end
end

