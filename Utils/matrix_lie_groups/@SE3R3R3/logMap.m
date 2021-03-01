function element_se3r3r3 = logMap(element_SE3R3R3)
%LOGMAP Map element of the matrix Lie group SE3 x R3 x R3 to associated
%matrix Lie algebra se3r3r3.
%
% PARAMETERS
% ----------
% element_SE3R3R3 : [9 x 9] double
%     An element of SE3 x R3 x R3.
%
% RETURNS
% -------
% element_se3r3r3 : [9 x 9] double
%     The corresponding element of se3r3r3.
% -------------------------------------------------------------------------
    element_se3r3r3 = [];   
    if SE3R3R3.isValidElement(element_SE3R3R3)
        [C, r, beta1, beta2] = SE3R3R3.decompose(element_SE3R3R3);        
        phi = SO3.decompose(C);
        Jinv = SO3.computeJLeftInv(phi);
        % Form the return
        element_se3r3r3 = [ SO3.logMap(C), Jinv * r, zeros(3, 5)   ;
                            zeros(1, 9)                            ;
                            zeros(5, 7), [beta1, beta2; zeros(2)] ];
    end
end

