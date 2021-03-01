function [C, r] = decompose(element_SE2)
%DECOMPOSE Break element of SE2 up into its constituent parts. 
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE2 : [3 x 3] double
%     An element of SE2.
%
% RETURNS
% -------
% C : [2 x 2] double
%     An element of SO2.
% r : [2 x 1] double
%     An element of R^2.
% -------------------------------------------------------------------------
    C = [];
    r = [];
    if SE2.isValidElement(element_SE2)
        C = element_SE2(1:2, 1:2);
        r = element_SE2(1:2, 3);
    end
end

