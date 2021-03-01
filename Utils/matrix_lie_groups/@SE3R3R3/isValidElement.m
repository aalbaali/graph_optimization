function is_valid_element_SE3R3R3 = isValidElement(input)
%ISVALIDELEMENT Verify input is an element of SE3 x R3 x R3.
%
% PARAMETERS
% ----------
% input : anything
%     The input to check.
%
% RETURNS
% -------
% is_valid_element_SE3R3R3 : logical
%     Whether input is a valid element of SE3 x R3 x R3.
% -------------------------------------------------------------------------    
    is_valid_element_SE3R3R3 = true;
    
    % Test numeric, real, correct size
    if ~MLGUtils.isValidRealMat(input, 9, 9, 'SE3R3R3')
        is_valid_element_SE3R3R3 = false;
    end
    
    % Test that rotation block is an element of SO3
    if ~SO3.isValidElement(input(1:3, 1:3))
        is_valid_element_SE3R3R3 = false;
    end
    
    % Check remaining entries
    if ~isequal(input(1:4, 5:9), zeros(4, 5))
        is_valid_element_SE3R3R3 = false;
    end
    if ~isequal(input(4:9, 1:3), zeros(6, 3))
        is_valid_element_SE3R3R3 = false;
    end
    if ~isequal(input(4:9, 4:7), [eye(4); zeros(2, 4)])
        is_valid_element_SE3R3R3 = false;
    end
    if ~isequal(input(8:9, 8:9), eye(2))
        is_valid_element_SE3R3R3 = false;
    end
end

