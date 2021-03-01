function element_SE23 = synthesize(rot, vel, disp)
%SYNTHESIZE Given an element of SO3 (or a rotation vector), a velocity, and
%a displacement, return an element of SE23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% rot : [[3 x 3] double] OR [[3 x 1] double]
%     Either a valid element of SO3, or a rotation vector (SO3 ctor is
%     called).
% vel : [3 x 1] double
%     A velocity.
% disp : [3 x 1] double
%     A displacement.
%
% RETURNS
% -------
% element_SE23 : [5 x 5] double
%     An element of SE23 constructed from the input.
% -------------------------------------------------------------------------
    C = [];
    v = [];
    r = [];
    % If input is valid column, then synthesize element of SO3.
    if MLGUtils.isValidRealCol(rot, 3)
        rot = SO3.synthesize(rot);
    end
    % Verify rotation is a valid element of SO3.
    if SO3.isValidElement(rot)
        C = rot;
    end   
    % Check velocity
    if MLGUtils.isValidRealMat(vel, 3, 1, 'R^3')
        v = vel;
    end
    % Check displacement
    if MLGUtils.isValidRealMat(disp, 3, 1, 'R^3')
        r = disp;
    end
    % Form the group element
    element_SE23 = [ C, v, r               ; 
                     zeros(2, 3), eye(2) ] ;
end

