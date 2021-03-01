function element_SE2 = synthesize(rot, disp)
%SYNTHESIZE Given an element of SO2 (or an angle) and a displacement,
%return an element of SE2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% rot : [[2 x 2] double] OR [scalar]
%     Either a valid element of SO2, or an angle in radians (SO2 ctor is
%     called).
% disp : [2 x 1] double
%     A displacement.
%
% RETURNS
% -------
% element_SE2 : [3 x 3] double
%     An element of SE2 constructed from the input.
% -------------------------------------------------------------------------
    C = [];
    r = [];
    % If input is valid column, then synthesize element of SO2.
    if MLGUtils.isValidRealCol(rot, 1)
        rot = SO2.synthesize(rot);
    end
    % Verify rotation is a valid element of SO2. 
    if SO2.isValidElement(rot)
        C = rot;
    end
    % Check displacement
    if MLGUtils.isValidRealMat(disp, 2, 1, 'R^2')
        r = disp;
    end
    % Form the group element
    element_SE2 = [ C, r      ; 
                    0, 0, 1 ] ;
end

