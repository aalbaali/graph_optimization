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
        function obj = BaseEdge(obj)
            obj.endNodes = cell(1, obj.numEndNodes);
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
        
        % Getters
        function val = get.meas( obj)
            if isnan( obj.meas)
                warning('Measurement not set');
            end
            val = obj.meas;
        end
        
        function val = get.inf_mat( obj)
            if any( isnan( obj.inf_mat))
                % Compute information matrix
                obj.inf_mat = inv( obj.cov_mat);
            end
            val = obj.inf_mat;
        end
        
        function val = get.sqrt_mat( obj)
            val = obj.sqrt_mat;
        end
        
        % Setters
        % Some of the set.* matrices are accessible only internally (protected).
        % So they can't be accessed publicly.
        function set_inf_mat( obj, inf_mat_in)
            % Takes in the information matrix and updates the other matrices
            obj.inf_mat = inf_mat_in;
            
            % Update covariance matrix
            obj.cov_mat = inv( obj.inf_mat);
            % Update sqrt information matrix
            obj.sqrt_mat = obj.inf_mat_to_sqrt_mat( obj.inf_mat);
            
            obj.m_cov_mat_up_to_date  = true;
            obj.m_inf_mat_up_to_date  = true;
            obj.m_sqrt_mat_up_to_date = true;
        end
        
        function set_cov_mat( obj, cov_mat_in)
            obj.cov_mat = cov_mat_in;
            
            % Update information matrix
            obj.inf_mat = inv( obj.cov_mat);
            % Update sqrt information matrix
            obj.sqrt_mat = obj.inf_mat_to_sqrt_mat( obj.inf_mat);
            
            obj.m_cov_mat_up_to_date  = true;
            obj.m_inf_mat_up_to_date  = true;
            obj.m_sqrt_mat_up_to_date = true;
        end
        
        % RV informrmation matrix setter and getter
        function set.inf_mat( obj, inf_mat_in)
            % The validity of covariance matrix is the same as for the
            % informaiton matrix
            if ~obj.isValidCov( inf_mat_in)
                warning("Invalid information matrix");
            end
            obj.inf_mat = inf_mat_in;
        end
        
        function set.sqrt_mat( obj, sqrt_mat_in)
            if ~obj.isValidCov( sqrt_mat_in' * sqrt_mat_in)
                warning("Invalid sqrt information matrix");
            end
            obj.sqrt_mat = sqrt_mat_in;
        end
        
        % RV covariance matrix setter and getter
        function set.cov_mat( obj, cov_mat_in)
            % Check validity
            if ~obj.isValidCov( cov_mat_in)
                warning("Invalid covariance matrix");                
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
            obj.computeError();
            val = obj.err_val;
        end
        
        % get weighted error (no setter)
        function val = get.werr_val( obj)
            % Update error covariances
            obj.updateErrCov();
            val = obj.err_sqrt_inf_mat * obj.err_val;
        end
        
        % err_cov getter (no setter)
        function val = get.err_cov_mat( obj)
            if any( isnan( obj.cov_mat))
                warning("Meas. covariance matrix not initialized");
            end            
            val = obj.err_cov_mat;
        end
        
        % err_inf getter (no setter)
        function val = get.err_inf_mat( obj)
            if any( isnan( obj.cov_mat))
                warning("Meas. covariance matrix not initialized");
            end
            if ~obj.m_err_inf_mat_up_to_date
                warning("Error information matrix is not up to date");
            end
            val = obj.err_inf_mat;
        end
        
        % Get error sqrt information matrix
        function val = get.err_sqrt_inf_mat( obj)
            if ~obj.m_err_sqrt_mat_up_to_date
                warning("Error sqrt information matrix is not up to date");
            end
            val = obj.err_sqrt_inf_mat;
        end
        % Update covariance, informatin, and square root information matrices
        function updateRvSecondMoments( obj)
            % It is assumed that the covariance matrix is not nan.
            if isnan( obj.cov_mat)
                error("Covariance matrix not specified");
            end
            obj.inf_mat = inv( obj.cov_mat);
            [V, D] = eig( obj.inf_mat);
            obj.sqrt_mat = sqrt( D) * V';            
        end
        
        function set_err_inf_mat( obj, err_inf_mat_in)
            obj.err_inf_mat = err_inf_mat_in;
            obj.err_sqrt_inf_mat = obj.inf_mat_to_sqrt_mat( obj.err_inf_mat);
            
            obj.m_err_inf_mat_up_to_date  = true;
            obj.m_err_sqrt_mat_up_to_date = true;
            obj.m_err_cov_mat_up_to_date  = false;
            
            % The covariance on the random variables is no longer valid in this
            % case
            obj.m_cov_mat_up_to_date = false;
        end
        
        % Update error covariance, information, and sqrt information
        function updateErrCov( obj)
            % The error function is a function of the noise terms. Therefore,
            % the covariance on the error function is propagated using
            % first-order methods or sigma point, or any other method.
            % The user must be careful not to update the error covariance during
            % a batch optimization problem; this would mess up the results.
            if obj.m_cov_mat_up_to_date && ~obj.m_err_inf_mat_up_to_date                
                % For now, let's do a first-order covariance
                %   Get the Jacobian of the error function w.r.t. random variables
                J_rv = obj.getErrJacobianRVs();
                if any( isnan( J_rv))
                    error( "Jacobian of error function w.r.t. random variables contains NaNs");
                end
                obj.err_cov_mat = J_rv * obj.cov_mat * J_rv';
                obj.m_err_cov_mat_up_to_date  = true;
                
                % Compute information matrix
                obj.err_inf_mat = inv( obj.err_cov_mat);
                obj.m_err_inf_mat_up_to_date  = true;
                
                % Compute square root matrix
                %   Get eigendecomposition and then store sqrt( D) * V'            
                obj.err_sqrt_inf_mat = obj.inf_mat_to_sqrt_mat( obj.err_inf_mat);
                obj.m_err_sqrt_mat_up_to_date = true;
            end
        end
        
    end
    
    
    methods (Abstract = true, Static = false, Access = protected)
        % computeError;
        computeError( obj);
        
        % get error jacobians w.r.t. states/nodes
        getErrJacobiansNodes( obj);
        
        % get error jacobians w.r.t. random variables
        getErrJacobianRVs( obj);
        
        % Measurement validator
        bool = isValidMeas( obj, meas);
        
        % RV covariance validator
        isvalid = isValidCov( obj, mat);     
    end
    
    methods (Abstract = false, Static = true)
        % Information matrix to sqrt information matrix
        function sqrt_mat = inf_mat_to_sqrt_mat( inf_mat)
            %   This gives 
            %       sqrt_mat' * sqrt_mat == inf_mat
            [V, D] = eig( inf_mat);
            sqrt_mat = sqrt( D) * V';
        end
    end
    properties (Abstract = true, Constant = true)
        %   The m_* prefix indicates that it's a 'member' variable
        
        % static const string: Edge type (e.g., "EdgeSE2" or "EdgeSE2R2"). I'll
        % use the convention of setting type to the class name
        type;
        
        % static const int: Number of nodes attached to this edge (usually
        % it's either 1 or 2 for SLAM problems)
        numEndNodes;
        
        % static const string array of types of the end nodes. The order
        % matters! It should match the class name (e.g., "EdgeSE2R2" is
        % different from "EdgeR2SE2"). E.g., endNodes = {"NodeSE2", "NodeR2"};
        % The elements can be set using class(NodeR2) or more easily "NodeR2"
        endNodeTypes;
        
        % Dimension of the error function (or degrees of freedom)
        errDim;
        
        % Dimension of the measurement
        measDim;
        
        % Number of random variables (including the measurement if it's counted
        % as a random variable)
        numRVs;
    end
    
    properties (SetAccess = protected)
        
        % Computed error value. This should only be set internally, cannot be
        % modified by user.
        err_val = nan;
                
        % Weighted error
        werr_val = nan;
        
        % Square root information matrix of the ERROR function.
        err_sqrt_inf_mat = nan;
        
        % Covariance matrix of the ERROR function, not the measurements!
        % Covariance is computed (inverse of information matrix) when requested
        % through the getter.
        err_cov_mat = nan;      
        
        % Covariance matrix on the RANDOM VARAIBLES (i.e., the process or
        % measurement noise).
        cov_mat = nan;
        
        % Measurement information matrix on the RANDOM VARAIBLES (i.e., the
        % process or measurement noise).
        inf_mat = nan;
        
        % Square root information matrix on the RANDOM VARAIBLES (i.e., the
        % process or measurement noise).
        sqrt_mat = nan;
                
        % Flags to determine whether variables are set or not
        m_meas_initialized = false;
        m_cov_initialized = false;      
        
        % Matrices that need updating. Whenever one of the matrices isupdated,
        % the others booleans must be turned to off. 
        m_cov_mat_up_to_date    = false;
        m_inf_mat_up_to_date    = false;
        m_sqrt_mat_up_to_date   = false;
        
        % Error matrices that need updating
        m_err_cov_mat_up_to_date    = false;
        m_err_inf_mat_up_to_date    = false;
        m_err_sqrt_mat_up_to_date   = false;
    end
    
    properties      
        % Instances of the end nodes!        
        endNodes = nan;
        
        % Measurements realization (expected value)
        meas = nan;
        
                
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
%       The Nodes are passed by REFERENCE! This would allow for efficiency in
%       implementation but caution must also be exercised.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%