function element_SO3 = expMap(element_so3)
%EXPMAP Map element of the matrix Lie algebra so3 to associated matrix Lie
%group SO3.
% From Section 8.3 of Lie Groups for Computer Vision by Ethan Eade. When
% theta is small, use Taylor series expansion given in Section 11.
%
% PARAMETERS
% ----------
% element_so3 : [[3 x 3] double] OR [[3 x 1] double]
%     An element of so3 or its column parameterization. 
%
% RETURNS
% -------
% element_SO3 : [3 x 3] double
%     An element of SO3.
% -------------------------------------------------------------------------
    element_SO3 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_so3, 3)
        element_so3 = so3alg.cross(element_so3);
    end

    % If valid element, then form the Lie group element
    if so3alg.isValidElement(element_so3)
        phi = so3alg.vee(element_so3);
        angle = sqrt(phi.' * phi);
        % Implement (103) from Eade.
        if angle <= MLGUtils.tol_small_angle
            % Compute coefficients involving theta using Talyor series
            % expansion.  See (155), (157) from Eade.
            t2 = angle.^2;
            A = 1 - t2 / 6 * (1 - t2 / 20 * (1 - t2 / 42));
            B = 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * (1 - t2 / 56)));
        else
            A = sin(angle) / angle;
            B = (1 - cos(angle)) / angle.^2;
        end
        % Rodrigues rotation formula (103).  
        element_SO3 = eye(3) + A * element_so3 + B * element_so3^2;
    end
end

