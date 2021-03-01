function adj_SO2 = adjoint(element_SO2)
%ADJOINT Return the adjoint representation of the SO2 element.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO2 : [2 x 2] double
%     An element of SO2.
%
% RETURNS
% -------
% adj_SO2 : [2 x 2] double
%     The adjoint representation of the SO2 element.
% -------------------------------------------------------------------------
    adj_SO2 = [];
    if SO2.isValidElement(element_SO2)
        adj_SO2 = eye(2);
    end
end

