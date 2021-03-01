function J_right_inv = computeJRightInv(theta)
%COMPUTEJRIGHTINV Compute inverse of right Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% theta : scalar
%     Angle in radians.  
%
% RETURNS
% -------
% J_right_inv : [2 x 2] double
%     The inverse of the right Jacobian of SO2. 
% -------------------------------------------------------------------------
    % Equation (7.87)
    J_right_inv = SO2.computeJLeftInv(-theta);
end

