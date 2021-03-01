function is_valid_element_se3 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of se3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_se3 : logical
%     Whether input is a valid element of se3.
% -------------------------------------------------------------------------    
    is_valid_element_se3 = true;
    
    % Test numeric, real, correct size.
    if ~MLGUtils.isValidRealMat(input, 4, 4, 'se3')
        is_valid_element_se3 = false;
    end

    % Test rotation block skew symetric.
    rot_block = input(1:3, 1:3);
    if ~MLGUtils.isSkewSymmetric(rot_block)
        is_valid_element_se3 = false;
    end
    
    % Test diagonal entries of rotation block are zero.
    if ~MLGUtils.isDiagonalZeros(rot_block)
        is_valid_element_se3 = false;
    end

    % Test bottom row all zeros.
    if ~isequal(input(4, :), zeros(1, 4))
        is_valid_element_se3 = false;
    end
end

