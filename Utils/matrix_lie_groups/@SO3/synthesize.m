function element_SO3 = synthesize(varargin)
%SYNTHESIZE Given a rotation vector or axis-angle combination, return
%an element of SO3. 
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% varargin : [[3 x 1] double] OR [[3 x 1] double (axis) and scalar (angle)]
%     Either a rotation vector, or an axis-angle combination.  All angles
%     in radians, axis must be unit length.
%
% RETURNS
% -------
% element_SO3 : [3 x 3] double
%     An element of SO3 constructed from the input.
% -------------------------------------------------------------------------
    % Parse inputs
    % Rotation vector ctor
    if numel(varargin) == 1
        phi = varargin{1};
    elseif numel(varargin) == 2
        % Rotation axis + rotation angle ctor
        axis  = varargin{1};
        angle = varargin{2};
        % Rotation axis needs to be of unit length
        if norm(axis) ~= 1
            error('synthesizeSO3:AxisUnitLength', ...
                'Rotation axis must be of unit length.')
        end
        % Angle is real and of appropriate size
        if MLGUtils.isValidRealMat(angle, 1, 1, 'rotation angle')
            phi = axis * angle;
        end
    else
        % Unknown number of inputs, throw an error.
        error('synthesizeSO3:TooManyInputs', ['This function accepts '...
            'either one (rotation vector) or two (rotation axis + ' ...
            'rotation angle) inputs.  See function documentation.'])
    end        
    % Ensure phi is real and of the appropriate size
    if MLGUtils.isValidRealMat(phi, 3, 1, 'rotation vector')       
        % Create SO3 element using exponential map.
        element_SO3 = so3alg.expMap(phi);
    end
end

