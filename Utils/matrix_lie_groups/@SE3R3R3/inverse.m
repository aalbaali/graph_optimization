function element_SE3R3R3_inv = inverse(element_SE3R3R3)
%INVERSE Invert an element of SE3 x R3 x R3.
%
% PARAMETERS
% ----------
% element_SE3R3R3 : [9 x 9] double
%     An element of SE3 x R3 x R3.
% element_SE3R3R3_inv : [9 x 9] double
%     The inverse of input.
% -------------------------------------------------------------------------
    element_SE3R3R3_inv = [];
    if SE3R3R3.isValidElement(element_SE3R3R3)
        [C, r, beta1, beta2] = SE3R3R3.decompose(element_SE3R3R3);
        element_SE3R3R3_inv = [ C.', -C.' * r, zeros(3, 5)           ; 
                                zeros(1, 3), 1, zeros(1, 5)          ;
                                zeros(3, 4), eye(3), -beta1, -beta2  ;
                                zeros(2, 7), eye(2)                 ];
    end
end

