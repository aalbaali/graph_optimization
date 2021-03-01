function [C, r, beta1, beta2] = decompose(element_SE3R3R3)
%DECOMPOSE Break element of SE3 x R3 x R3 up into its constituent parts. 
%
% PARAMETERS
% ----------
% element_SE3R3R3 : [9 x 9] double
%     An element of SE3 x R3 x R3.
%
% RETURNS
% -------
% C : [3 x 3] double
%     An element of SO3.
% r : [3 x 1] double
%     An element of R^3.
% beta1 : [3 x 1] double
%     An element of R^3.
% beta2 : [3 x 1] double
%     An element of R^3.
% -------------------------------------------------------------------------
    C = [];
    r = [];
    beta1 = [];
    beta2 = [];
    if SE3R3R3.isValidElement(element_SE3R3R3)
        C = element_SE3R3R3(1:3, 1:3);
        r = element_SE3R3R3(1:3, 4);
        beta1 = element_SE3R3R3(5:7, 8);
        beta2 = element_SE3R3R3(5:7, 9);
    end
end

