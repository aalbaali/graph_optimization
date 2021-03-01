function element_SE2_inv = inverse(element_SE2)
%INVERSE Invert an element of SE2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE2 : [3 x 3] double
%     An element of SE2.
% element_SE2_inv : [3 x 3] double
%     The inverse of input.
% -------------------------------------------------------------------------
    element_SE2_inv = [];
    if SE2.isValidElement(element_SE2)
        [C, r] = SE2.decompose(element_SE2);
        element_SE2_inv = [ C.', -C.' * r ; 
                            0, 0, 1      ];
    end
end

