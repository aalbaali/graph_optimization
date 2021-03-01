function J_right_inv = computeJRightInv(phi)
%COMPUTEJRIGHTINV Compute inverse of right Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% phi : [3 x 1] double
%     Rotation vector.
%
% RETURNS
% -------
% J_right_inv : [3 x 3] double
%     The inverse of the right Jacobian of SO3. 
% -------------------------------------------------------------------------
    % Equation (7.87)
    J_right_inv = SO3.computeJLeftInv(-phi);
end

