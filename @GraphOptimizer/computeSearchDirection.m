function computeSearchDirection( obj)
    %COMPUTESEARCHDIRECTION computes a descent search direction. This is the
    %supervising method, the construction of the method does not occur in this
    %method.
    
    % Construct the weighted error function and Jacobians from the factor graph
    obj.computeWerrValueAndJacobian();
    
%     % Construct the linear system (depends on the choice of the optimization
%     % scheme such as GN, LM, etc.)
%     obj.constructLinearSystem();
%    
%     constructLinearSystem
    % Solve the linear system (depends on the choice of the linear system
    % solver such as QR, Cholesky, etc.)
    obj.solveLinearSystem();
end