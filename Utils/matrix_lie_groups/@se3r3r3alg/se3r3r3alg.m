classdef se3r3r3alg < MatrixLieAlgebra & se3alg & MLGUtils
    %SE3R3R3ALG The matrix Lie algebra for SE3 x R3 x R3.
    
    methods (Static = true)
        
        % Adjoint operator
        adj_element = adjoint(lie_algebra_element);
        
        % Decompose
        varargout = decompose(lie_algebra_element);
        
        % Map down to the corresponding matrix Lie group
        lie_group_element = expMap(lie_algebra_element);
        
        % Check if input is a valid element of the algebra
        is_valid_element = isValidElement(input);
        
        % Construct an element of the Lie algebra from a column matrix
        lie_algebra_element = synthesize(column_matrix);

        % Vee (columnizing) operator
        column_matrix = vee(lie_algebra_element);
        
        % Wedge (expansion) operator
        lie_algebra_element = wedge(column_matrix);
        
    end

end

