function [C, r] = decompose(element_SE3)
%DECOMPOSE Break element of SE3 up into its constituent parts. 
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE3 : [4 x 4] double
%     An element of SE3.
%
% RETURNS
% -------
% C : [3 x 3] double
%     An element of SO3.
% r : [3 x 1] double
%     An element of R^3.
% -------------------------------------------------------------------------
    C = [];
    r = [];
    if SE3.isValidElement(element_SE3)
        C = element_SE3(1:3, 1:3);
        r = element_SE3(1:3, 4);
    end
end

