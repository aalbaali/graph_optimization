classdef SE2 < MatrixLieGroup & SO2 & MLGUtils
    %SE2 Implements functions for matrix Lie group SE2.
    
    methods (Static = true)
        
        % Adjoint operator
        adj_element = adjoint(lie_group_element);
        
        % Decomposition
        varargout = decompose(lie_group_element);
        
        % Inverse
        lie_group_element_inv = inverse(lie_group_element);
        
        % Group Jacobians and their inverses
        J_left  = computeJLeft(xi);
        J_right = computeJRight(xi);
        J_left_inv  = computeJLeftInv(xi);
        J_right_inv = computeJRightInv(xi)
        
        % Check if input is a valid element of the group
        is_valid_element = isValidElement(input);
        
        % Map up to the matrix Lie algebra
        lie_algebra_element = logMap(lie_group_element);
        
        % Many ways to make an element of a matrix Lie group
        lie_group_element = synthesize(varargin);
        
    end
    
end

