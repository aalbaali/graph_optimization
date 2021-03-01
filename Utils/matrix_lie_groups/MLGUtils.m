classdef (Abstract) MLGUtils
    %MLGUTILS Utility functions for verifying properties of Lie group and
    %Lie Algebra elements.
    
    properties (Constant = true, Access = public)
        % Tolerance to compute J, J^{-1}, and expMap for SO3 using Taylor
        % series expansion
        tol_small_angle = 1e-6;
    end
    
    
    properties (Constant = true, Access = private)
        % Tolerance on checking if inverse is transpose
        tol_check_inverse_transpose = 1e-9;
        % Tolerance on checking determinants
        tol_check_determinant = 1e-9;
        % Tolerance on checking if element is skew symmetric
        tol_check_skew_symmetric = 1e-9;
        % Tolerance on checking diagonals all zero
        tol_check_diagonals = 1e-9;
    end
    
    
    methods (Static = true)
        
        % Verify that the inverse is equal to the transpose.
        function is_inverse_transpose = isInverseEqualTranspose(input, group)
           if abs(norm(input.' * input - eye(length(input)), 'fro')) > ...
                   MLGUtils.tol_check_inverse_transpose
               error('isInverseEqualTranspose:notOrthogonal', ...
               ['Element of ' group ' must have the property: (X)^{-1} = X^T.'])
           end
           is_inverse_transpose = true;
        end
        
        % Verify that determinant is equal to +1.
        function determinant_equals_one = isDeterminantOne(input, group)
            if abs(det(input) - 1) > MLGUtils.tol_check_determinant
                error('isDeterminantOne:notOne', ...
                    ['Error constructing element of ' group '.  ' ...
                    'Determinant is not equal to +1.'])
            end
            determinant_equals_one = true;
        end
        
        % Check that matrix is skew-symetric.
        function is_skew_symmetric = isSkewSymmetric(input, group)
            for lv1 = 1 : length(input)
                for lv2 = lv1 + 1 : length(input)
                    if abs(input(lv1, lv2) + input(lv2, lv1)) > ...
                            MLGUtils.tol_check_skew_symmetric
                        error('isSkewSymmetric:notSkewSymmetric', ...
                            ['Element of ' group ' is not skew-symmetric.'])
                    end
                end
            end
            is_skew_symmetric = true;
        end
        
        % Check that diagonal is all zeros.
        function is_diagonal_zeros = isDiagonalZeros(input, group)
            if any(diag(input) > MLGUtils.tol_check_diagonals)
                error('isDiagonalZeros:notDiagonalZeros', ...
                    ['Element of ' group ' does not have zeros on the diagonal.'])
            end
            is_diagonal_zeros = true;
        end
        
        % Check input matrix is real numeric type, and of a given dimension
        function valid_real_mat = isValidRealMat(input, dim_1, dim_2, obj_type)
            % Check if input is a valid matrix of given dimension.
            if ~isnumeric(input)
                error('isValidRealMat:notNumeric', ...
                    ['Input for construction of ' obj_type ' must be numeric.'])
            end
            if ~isreal(input)
                error('isValidRealMat:notReal', ...
                    ['Input for construction of ' obj_type ' must be real-valued.'])
            end
            is_correct_size = all(size(input) == [dim_1, dim_2]);
            if ~is_correct_size
                error('isValidRealMat:notCorrectSize', ...
                    ['Input for construction of ' obj_type ' must be of size [' ...
                    num2str(dim_1) ' x ' num2str(dim_2) '].'])
            end
            valid_real_mat = true;
        end
        
        % Check input column is real numeric type, and of a given length
        function valid_real_col = isValidRealCol(input, col_length)
            % Check if input is a valid column matrix of given dimension.
            is_real_numeric = isreal(input) && isnumeric(input);
            is_correct_length = all(size(input) == [col_length, 1]);
            if is_real_numeric && is_correct_length
                valid_real_col = true;
            else
                valid_real_col = false;
            end
        end
        
    end
    
end

