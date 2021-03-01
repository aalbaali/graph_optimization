function is_valid_element_so2 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of so2.
% From Section 4.1 of the DECAR IEKF doc.
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_so2 : logical
%     Whether input is a valid element of so2.
% -------------------------------------------------------------------------    
    is_valid_element_so2 = true;
    
    % Test numeric, real, correct size.
    if ~MLGUtils.isValidRealMat(input, 2, 2, 'so2')
        is_valid_element_so2 = false;
    end
    
    % Test skew symmetric
    if ~MLGUtils.isSkewSymmetric(input, 'so2')
        is_valid_element_so2 = false;
    end
    
    % Test diagonal entries are zero.
    if ~MLGUtils.isDiagonalZeros(input, 'so2')
        is_valid_element_so2 = false;
    end
end

