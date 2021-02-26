function descend( obj)
    % This is a private method.
    %
    % DESCEND() updates the variable nodes in the factor graph to a new
    % iteration that has a lower objective function (weighted least squares).
    
    % Compute search direction
    obj.computeSearchDirection();
    
    % TODO: Check if it's indeed a descent direction
    
    % Compute step length
    obj.computeStepLength();
    
    % Update graph
    obj.updateGraph();
    
    % TODO: Check if objective function decreased and update the array of
    % objective function values.
end