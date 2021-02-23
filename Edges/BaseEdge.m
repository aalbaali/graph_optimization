%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a base edge abstract class.
%
%   Amro Al Baali
%   23-Feb-2021
%
%   --------------------------------------------------------------------------
%   Change log
%   --------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) BaseEdge < handle
    %BASENODE Necessary functions and variables to implement a node class
    
    methods 
        % Constructor
        function obj = BaseEdge()
        end
        
        % # measurement setter and getter
        % Measurement setter
        function set.meas( obj, meas_in)
            % Check if measurement is valid
            if ~obj.isValidMeas( meas_in)
                error("Invalid measurement");
            end
            % Store measurement
            obj.meas = meas_in;
            
            % Value to output
            obj.meas;
        end
        
        % Measurement getter
        function val = get.meas( obj)
            if isnan( obj.meas)
                warning('Measurement not set');
            end
            val = obj.meas;
        end
        
        % RV informrmation matrix setter and getter
        function set.inf_mat( obj, inf_mat_in)
            % The validity of covariance matrix is the same as for the
            % informaiton matrix
            if ~obj.isValidCov( inf_mat_in)
                error("Invalid information matrix");
            end
            obj.inf_mat = inf_mat_in;
        end
        function val = get.inf_mat( obj)
            if any( isnan( obj.inf_mat))
               warning("Meas. information matrix not initialized");
            end
            val = obj.inf_mat;
        end
        
        % RV covariance matrix setter and getter
        function set.cov_mat( obj, cov_mat_in)
            % Check validity
            if ~obj.isValidCov( cov_mat_in)
                error("Invalid covariance matrix");
            end
            obj.cov_mat = cov_mat_in;
        end
        function val = get.cov_mat( obj)
            if any( isnan( obj.cov_mat))
                warning("Meas. covariance matrix not initialized");
            end
            val = obj.cov_mat;
        end
        
        % error getter (no setter)
        function val = get.err_val( obj)
            val = obj.computeError();
        end
        
        % err_cov getter (no setter)
        function val = get.err_cov_mat( obj)
            if any( isnan( obj.cov_mat))
                warning("Meas. covariance matrix not initialized");
            end            
            val = obj.err_cov;
        end
        
        % err_inf getter (no setter)
        function val = get.err_inf_mat( obj)
            if any( isnan( obj.cov_mat))
                warning("Meas. covariance matrix not initialized");
            end
            val = obj.err_inf_mat;
        end
        
        % Update error covariance, information, and sqrt information
        function updateErrCov( obj)
            % The error function is a function of the noise terms. Therefore,
            % the covariance on the error function is propagated using
            % first-order methods or sigma point, or any other method.
            % The user must be careful not to update the error covariance during
            % a batch optimization problem; this would mess up the results.
            
            % For now, let's do a first-order covariance
            %   Get the Jacobian of the error function w.r.t. random variables
            J_rv = obj.getErrorJacobianRVs();
            err_cov_mat = J_rv * obj.cov_mat * J_rv';
            
            % Compute information matrix
            err_inf_mat = inv( err_cov_mat);
            
            % Compute square root matrix
            %   Get eigendecomposition and then store sqrt( D) * V'
            [V, D] = eig( err_inf_mat);
            err_sqrt_inf_mat = sqrt( D) * V';
            
            % Store matrices
            obj.err_cov_mat      = err_cov_mat;
            obj.err_inf_mat      = err_inf_mat;
            obj.err_sqrt_inf_mat = err_sqrt_inf_mat;
        end
        
    end
    
    methods (Abstract = true, Static = true)
        % Measurement validator
        bool = isValidMeas( meas);
        
        % RV covariance validator
        isvalid = isValidCov( mat);            
    end
    
    methods (Abstract = true, Static = false, Access = protected)
        % computeError;
        computeError( obj);
        
        % get error jacobians w.r.t. states/nodes
        getErrJacobiansNodes( obj);
        
        % get error jacobians w.r.t. random variables
        getErrorJacobianRVs( obj);
    end
    
    properties (Abstract = true, Constant = true)
        %   The m_* prefix indicates that it's a 'member' variable
        
        % static const string: Edge type (e.g., "EdgeSE2" or "EdgeSE2R2"). I'll
        % use the convention of setting type to the class name
        type;
        
        % static const int: Number of nodes attached to this edge (usually
        % it's either 1 or 2 for SLAM problems)
        numEndNodes;
        
        % static const string cell array of types of the end nodes. The order
        % matters! It should match the class name (e.g., "EdgeSE2R2" is
        % different from "EdgeR2SE2"). E.g., endNodes = {"NodeSE2", "NodeR2"};
        % The elements can be set using class(NodeR2) or more easily "NodeR2"
        endNodes;
        
        % Dimension of the error function (or degrees of freedom)
        errDim;
    end
    
    properties (SetAccess = protected)
        
        % Computed error value. This should only be set internally, cannot be
        % modified by user.
        err_val = nan;
                
        % Square root information matrix of the ERROR function.
        err_sqrt_inf_mat = nan;
        
        % Covariance matrix of the ERROR function, not the measurements!
        % Covariance is computed (inverse of information matrix) when requested
        % through the getter.
        err_cov_mat = nan;      
        
        % Flags to determine whether variables are set or not
        m_meas_initialized = false;
        m_cov_initialized = false;        
    end
    
    properties        
        % Measurements realization (expected value)
        meas = nan;
        
        % Covariance matrix on the RANDOM VARAIBLES (i.e., the process or
        % measurement noise).
        cov_mat = nan;
        
        % Measurement information matrix on the RANDOM VARAIBLES (i.e., the
        % process or measurement noise).
        inf_mat = nan;
        
        % Square root information matrix on the RANDOM VARAIBLES (i.e., the
        % process or measurement noise).
        sqrt_mat = nan;
                
        % Information matrix of the ERROR function, not the measurements! The
        % information will be stored in information form. The informaiton matrix
        % can be set externally (for example to zero).
        err_inf_mat = nan;        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%       For inference, we need the covariance/information matrices on the error
%       function. Therefore, we need a transformation from the random variables
%       (e.g., white process or measurement noise) to the error function. This
%       is usually encoded by the Jacobian L or M for process models and
%       measurement functions, respectively.
%
%       Therefore, it'll be a requirement to provide the Jacobian of the ERROR
%       function w.r.t. random variables (i.e., noise).
%       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%