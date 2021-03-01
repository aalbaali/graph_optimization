function is_valid_element_so3 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of so3.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_so3 : logical
%     Whether input is a valid element of so3.
% -------------------------------------------------------------------------    
    is_valid_element_so3 = true;
    
    % Test numeric, real, correct size.
    if ~MLGUtils.isValidRealMat(input, 3, 3, 'so3')
        is_valid_element_so3 = false;
    end

    % Test skew symetric
    if ~MLGUtils.isSkewSymmetric(input, 'so3')
        is_valid_element_so3 = false;
    end
    
    % Test diagonal entries are zero.
    if ~MLGUtils.isDiagonalZeros(input, 'so3')
        is_valid_element_so3 = false;
    end
end

