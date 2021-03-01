function adj_SE3 = adjoint(element_SE3)
%ADJOINT Return the adjoint representation of the SE3 element.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE3 : [4 x 4] double
%     An element of SE3.
%
% RETURNS
% -------
% adj_SE3 : [6 x 6] double
%     The adjoint representation of the SE3 element.
% -------------------------------------------------------------------------
    adj_SE3 = [];
    if SE3.isValidElement(element_SE3)
        [C, r] = SE3.decompose(element_SE3);
        adj_SE3 = [ C, zeros(3)             ;
                    so3alg.cross(r) * C, C ];
    end
end

