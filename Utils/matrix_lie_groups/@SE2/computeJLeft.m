function J_left = computeJLeft(xi)
%COMPUTEJLEFT Compute left Jacobian.
% From Sec. 10.6.2 of Stochastic Models, Information Theory, and Lie
% Groups, Vol. 2 by G. Chirikjian.
%
% PARAMETERS
% ----------
% xi : [3 x 1] double
%     An element of the vector space corresponding to SE2 Lie algebra.
%
% RETURNS
% -------
% J_left : [3 x 3] double
%     The left Jacobian of SE2.
% -------------------------------------------------------------------------
    J_left = [];
    % Check inputs
    if MLGUtils.isValidRealMat(xi, 3, 1, 'xi')
        a  = xi(1);
        v1 = xi(2);
        v2 = xi(3);
        % Deal with edge case
        if a == 0
            J_left = eye(3);
        else
            % Page 34, adapted to decar [xo_theta, xo_rho] convention
            J21 = (a * v1 + v2 - v2 * cos(a) - v1 * sin(a)) / a^2;
            J22 = sin(a) / a;
            J23 = (cos(a) - 1) / a;
            J31 = (-v1 + a * v2 + v1 * cos(a) - v2 * sin(a)) / a^2;
            J32 = (1 - cos(a)) / a;
            J33 = sin(a) / a;
            J_left = [ 1, 0, 0        ;
                       J21, J22, J23  ; 
                       J31, J32, J33 ];
        end
    end
end

