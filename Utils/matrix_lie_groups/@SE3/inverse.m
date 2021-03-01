function element_SE3_inv = inverse(element_SE3)
%INVERSE Invert an element of SE3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE3 : [4 x 4] double
%     An element of SE3.
% element_SE3_inv : [4 x 4] double
%     The inverse of input.
% -------------------------------------------------------------------------
    element_SE3_inv = [];
    if SE3.isValidElement(element_SE3)
        [C, r] = SE3.decompose(element_SE3);
        element_SE3_inv = [ C.', -C.' * r   ; 
                            zeros(1, 3), 1 ];
    end
end

