function element_so2 = logMap(element_SO2)
%LOGMAP Map element of the matrix Lie group SO2 to associated matrix Lie
%algebra so2.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_SO2 : [2 x 2] double
%     An element of SO2.
%
% RETURNS
% -------
% element_so2 : [2 x 2] double
%     The corresponding element of so2.
% -------------------------------------------------------------------------
    element_so2 = [];
    if SO2.isValidElement(element_SO2)
        theta = SO2.decompose(element_SO2);
        element_so2 = [ 0, -theta ; 
                        theta, 0 ];
    end
end

