function element_SE22 = expMap(element_se22)
%EXPMAP Map element of the matrix Lie algebra se22 to associated matrix Lie
%group SE22.
%
% PARAMETERS
% ----------
% element_se22 : [[4 x 4] double] OR [[5 x 1] double]
%     An element of se22 or its column parameterization. 
%
% RETURNS
% -------
% element_SE22 : [4 x 4] double
%     An element of SE22.
% -------------------------------------------------------------------------
    element_SE22 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se22, 5)
        element_se22 = se22alg.wedge(element_se22);
    end
    % If valid element, then form the Lie group element
    if se22alg.isValidElement(element_se22)
        [xi_theta, xi_v, xi_r] = se22alg.decompose(element_se22);
        C = so2alg.expMap(xi_theta);
        J = SO2.computeJLeft(xi_theta);
        v = J * xi_v;
        r = J * xi_r;
        element_SE22 = [C, v, r          ;
                       zeros(2), eye(2) ];
    end
end

