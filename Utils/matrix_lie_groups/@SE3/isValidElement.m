function is_valid_element_SE3 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of SE3.
% From Section 7.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_SE3 : logical
%     Whether input is a valid element of SE3.
% -------------------------------------------------------------------------    
    is_valid_element_SE3 = true;
    
    % Test numeric, real, correct size
    if ~MLGUtils.isValidRealMat(input, 4, 4, 'SE3')
        is_valid_element_SE3 = false;
    end
    
    % Test that rotation block is an element of SO3
    if ~SO3.isValidElement(input(1:3, 1:3))
        is_valid_element_SE3 = false;
    end
    
    % Check bottom row
    if ~isequal(input(4, :), [zeros(1, 3), 1])
        is_valid_element_SE3 = false;
    end
end

