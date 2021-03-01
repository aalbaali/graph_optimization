function element_SE23_inv = inverse(element_SE23)
%INVERSE Invert an element of SE23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE23 : [5 x 5] double
%     An element of SE23.
% element_SE23_inv : [5 x 5] double
%     The inverse of input.
% -------------------------------------------------------------------------
    element_SE23_inv = [];
    if SE23.isValidElement(element_SE23)
        [C, v, r] = SE23.decompose(element_SE23);
        element_SE23_inv = [ C.', -C.' * v, -C.' * r ; 
                            zeros(2, 3), eye(2)     ];
    end
end

