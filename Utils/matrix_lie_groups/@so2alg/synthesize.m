function element_so2 = synthesize(theta)
%SYNTHESIZE Construct element of matrix Lie algebra so2.
% Enables instantiation of a Lie algebra element from a column matrix.
% Basically just call wedge().  
%
% PARAMETERS
% ----------
% theta : scalar
%     Theta value used for constructing so2 element, in radians.
%
% RETURNS
% -------
% element_so2 : [2 x 2] double
%     The corresponding elment of so2.
% -------------------------------------------------------------------------
    if MLGUtils.isValidRealMat(theta, 1, 1, 'so2 angle')
        element_so2 = so2alg.wedge(theta);
    end
end

