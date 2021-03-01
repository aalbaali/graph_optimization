function theta = vee(element_so2)
%VEE The vee (columnizing) operator for so2.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_so2 : [2 x 2] double
%     An element of so2.
%
% RETURNS
% -------
% theta : scalar double
%     The R^1 parameterization of an element of so2.
% -------------------------------------------------------------------------
    theta = [];
    if so2alg.isValidElement(element_so2)
        theta = so2alg.decompose(element_so2);
    end
end

