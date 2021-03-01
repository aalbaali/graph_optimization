function element_SO2 = expMap(element_so2)
%EXPMAP Map element of the matrix Lie algebra so2 to associated matrix Lie
%group SO2.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_so2 : [[2 x 2] double] OR scalar
%     An element of so2 or its column parameterization.
%
% RETURNS
% -------
% element_SO2 : [2 x 2] double
%     An element of SO2.
% -------------------------------------------------------------------------
    element_SO2 = [];
    % If input is valid column, then expand.
    if MLGUtils.isValidRealCol(element_so2, 1)
        element_so2 = so2alg.wedge(element_so2);
    end
    % If valid element, then form the Lie group element
    if so2alg.isValidElement(element_so2)
        theta = so2alg.decompose(element_so2);
        element_SO2 = [ cos(theta), -sin(theta)  ; 
                        sin(theta),  cos(theta) ];
    end
end

