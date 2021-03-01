function J_right = computeJRight(theta)
%COMPUTEJRIGHT Compute right Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% theta : scalar
%     Angle in radians.  
%
% RETURNS
% -------
% J_right : [2 x 2] double
%     The right Jacobian of SO2. 
% -------------------------------------------------------------------------
    % Equation (7.87)
    J_right = SO2.computeJLeft(-theta);
end

