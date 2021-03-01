function theta = decompose(element_so2)
%DECOMPOSE Break element of so2 up into its constituent parts. 
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_so2 : [2 x 2] double
%     An element of so2.
%
% RETURNS
% -------
% theta : scalar
%     Rotation parameterization of Lie algebra.
% -------------------------------------------------------------------------
    theta = [];
    if so2alg.isValidElement(element_so2)
        theta = element_so2(2, 1);
    end
end

