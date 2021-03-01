function element_SO2_inv = inverse(element_SO2)
%INVERSE Invert an element of SO2. 
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO2 : [2 x 2] double
%     An element of SO2.
% element_SO2_inv : [2 x 2] double
%     The inverse of input.
% -------------------------------------------------------------------------
    element_SO2_inv = [];
    if SO2.isValidElement(element_SO2)
        element_SO2_inv = element_SO2.';
    end
end

