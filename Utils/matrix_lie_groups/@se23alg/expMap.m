function element_SE23 = expMap(element_se23)
%EXPMAP Map element of the matrix Lie algebra se23 to associated matrix Lie
%group SE23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se23 : [[5 x 5] double] OR [[9 x 1] double]
%     An element of se23 or its column parameterization. 
%
% RETURNS
% -------
% element_SE23 : [5 x 5] double
%     An element of SE23.
% -------------------------------------------------------------------------
    element_SE23 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se23, 9)
        element_se23 = se23alg.wedge(element_se23);
    end
    % If valid element, then form the Lie group element
    if se23alg.isValidElement(element_se23)
        [xi_phi, xi_v, xi_r] = se23alg.decompose(element_se23);
        C = so3alg.expMap(xi_phi);
        J = SO3.computeJLeft(xi_phi);
        v = J * xi_v;
        r = J * xi_r;
        element_SE23 = [C, v, r             ;
                       zeros(2, 3), eye(2) ];
    end
end

