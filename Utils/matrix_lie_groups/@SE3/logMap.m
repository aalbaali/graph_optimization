function element_se3 = logMap(element_SE3)
%LOGMAP Map element of the matrix Lie group SE3 to associated matrix Lie
%algebra se3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE3 : [4 x 4] double
%     An element of SE3.
%
% RETURNS
% -------
% element_se3 : [4 x 4] double
%     The corresponding element of se3.
% -------------------------------------------------------------------------
    element_se3 = [];   
    if SE3.isValidElement(element_SE3)
        [C, r] = SE3.decompose(element_SE3);        
        phi = SO3.decompose(C);
        Jinv = SO3.computeJLeftInv(phi);
        % Form the return
        element_se3 = [SO3.logMap(C), Jinv * r;
                       zeros(1, 4)           ];
    end
end

