function adj_so3 = adjoint(element_so3)
%ADJOINT Return the adjoint representation of the so3 element.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_so3 : [[3 x 3] double] OR [[3 x 1] double]
%     An element of so3 or its column parameterization. 
%
% RETURNS
% -------
% adj_so3 : [3 x 3] double
%     The adjoint representation of the so3 element.
% -------------------------------------------------------------------------
    adj_so3 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_so3, 3)
        element_so3 = so3alg.cross(element_so3);
    end
    % If valid element, then form the adjoint.
    if so3alg.isValidElement(element_so3)
        adj_so3 = element_so3;
    end
end

