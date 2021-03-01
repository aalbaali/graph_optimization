function element_se2 = logMap(element_SE2)
%LOGMAP Map element of the matrix Lie group SE2 to associated matrix Lie
%algebra se2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE2 : [3 x 3] double
%     An element of SE2.
%
% RETURNS
% -------
% element_se2 : [3 x 3] double
%     The corresponding element of se2.
% -------------------------------------------------------------------------
    element_se2 = [];   
    if SE2.isValidElement(element_SE2)
        [C, r] = SE2.decompose(element_SE2);        
        theta = SO2.decompose(C);
        Jinv = SO2.computeJLeftInv(theta);
        % Form the return
        element_se2 = [SO2.logMap(C), Jinv * r;
                       zeros(1, 3)           ];
    end
end

