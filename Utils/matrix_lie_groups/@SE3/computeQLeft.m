function Q_left = computeQLeft(xi)
%COMPUTEQLEFT Needed calculation of left Jacobian for SE3.
% From Sec. 7.1.5 of State Estimation for Robotics by T. Barfoot.
%
% PARAMETERS
% ----------
% xi : [6 x 1] double
%     The vector space representation of an element of SE3.
%
% RETURNS
% -------
% Q_left : [3 x 3] double
%     Intermediate matrix Q_left, required for calculation of left
%     Jacobian.
% -------------------------------------------------------------------------
    Q_left = [];
    % Check inputs
    if MLGUtils.isValidRealMat(xi, 6, 1, 'xi')
        % Deal with edge case
        if xi(1:3) == zeros(3, 1)
            Q_left = zeros(3);
        else
            % Compute Q_left (7.86b).  Note that this is exact. 
            phi = xi(1:3);
            rho = xi(4:6);
            % Coefficients
            phi_n = vecnorm(phi);
            a1 = 1 / 2;
            a2 = (phi_n - sin(phi_n)) / phi_n^3;
            a3 = (phi_n^2 + 2 * cos(phi_n) - 2) / (2 * phi_n^4);
            a4 = (2 * phi_n - 3 * sin(phi_n) + phi_n * cos(phi_n)) / (2 * phi_n^5);
            % phi, rho terms
            rho_w = so3alg.wedge(rho);
            phi_w = so3alg.wedge(phi);
            b1 = rho_w;
            b2 = phi_w * rho_w + rho_w * phi_w + phi_w * rho_w * phi_w;
            b3 = phi_w * phi_w * rho_w + rho_w * phi_w * phi_w - 3 * phi_w * rho_w * phi_w;
            b4 = phi_w * rho_w * phi_w * phi_w + phi_w * phi_w * rho_w * phi_w;
            % Form Q_left
            Q_left = a1 * b1 + a2 * b2 + a3 * b3 + a4 * b4;
        end
    end
end

