function is_valid_element_SE22 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of SE22.
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_SE22 : logical
%     Whether input is a valid element of SE22.
% -------------------------------------------------------------------------    
    is_valid_element_SE22 = true;
    
    % Test numeric, real, correct size
    if ~MLGUtils.isValidRealMat(input, 4, 4, 'SE22')
        is_valid_element_SE22 = false;
    end
    
    % Test that rotation block is an element of SO2
    if ~SO2.isValidElement(input(1:2, 1:2))
        is_valid_element_SE22 = false;
    end
    
    % Check two bottom rows
    if ~isequal(input(3:4, :), [zeros(2), eye(2)])
        is_valid_element_SE22 = false;
    end
end

