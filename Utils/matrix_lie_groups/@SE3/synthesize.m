function element_SE3 = synthesize(rot, disp)
%SYNTHESIZE Given an element of SO3 (or a rotation vector) and a
%displacement, return an element of SE3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% rot : [[3 x 3] double] OR [[3 x 1] double]
%     Either a valid element of SO3, or a rotation vector (SO3 ctor is
%     called).
% disp : [3 x 1] double
%     A displacement.
%
% RETURNS
% -------
% element_SE3 : [4 x 4] double
%     An element of SE3 constructed from the input.
% -------------------------------------------------------------------------
    C = [];
    r = [];
    % If input is valid column, then synthesize element of SO3.
    if MLGUtils.isValidRealCol(rot, 3)
        rot = SO3.synthesize(rot);
    end
    % Verify rotation is a valid element of SO3.
    if SO3.isValidElement(rot)
        C = rot;
    end   
    % Check displacement
    if MLGUtils.isValidRealMat(disp, 3, 1, 'R^3')
        r = disp;
    end
    % Form the group element
    element_SE3 = [ C, r             ; 
                    zeros(1, 3), 1 ] ;
end

