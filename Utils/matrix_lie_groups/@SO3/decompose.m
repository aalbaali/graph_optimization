function phi = decompose(element_SO3)
%DECOMPOSE Break element of SO3 up into its constituent parts (rotation
%vector)
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO3 : [3 x 3] double
%     An element of SO3.
%
% RETURNS
% -------
% phi : [3 x 1] double
%     The corresponding rotation vector.
% -------------------------------------------------------------------------
    if SO3.isValidElement(element_SO3)
        % Get the rotation angle
        cos_angle = (trace(element_SO3) - 1) / 2;
        % Need to deal with two special cases: angle near zero, and angle
        % near pi.
        if abs(acos(cos_angle)) <= MLGUtils.tol_small_angle
            phi = [0, 0, 0].';
            return
        elseif abs(pi - acos(cos_angle)) <= MLGUtils.tol_small_angle
            my_angle = pi;
            axisMat = element_SO3 + eye(3);
            % Find first nonzero column
            for lv1 = 1:3
                norm_axis = norm(axisMat(:, lv1));
                if norm_axis >= MLGUtils.tol_small_angle
                    my_axis = axisMat(:, lv1) / norm_axis;
                    break
                end
            end
        else
        % Regular case
        my_angle = acos(cos_angle);
        my_axis = 1 / ( 2 * sin(my_angle)) * [ element_SO3(3, 2) - element_SO3(2, 3)  ;
                                               element_SO3(1, 3) - element_SO3(3, 1)  ;
                                               element_SO3(2, 1) - element_SO3(1, 2) ];
        end
    % Rotation vector
    phi = my_angle * my_axis;
    end
end

