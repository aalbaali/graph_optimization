function J_left = computeJLeft(theta)
%COMPUTEJLEFT Compute left Jacobian.
% From Section 4.3 of Lie Groups for Computer Vision by Ethan Eade.  When
% angle is small, use Taylor series expansion given in Section 11.
%
% PARAMETERS
% ----------
% theta : scalar
%     Angle in radians.  
%
% RETURNS
% -------
% J_left : [2 x 2] double
%     The left Jacobian of SO2. 
% -------------------------------------------------------------------------
    J_left = [];
    % Check inputs
    if MLGUtils.isValidRealMat(theta, 1, 1, 'theta')
        % When theta is small, compute J using Taylor series expansion.
        if abs(theta) <= MLGUtils.tol_small_angle
            % Taylor series expansion.  See (155), (157). 
            t2 = theta.^2;
            J11 = 1 - t2 / 6 * (1 - t2 / 20 * (1 - t2 / 42));
            J12 = -theta * 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * ...
                (1 - t2 / 56)));
        else
            % Compute using (52).
            J11 = sin(theta) / theta;
            J12 = -(1 - cos(theta)) / theta;
        end
        % Create return using (52).  `V' in Eade.
        J21 = -J12;
        J22 = J11;
        J_left = [J11, J12; J21, J22];
    end
end

