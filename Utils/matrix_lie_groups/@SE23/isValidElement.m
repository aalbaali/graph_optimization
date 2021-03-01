function is_valid_element_SE23 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of SE23.
% From Section 8.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_SE23 : logical
%     Whether input is a valid element of SE23.
% -------------------------------------------------------------------------    
    is_valid_element_SE23 = true;
    
    % Test numeric, real, correct size
    if ~MLGUtils.isValidRealMat(input, 5, 5, 'SE23')
        is_valid_element_SE23 = false;
    end
    
    % Test that rotation block is an element of SO3
    if ~SO3.isValidElement(input(1:3, 1:3))
        is_valid_element_SE23 = false;
    end
    
    % Check two bottom rows
    if ~isequal(input(4:5, :), [zeros(2, 3), eye(2)])
        is_valid_element_SE23 = false;
    end
end

