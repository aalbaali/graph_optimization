function adj_SE23 = adjoint(element_SE23)
%ADJOINT Return the adjoint representation of the SE23 element.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE23 : [5 x 5] double
%     An element of SE23.
%
% RETURNS
% -------
% adj_SE3 : [9 x 9] double
%     The adjoint representation of the SE23 element.
% -------------------------------------------------------------------------
    adj_SE23 = [];
    if SE23.isValidElement(element_SE23)
        [C, v, r] = SE23.decompose(element_SE23);
        adj_SE23 = [ C, zeros(3, 6)                   ;
                    so3alg.cross(v) * C, C, zeros(3)  ;
                    so3alg.cross(r) * C, zeros(3), C ];
    end
end

