function element_se23 = logMap(element_SE23)
%LOGMAP Map element of the matrix Lie group SE23 to associated matrix Lie
%algebra se23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SE23 : [5 x 5] double
%     An element of SE23.
%
% RETURNS
% -------
% element_se23 : [5 x 5] double
%     The corresponding element of se23.
% -------------------------------------------------------------------------
    element_se23 = [];
    if SE23.isValidElement(element_SE23)
        [C, v, r] = SE23.decompose(element_SE23);        
        phi = SO3.decompose(C);
        Jinv = SO3.computeJLeftInv(phi);
        % Form the return
        element_se23 = [SO3.logMap(C), Jinv * v, Jinv * r ;
                       zeros(2, 5)                       ];
    end
end

