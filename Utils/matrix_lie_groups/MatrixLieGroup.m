classdef (Abstract) MatrixLieGroup
    %MATRIXLIEGROUP Necessary functions for creating a new matrix Lie
    %group.
    
    % All matrix Lie groups must implement these methods
    methods (Abstract = true, Static = true)
        
        % Adjoint representation of a group element
        adj_element = adjoint(lie_group_element);
        
        % Decompose Lie group element into constituent parts
        varargout = decompose(lie_group_element);
        
        % Inverse
        inv_lie_group_element = inverse(lie_group_element);
        
        % Check if input is a valid element of a group
        is_vaid_element = isValidElement(input);
        
        % Map up to the matrix Lie algebra
        lie_algebra_element = logMap(lie_group_element);
        
        % Many ways to form an element of a matrix Lie group
        lie_group_element = synthesize(varargin);
        
    end
    
end

