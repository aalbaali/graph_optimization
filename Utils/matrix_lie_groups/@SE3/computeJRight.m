function J_right = computeJRight(xi)
%COMPUTEJLEFT Compute right Jacobian.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% xi : [6 x 1] double
%     An element of the vector space corresponding to SE3 Lie algebra.
%
% RETURNS
% -------
% J_right : [6 x 6] double
%     The right Jacobian of SE3.
% -------------------------------------------------------------------------
    % Equation (7.87)
    J_right = SE3.computeJLeft(-xi);
end

