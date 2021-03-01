function is_valid_element_SO2 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of SO2.
% From Section 4.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_SO2 : logical
%     Whether input is a valid element of SO2.
% -------------------------------------------------------------------------    
    is_valid_element_SO2 = true;
    
    % Test numeric, real, correct size
    if ~MLGUtils.isValidRealMat(input, 2, 2, 'SO2')
        is_valid_element_SO2 = false;
    end
    
    % Test that the inverse is the transpose
    if ~MLGUtils.isInverseEqualTranspose(input, 'SO2')
        is_valid_element_SO2 = false;
    end
    
    % Test that the determinant is +1
    if ~MLGUtils.isDeterminantOne(input, 'SO2')
        is_valid_element_SO2 = false;
    end
end

