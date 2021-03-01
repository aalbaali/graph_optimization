function J_left_inv = computeJLeftInv(xi)
%COMPUTEJLEFT Compute inverse of left Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% xi : [6 x 1] double
%     An element of the vector space corresponding to SE3 Lie algebra.
%
% RETURNS
% -------
% J_left_inv : [6 x 6] double
%     The inverse of the left Jacobian of SE3.
% -------------------------------------------------------------------------
    J_left_inv = [];
    % Check inputs
    if MLGUtils.isValidRealMat(xi, 6, 1, 'xi')
        % Compute Q_left
        Q_left = SE3.computeQLeft(xi);
        % Form inverse of left Jacobian (7.95b, adapted to [phi rho].')
        phi = xi(1:3);
        J_3 = SO3.computeJLeftInv(phi);
        J_left_inv = [ J_3, zeros(3); -J_3 * Q_left * J_3, J_3 ];
    end
end

