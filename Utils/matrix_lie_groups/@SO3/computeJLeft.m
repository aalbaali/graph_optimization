function J_left = computeJLeft(phi)
%COMPUTEJLEFT Compute left Jacobian.
% From Section 9.3 of Lie Groups for Computer Vision by Ethan Eade.  When
% angle is small, use Taylor series expansion given in Section 11.
%
% PARAMETERS
% ----------
% phi : [3 x 1] double
%     Rotation vector.
%
% RETURNS
% -------
% J_left : [3 x 3] double
%     The left Jacobian of SO3. 
% -------------------------------------------------------------------------
    J_left = [];
    % Check inputs
    if MLGUtils.isValidRealMat(phi, 3, 1, 'phi')
        angle = sqrt(phi.' * phi);
        % When angle is small, compute J using Taylor series expansion.
        if angle <= MLGUtils.tol_small_angle
            % Taylor series expansion.  See (157), (159).
            t2 = angle.^2;
            A = 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * ...
                (1 - t2 / 56)));
            B = 1 / 6 * (1 - t2 / 20 * (1 - t2 / 42 * (1 - t2 / 72)));
        else
            % Compute using (124).
            A = (1 - cos(angle)) / angle.^2;
            B = (angle - sin(angle)) / angle.^3;
        end
        % Create return using (124).  `V', in Eade.
        J_left = eye(3) + A * so3alg.cross(phi) + B * so3alg.cross(phi)^2;
    end
end

