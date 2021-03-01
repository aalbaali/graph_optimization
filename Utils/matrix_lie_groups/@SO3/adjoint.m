function adj_SO3 = adjoint(element_SO3)
%ADJOINT Return the adjoint representation of the SO3 element.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO3 : [3 x 3] double
%     An element of SO3.
%
% RETURNS
% -------
% adj_SO3 : [3 x 3] double
%     The adjoint representation of the SO3 element.
% -------------------------------------------------------------------------
    adj_SO3 = [];
    if SO3.isValidElement(element_SO3)
        adj_SO3 = element_SO3;
    end
end

