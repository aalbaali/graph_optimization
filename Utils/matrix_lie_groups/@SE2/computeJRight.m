function J_right = computeJRight(xi)
%COMPUTEJLEFT Compute right Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% xi : [3 x 1] double
%     An element of the vector space corresponding to SE2 Lie algebra.
%
% RETURNS
% -------
% J_right : [3 x 3] double
%     The right Jacobian of SE2.
% -------------------------------------------------------------------------
    % Equation (7.87)
    J_right = SE2.computeJLeft(-xi);
end

