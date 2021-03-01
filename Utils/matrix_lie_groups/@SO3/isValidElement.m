function is_valid_element_SO3 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of SO3.
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_SO3 : logical
%     Whether input is a valid element of SO3.
% -------------------------------------------------------------------------    
    is_valid_element_SO3 = true;
    
    % Test numeric, real, correct size
    if ~MLGUtils.isValidRealMat(input, 3, 3, 'SO3')
        is_valid_element_SO3 = false;
    end
    
    % Test that the inverse is the transpose
    if ~MLGUtils.isInverseEqualTranspose(input, 'SO3')
        is_valid_element_SO3 = false;
    end
    
    % Test that the determinant is +1
    if ~MLGUtils.isDeterminantOne(input, 'SO3')
        is_valid_element_SO3 = false;
    end
end

