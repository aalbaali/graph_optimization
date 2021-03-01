function adj_SE3R3R3 = adjoint(element_SE3R3R3)
%ADJOINT Return the adjoint representation of the SE3 x R3 x R3 element.
%
% PARAMETERS
% ----------
% element_SE3R3R3 : [9 x 9] double
%     An element of SE3 x R3 x R3.
%
% RETURNS
% -------
% adj_SE3R3R3 : [12 x 12] double
%     The adjoint representation of the SE3 x R3 x R3 element.
% -------------------------------------------------------------------------
    adj_SE3R3R3 = [];
    if SE3R3R3.isValidElement(element_SE3R3R3)
        [C, r, ~, ~] = SE3R3R3.decompose(element_SE3R3R3);
        adj_SE3R3R3 = [ SE3.adjoint(SE3.synthesize(C, r)), zeros(6)  ;
                        zeros(6), eye(6)                            ];
    end
end

