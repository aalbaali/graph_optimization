function is_valid_element_se23 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of se23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_se23 : logical
%     Whether input is a valid element of se23.
% -------------------------------------------------------------------------    
    is_valid_element_se23 = true;
    
    % Test numeric, real, correct size.
    if ~MLGUtils.isValidRealMat(input, 5, 5, 'se23')
        is_valid_element_se23 = false;
    end

    % Test rotation block skew symetric.
    rot_block = input(1:3, 1:3);
    if ~MLGUtils.isSkewSymmetric(rot_block)
        is_valid_element_se23 = false;
    end
    
    % Test diagonal entries of rotation block are zero.
    if ~MLGUtils.isDiagonalZeros(rot_block)
        is_valid_element_se23 = false;
    end

    % Test two bottom rows all zeros.
    if ~isequal(input(4:5, :), zeros(2, 5))
        is_valid_element_se23 = false;
    end
end

