function is_valid_element_se22 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of se22.
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_se22 : logical
%     Whether input is a valid element of se22.
% -------------------------------------------------------------------------    
    is_valid_element_se22 = true;
    
    % Test numeric, real, correct size.
    if ~MLGUtils.isValidRealMat(input, 4, 4, 'se22')
        is_valid_element_se22 = false;
    end

    % Test rotation block skew symetric.
    rot_block = input(1:2, 1:2);
    if ~MLGUtils.isSkewSymmetric(rot_block)
        is_valid_element_se22 = false;
    end
    
    % Test diagonal entries of rotation block are zero.
    if ~MLGUtils.isDiagonalZeros(rot_block)
        is_valid_element_se22 = false;
    end

    % Test two bottom rows all zeros.
    if ~isequal(input(3:4, :), zeros(2, 4))
        is_valid_element_se22 = false;
    end
end

