function element_so3 = logMap(element_SO3)
%LOGMAP Map element of the matrix Lie group SO3 to associated matrix Lie
%algebra so3.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO3 : [3 x 3] double
%     An element of SO3.
%
% RETURNS
% -------
% element_so3 : [3 x 3] double
%     The corresponding element of so3.
% -------------------------------------------------------------------------
    element_so3 = [];
    if SO3.isValidElement(element_SO3)
        phi = SO3.decompose(element_SO3);
        element_so3 = so3alg.cross(phi);
    end
end

