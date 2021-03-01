function element_SO3_inv = inverse(element_SO3)
%INVERSE Invert an element of SO3.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO3 : [3 x 3] double
%     An element of S03.
% element_SO3_inv : [3 x 3] double
%     The inverse of input.
% -------------------------------------------------------------------------
    element_SO3_inv = [];
    if SO3.isValidElement(element_SO3)
        element_SO3_inv = element_SO3.';
    end
end

