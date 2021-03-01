function [C, v, r] = decompose(element_SE22)
%DECOMPOSE Break element of SE22 up into its constituent parts. 
%
% PARAMETERS
% ----------
% element_SE22 : [4 x 4] double
%     An element of SE22.
%
% RETURNS
% -------
% C : [2 x 2] double
%     An element of SO2.
% v : [2 x 1] double
%     An element of R^2.
% r : [2 x 1] double
%     An element of R^2.
% -------------------------------------------------------------------------
    C = [];
    v = [];
    r = [];
    if SE22.isValidElement(element_SE22)
        C = element_SE22(1:2, 1:2);
        v = element_SE22(1:2, 3);
        r = element_SE22(1:2, 4);
    end
end

