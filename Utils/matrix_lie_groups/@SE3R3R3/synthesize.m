function element_SE3R3R3 = synthesize(rot, disp, bias1, bias2)
%SYNTHESIZE Given an element of SO3 (or a rotation vector), a displacement,
%and two biases, return an element of SE3 x R3 x R3.
%
% PARAMETERS
% ----------
% rot : [[3 x 3] double] OR [[3 x 1] double]
%     Either a valid element of SO3, or a rotation vector (SO3 ctor is
%     called).
% disp : [3 x 1] double
%     A displacement.
% bias1 : [3 x 1] double
%     A bias.
% bias2 : [3 x 1] double
%     A bias.
%
% RETURNS
% -------
% element_SE3R3R3 : [9 x 9] double
%     An element of SE3 x R3 x R3 constructed from the input.
% -------------------------------------------------------------------------
    C = [];
    r = [];
    b1 = [];
    b2 = [];
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
     % Check first bias
    if MLGUtils.isValidRealMat(bias1, 3, 1, 'R^3')
        b1 = bias1;
    end
    % Check second bias
    if MLGUtils.isValidRealMat(bias2, 3, 1, 'R^3')
        b2 = bias2;
    end
    % Form the group element
    element_SE3R3R3 = [ C, r, zeros(3, 5)            ; 
                        zeros(1, 3), 1, zeros(1, 5)  ;
                        zeros(3, 4), eye(3), b1, b2  ;
                        zeros(2, 7), eye(2)         ];
end

