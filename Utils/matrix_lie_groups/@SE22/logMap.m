function element_se22 = logMap(element_SE22)
%LOGMAP Map element of the matrix Lie group SE22 to associated matrix Lie
%algebra se22.
%
% PARAMETERS
% ----------
% element_SE22 : [4 x 4] double
%     An element of SE22.
%
% RETURNS
% -------
% element_se22 : [4 x 4] double
%     The corresponding element of se22.
% -------------------------------------------------------------------------
    element_se22 = [];
    if SE22.isValidElement(element_SE22)
        [C, v, r] = SE22.decompose(element_SE22);        
        theta = SO2.decompose(C);
        Jinv = SO2.computeJLeftInv(theta);
        % Form the return
        element_se22 = [SO2.logMap(C), Jinv * v, Jinv * r ;
                       zeros(2, 4)                       ];
    end
end

