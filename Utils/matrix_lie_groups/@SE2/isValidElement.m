function is_valid_element_SE2 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of SE2.
% From Section 6.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_SE2 : logical
%     Whether input is a valid element of SE2.
% -------------------------------------------------------------------------    
    is_valid_element_SE2 = true;
    
    % Test numeric, real, correct size
    if ~MLGUtils.isValidRealMat(input, 3, 3, 'SE2')
        is_valid_element_SE2 = false;
    end
    
    % Test that rotation block is an element of SO2
    if ~SO2.isValidElement(input(1:2, 1:2))
        is_valid_element_SE2 = false;
    end
    
    % Check bottom row
    if ~isequal(input(3, :), [0, 0, 1])
        is_valid_element_SE2 = false;
    end
end

