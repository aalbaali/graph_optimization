function is_valid_element_se2 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of se2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_se2 : logical
%     Whether input is a valid element of se2.
% -------------------------------------------------------------------------    
    is_valid_element_se2 = true;
    
    % Test numeric, real, correct size.
    if ~MLGUtils.isValidRealMat(input, 3, 3, 'se2')
        is_valid_element_se2 = false;
    end

    % Test rotation block skew symetric.
    rot_block = input(1:2, 1:2);
    if ~MLGUtils.isSkewSymmetric(rot_block)
        is_valid_element_se2 = false;
    end
    
    % Test diagonal entries of rotation block are zero.
    if ~MLGUtils.isDiagonalZeros(rot_block)
        is_valid_element_se2 = false;
    end

    % Test bottom row all zeros.
    if ~isequal(input(3, :), zeros(1, 3))
        is_valid_element_se2 = false;
    end
end
    
