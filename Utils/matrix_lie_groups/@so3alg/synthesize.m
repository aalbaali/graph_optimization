function element_so3 = synthesize(phi)
%SYNTHESIZE Construct element of matrix Lie algebra so3.
% Enables instantiation of a Lie algebra element from a column matrix.
% Basically just call wedge().
%
% PARAMETERS
% ----------
% phi : [3 x 1] numeric
%     Rotation vector used for constructing so3 element.
%
% RETURNS
% -------
% element_so3 : [3 x 3] double
%     The corresponding elment of so3.
% -------------------------------------------------------------------------
    if MLGUtils.isValidRealMat(phi, 3, 1, 'so3 column')
        element_so3 = so3alg.cross(phi);
    end
end

