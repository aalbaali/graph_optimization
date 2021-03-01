function J_right = computeJRight(phi)
%COMPUTEJRIGHT Compute right Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% phi : [3 x 1] double
%     Rotation vector.
%
% RETURNS
% -------
% J_right : [3 x 3] double
%     The right Jacobian of SO3. 
% -------------------------------------------------------------------------
    % Equation (7.87)
    J_right = SO3.computeJLeft(-phi);
end

