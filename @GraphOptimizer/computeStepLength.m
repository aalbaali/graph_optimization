function computeStepLength( obj)
    % COMPUTESTEPLENGTH() returns a step length in the search direction that
    % would reduce the objective value. For now, only the Armijo rule is
    % implemented.
    
    % Make a copy of the factor graph: current iteration
    fg_km1 = copy( obj.factor_graph);
    
    % Keep a copy of the error function, Jacobian, and objective function
    werr_val_km1 = obj.m_werr_val;
    werr_Jac_km1 = obj.m_werr_Jac;    
    wobj_val_km1 = obj.getObjectiveValue();
    % Get search direction at the crurrent iteration
    search_dir_km1 = obj.m_search_direction;
    
    % Compute objective function Jacobian at the current iteration
    wobj_Jac_km1 = werr_val_km1' * werr_Jac_km1;
    
    % Use a Lambda function to test the armijo condition (if it's true, then
    % it's satisfied). 
    armijoSatisfied = @( step_length) obj.getObjectiveValue() <= wobj_val_km1 ...
        + obj.optim_params.sigma * step_length * wobj_Jac_km1 * search_dir_km1;
    
    % Starting step length
    step_length = 1;    
    for lv1 = 1 : obj.optim_params.max_armijo_iterations
        % Check stopping criterion
         if armijoSatisfied( step_length)
             break;
         else
             % Update step length
             step_length = step_length * obj.optim_params.beta;
         end
        % Make sure we're using the SAME factor graph from ( we need the same
        % starting points)
        obj.factor_graph = copy( fg_km1);
        % Increment updates
        obj.updateGraph( step_length * search_dir_km1);
        obj.computeWerrValueAndJacobian();
    end
    if ~armijoSatisfied( step_length)
        warning( 'Armijo maximum iterations %i reached', ...
            obj.optim_params.max_armijo_iterations);
    end
    
    % Store step length
    obj.m_step_length = step_length;
    % Store 
end
