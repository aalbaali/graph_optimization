classdef (Abstract) MatrixLieAlgebra
    %MATRIXLIEALGEBRA Necessary functions for creating a new matrix Lie
    %algebra.
    
    % All Lie algebras must implement these methods
    methods (Abstract = true, Static = true)
           
        % Adjoint representation of an algebra element
        adj_element = adjoint(lie_algebra_element);
        
        % Decompose Lie algebra element into constituent parts
        varargout = decompose(lie_algebra_element);
        
        % Map down to the corresponding matrix Lie group
        lie_group_element = expMap(lie_algebra_element);
        
        % Check if input is a valid element of an algebra
        is_vaid_element = isValidElement(input);
        
        % Construct an element of the Lie algebra from a column matrix
        lie_algebra_element = synthesize(column_matrix);
        
         % Vee (columnizing) operator
        column_matrix = vee(lie_algebra_element);
        
        % Wedge (expansion) operator
        lie_algebra_element = wedge(column_matrix);
        
    end
    
end

