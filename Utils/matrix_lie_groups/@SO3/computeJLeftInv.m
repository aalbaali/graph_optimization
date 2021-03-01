function J_left_inv = computeJLeftInv(phi)
%COMPUTEJLEFTINV Compute inverse of left Jacobian.
% From Section 9.3 of Lie Groups for Computer Vision by Ethan Eade. When
% angle is small, use Taylor series expansion given in Section 11.
%
% PARAMETERS
% ----------
% phi : [3 x 1] double
%     Rotation vector. 
%
% RETURNS
% -------
% J_left_inv : [3 x 3] double
%     The inverse of the left Jacobian of SO3. 
% -------------------------------------------------------------------------
    J_left_inv = [];
    % Check inputs
    if MLGUtils.isValidRealMat(phi, 3, 1, 'phi')
        angle = sqrt(phi.' * phi);
        % When angle is small, compute Jinv using Taylor series expansion.
        if angle <= MLGUtils.tol_small_angle
            % Taylor series expansion.  See (163).
            t2 = angle.^2;
            A = 1 / 12 * (1 + t2 / 60 * (1 + t2 / 42 * (1 + t2 / 40)));
        else
            % Compute using (125).
            A = 1 / angle.^2 * (1 - (angle * sin(angle) / (2 * (1 - cos(angle)))));
        end
        % Create return using (125).  `V' in Eade.
        J_left_inv = eye(3) - 1 / 2 * so3alg.cross(phi) + A * ...
            so3alg.cross(phi) * so3alg.cross(phi);
    end
end

