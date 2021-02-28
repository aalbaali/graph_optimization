function solveLinearSystem( obj)
    % CONSTRUCTLINEARSYSTEM() constructs the linear system to be used based on
    % the chosen optimization scheme (GN, LM, etc.)
    
    switch lower( obj.linear_solver)
        case 'qr'
            % We want to solve the system J'*J * de = -J' * err.
            % This is solved by using a QR decomposition:
            %   [~, R] = qr( [ J, -err], 0);
            
            % Get the R matrix from the QR decomposition
            [ ~, R] = qr( [ obj.m_werr_Jac, - obj.m_werr_val], 0);
            
            % Store search direction
            % Solve system
            obj.m_search_direction = R(:, 1 : end - 1) \ R(:, end);
        case 'cholesky'
            error("Not implemented yet");
        otherwise
            error("Invalid linear solver");
    end
end