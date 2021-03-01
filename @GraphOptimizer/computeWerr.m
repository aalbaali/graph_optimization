function [ werr_val, wobj_val] = computeWerr( obj)
    % COMPUTEWERR() computes only the weighted error of the factor graph and
    % stores it in the object. It does not compute the Jacobian.
    %
    % [ werr_val] = COMPUTEWERR() computes only the weighted error of the factor
    % graph and stores it in the object and returns the new value [werr_val].
    %
    % [ werr_val, wobj_val] = COMPUTEWERR() computes only the weighted error of
    % the factor graph and stores it in the object and returns the new value
    % werr_val and the objective value wobj_val.
    
    obj.computeWerrValueAndJacobian( 'compute_jac', false);
    
    % Output if necessary
    if nargout >= 1
        werr_val = obj.m_werr_val;
        if nargout == 2
            wobj_val = werr_val' * werr_val;
        end
    end
end