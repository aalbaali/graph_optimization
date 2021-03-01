function is_valid_element_se3r3r3 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of se3r3r3.
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_se3r3r3 : logical
%     Whether input is a valid element of se3r3r3.
% -------------------------------------------------------------------------    
    is_valid_element_se3r3r3 = true;
    
    % Test numeric, real, correct size.
    if ~MLGUtils.isValidRealMat(input, 9, 9, 'se3r3r3')
        is_valid_element_se3r3r3 = false;
    end

    % Test rotation block skew symetric.
    rot_block = input(1:3, 1:3);
    if ~MLGUtils.isSkewSymmetric(rot_block)
        is_valid_element_se3r3r3 = false;
    end
    
    % Test diagonal entries of rotation block are zero.
    if ~MLGUtils.isDiagonalZeros(rot_block)
        is_valid_element_se3r3r3 = false;
    end

    % Check remaining entries
    if ~isequal(input(1:4, 5:9), zeros(4, 5))
        is_valid_element_se3r3r3 = false;
    end
    if ~isequal(input(4:9, 1:7), zeros(6, 7))
        is_valid_element_se3r3r3 = false;
    end
    if ~isequal(input(8:9, 8:9), zeros(2))
        is_valid_element_se3r3r3 = false;
    end
end

