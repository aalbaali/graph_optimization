function phi = vee(element_so3)
%VEE The vee (columnizing) operator for so3.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_so3 : [3 x 3] double
%     An element of so3.
%
% RETURNS
% -------
% phi : [3 x 1] double
%     The R^3 parameterization of an element of so3 (rotation vector).
% -------------------------------------------------------------------------
    phi = [];
    if so3alg.isValidElement(element_so3)
        phi = so3alg.decompose(element_so3);
    end
end

