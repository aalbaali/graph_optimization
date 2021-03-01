function J_left_inv = computeJLeftInv(xi)
%COMPUTEJLEFT Compute inverse of left Jacobian.
%
% PARAMETERS
% ----------
% xi : [3 x 1] double
%     An element of the vector space corresponding to SE2 Lie algebra.
%
% RETURNS
% -------
% J_left_inv : [3 x 3] double
%     The inverse of the left Jacobian of SE2.
% -------------------------------------------------------------------------
    J_left_inv = [];
    % Check inputs
    if MLGUtils.isValidRealMat(xi, 3, 1, 'xi')
        % Compute J_left
        J_left = SE2.computeJLeft(xi);
        % Invert using fancy 3x3 rules
        x0 = J_left(:, 1);
        x1 = J_left(:, 2);
        x2 = J_left(:, 3);
        det_J = dot(x0, cross(x1, x2));
        r0 = cross(x1, x2).';
        r1 = cross(x2, x0).';
        r2 = cross(x0, x1).';
        J_left_inv = 1 / det_J .* [ r0; r1; r2 ];
    end
end

