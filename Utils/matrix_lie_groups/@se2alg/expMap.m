function element_SE2 = expMap(element_se2)
%EXPMAP Map element of the matrix Lie algebra se2 to associated matrix Lie
%group SE2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_se2 : [[3 x 3] double] OR [[3 x 1] double]
%     An element of se2 or its column parameterization. 
%
% RETURNS
% -------
% element_SE2 : [3 x 3] double
%     An element of SE2.
% -------------------------------------------------------------------------
    element_SE2 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se2, 3)
        element_se2 = se2alg.wedge(element_se2);
    end
    % If valid element, then form the Lie group element
    if se2alg.isValidElement(element_se2)
        [xi_theta, xi_r] = se2alg.decompose(element_se2);
        C = so2alg.expMap(xi_theta);
        J = SO2.computeJLeft(xi_theta);
        r = J * xi_r;
        element_SE2 = [C, r     ;
                       0, 0, 1 ];
    end
end

