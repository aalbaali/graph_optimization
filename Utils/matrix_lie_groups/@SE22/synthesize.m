function element_SE23 = synthesize(rot, vel, disp)
%SYNTHESIZE Given an element of SO2 (or an angle), a velocity, and
%a displacement, return an element of SE22.
%
% PARAMETERS
% ----------
% rot : [[2 x 2] double] OR [double]
%     Either a valid element of SO2, or a rotation angle (SO2 ctor is
%     called).
% vel : [2 x 1] double
%     A velocity.
% disp : [2 x 1] double
%     A displacement.
%
% RETURNS
% -------
% element_SE22 : [4 x 4] double
%     An element of SE22 constructed from the input.
% -------------------------------------------------------------------------
    C = [];
    v = [];
    r = [];
    % If input is valid scalar, then synthesize element of SO2.
    if MLGUtils.isValidRealCol(rot, 1)
        rot = SO2.synthesize(rot);
    end
    % Verify rotation is a valid element of SO2.
    if SO2.isValidElement(rot)
        C = rot;
    end   
    % Check velocity
    if MLGUtils.isValidRealMat(vel, 2, 1, 'R^2')
        v = vel;
    end
    % Check displacement
    if MLGUtils.isValidRealMat(disp, 2, 1, 'R^2')
        r = disp;
    end
    % Form the group element
    element_SE23 = [ C, v, r            ; 
                     zeros(2), eye(2) ] ;
end

