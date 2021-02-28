function computeSearchDirection( obj)
    %COMPUTESEARCHDIRECTION computes a descent search direction. This is the
    %supervising method, the construction of the method does not occur in this
    %method.
    
    % Construct the weighted error function and Jacobians from the factor graph
    obj.computeWerrValueAndJacobian();
    

    % If required, reorder the elementwise variables
    if obj.reorder_element_variables
        idx_cols = colamd( obj.m_werr_Jac);
    else
        idx_cols = 1 : obj.m_num_cols_Jac;
    end
    
    % Build the linear system based on the optimization scheme (we want to solve
    % A*x = b)
    switch lower( obj.optimization_scheme)
        case 'gn'
            A = obj.m_werr_Jac( :, idx_cols);
            b = obj.m_werr_val;            
        case 'lm'
            error("Not implemented yet");
    end
    
    switch lower( obj.linear_solver)
        case 'qr'
            % We want to solve the system J'*J * de = -J' * err.
            % This is solved by using a QR decomposition:
            %   [~, R] = qr( [ J, -err], 0);

            % Get the R matrix from the QR decomposition
            [ ~, R] = qr( [ A, b], 0);

            % Compute the solution to A * x = b
            x = R(:, 1 : end - 1) \ R(:, end);
            
        case 'cholesky'
            [R, s] = chol( A' * A);
            if s ~= 0
                warning('Cholesky factor unstable');
            end
            % Compute the solution to A * x = b
            x = R \ ( R' \ (A' * b));
        otherwise
            error("Invalid linear solver");
    end
    
    % Store search direction
    obj.m_search_direction( idx_cols) = - x;
end