function adj_so2 = adjoint(element_so2)
%ADJOINT Return the adjoint representation of the so2 element.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_so2 : [[2 x 2] double] OR scalar
%     An element of so2 or its column parameterization. 
%
% RETURNS
% -------
% adj_so2 : scalar
%     The adjoint representation of the so2 element.
% -------------------------------------------------------------------------
    adj_so2 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_so2, 1)
        element_so2 = so2alg.wedge(element_so2);
    end
    % If valid element, then form the adjoint.
    if so2alg.isValidElement(element_so2)
        adj_so2 = 0;
    end
end

