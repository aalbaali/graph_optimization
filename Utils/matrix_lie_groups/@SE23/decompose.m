function [C, v, r] = decompose(element_SE23)
%DECOMPOSE Break element of SE23 up into its constituent parts. 
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE23 : [5 x 5] double
%     An element of SE23.
%
% RETURNS
% -------
% C : [3 x 3] double
%     An element of SO3.
% v : [3 x 1] double
%     An element of R^3.
% r : [3 x 1] double
%     An element of R^3.
% -------------------------------------------------------------------------
    C = [];
    v = [];
    r = [];
    if SE23.isValidElement(element_SE23)
        C = element_SE23(1:3, 1:3);
        v = element_SE23(1:3, 4);
        r = element_SE23(1:3, 5);
    end
end

