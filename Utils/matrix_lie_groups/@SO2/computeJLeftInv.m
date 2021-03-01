function J_left_inv = computeJLeftInv(theta)
%COMPUTEJLEFTINV Compute inverse of left Jacobian.
% From Section 5.2 of Lie Groups for 2D and 3D Transformations by Ethan
% Eade. When theta is small, use Taylor series expansion given in Section
% 11 of Lie Groups for Computer Vision (Ethan Eade).
%
% PARAMETERS
% ----------
% theta : scalar
%     Angle in radians.  
%
% RETURNS
% -------
% J_left_inv : [2 x 2] double
%     The inverse of the left Jacobian of SO2. 
% -------------------------------------------------------------------------
    J_left_inv = [];
    % Check inputs
    if MLGUtils.isValidRealMat(theta, 1, 1, 'theta')
        % When theta is small, compute Jinv using Taylor series expansion.
        if abs(theta) <= MLGUtils.tol_small_angle
            % Taylor series expansion.  See Lie Groups for Computer Vision
            % (155), (157).
            t2 = theta.^2;
            A = 1 - t2 / 6 * (1 - t2 / 20 * (1 - t2 / 42));
            B = theta * 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * ...
                (1 - t2 / 56)));
        else
            A = sin(theta) / theta;
            B = (1 - cos(theta)) / theta;
        end
        % Create return using (135) from Lie Groups for 2D and 3D
        % Transformations.
        J_left_inv = (1 / (A.^2 + B.^2)) * [A, B; -B, A];
    end
end

