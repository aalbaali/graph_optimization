function adj_SE2 = adjoint(element_SE2)
%ADJOINT Return the adjoint representation of the SE2 element.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE2 : [3 x 3] double
%     An element of SE2.
%
% RETURNS
% -------
% adj_SE2 : [3 x 3] double
%     The adjoint representation of the SE2 element.
% -------------------------------------------------------------------------
    adj_SE2 = [];
    if SE2.isValidElement(element_SE2)
        [C, r] = SE2.decompose(element_SE2);
        omega = [0, -1; 1, 0];
        adj_SE2 = [ 1, zeros(1, 2);
                   -omega * r, C ];
    end
end

