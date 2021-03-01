function J_left = computeJLeft(xi)
%COMPUTEJLEFT Compute left Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% xi : [6 x 1] double
%     An element of the vector space corresponding to SE3 Lie algebra.
%
% RETURNS
% -------
% J_left : [6 x 6] double
%     The left Jacobian of SE3.
% -------------------------------------------------------------------------
    J_left = [];
    % Check inputs
    if MLGUtils.isValidRealMat(xi, 6, 1, 'xi')
        % Compute Q_left
        Q_left = SE3.computeQLeft(xi);
        % Form left Jacobian (7.85b, adapted to [phi rho].')
        phi = xi(1:3);
        J_left = [ SO3.computeJLeft(phi), zeros(3); Q_left, SO3.computeJLeft(phi) ];
    end
end

