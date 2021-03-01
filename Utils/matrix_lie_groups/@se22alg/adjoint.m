function adj_se22 = adjoint(element_se22)
%ADJOINT Return the adjoint representation of the se22 element. 
%
% PARAMETERS
% ----------
% element_se22 : [[4 x 4] double] OR [[5 x 1] double]
%     An element of se22 or its column parameterization. 
%
% RETURNS
% -------
% adj_se22 : [5 x 5] double
%     The adjoint representation of the se22 element.
% -------------------------------------------------------------------------
    adj_se22 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_se22, 5)
        element_se22 = se22alg.wedge(element_se22);
    end
    % If valid element, then form the adjoint.
    if se22alg.isValidElement(element_se22)
        [xi_theta, xi_v, xi_r] = se22alg.decompose(element_se22);
        omega = [0, -1; 1, 0];
        adj_se22 = [ zeros(1, 5)                                     ;
                    -omega * xi_v, so2alg.wedge(xi_theta), zeros(2)  ;
                    -omega * xi_r, zeros(2), so2alg.wedge(xi_theta) ];
    end
end

