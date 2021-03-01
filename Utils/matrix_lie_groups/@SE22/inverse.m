function element_SE22_inv = inverse(element_SE22)
%INVERSE Invert an element of SE22.
%
% PARAMETERS
% ----------
% element_SE22 : [4 x 4] double
%     An element of SE22.
% element_SE22_inv : [4 x 4] double
%     The inverse of input.
% -------------------------------------------------------------------------
    element_SE22_inv = [];
    if SE22.isValidElement(element_SE22)
        [C, v, r] = SE22.decompose(element_SE22);
        element_SE22_inv = [ C.', -C.' * v, -C.' * r ; 
                            zeros(2), eye(2)        ];
    end
end

