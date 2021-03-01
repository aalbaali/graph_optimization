%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Edge between two R^n elements. This could for a linear process model.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FactorRnRn < BaseFactor
    %FACTORR2R2 Implementation of BaseEdge between two R^2 elements
    
    methods
        % Constructor
        function obj = FactorRnRn( varargin)
            % FACTORRNRN( dim) sets the error dimension/dof of the factor.
            obj = obj@BaseFactor( varargin{:});
            
            % Array of end node types
            obj.setEndNodeTypes( [ "NodeRn", "NodeRn"]);       
            
            obj.type = string( mfilename);
        end
        
        function setParam( obj, field_in, param_in)
            obj.params.(field_in) = param_in;
            
            switch field_in
                case 'A'
                    % Dimension of error function
                    obj.setErrDim( size( obj.params.A, 1));
                    
                case 'B'
                    % Dimension of the measurement (in this class, it could be 1
                    % or 2. I chose to make it 2 to try it out).
                    obj.setMeasDim( size( obj.params.B, 2));
                    
                case 'L'
                    % Number of random variables. 1. noise on the interoceptive
                    % measurement u, and 2 on process noise w_1 and w_2.
                    obj.setNumRvs( size( obj.params.L, 2));
            end
        end        
    end
    
    methods( Static = true)
        function err_val = errorFunction( end_nodes, meas, params)
            % ERRORFUNCTION computes and returns the error value. It does NOT
            % store it in the object. computeError on the other hand calls this
            % method and stores the error_value in the object.
            %            
            %   This method does not validate the measurements or end_nodes
            
             % First pose
            X1 = end_nodes{1}.value;
            X2 = end_nodes{2}.value;
            
            % Unweighted error
            err_val = X2 - params.A * X1 - params.B * meas;
        end
        
        % A function that computes the error Jacobians w.r.t. states/nodes
        function err_jacs = errorJacobiansVars( ~, ~, params)
            %GETERRJACOBIANSNODES gets the Jacobian of the (unweighted) error
            %function w.r.t. nodes. Note that the order matters!
            err_jacs = { -params.A, eye( 2)};
        end
        % A function that computes the error Jacobians w.r.t. the random
        % variables
        function L = errorJacobiansRandomVars( ~, ~, params)
            L = params.L;
        end
    end
    methods (Static = false, Access = protected)
        % Measurement validator
        function isvalid = isValidMeas( obj, meas_in)
            % Check if the dimensions make sense
            isvalid = all( size( meas_in) == [ obj.meas_dim, 1]);
            isvalid = isvalid && all( ~isinf( meas_in));
            isvalid = isvalid && all( ~isnan( meas_in));
        end
        
        % Random varaibles covariance validator
        function isvalid = isValidCov( ~, mat_in)
            % First check size
            isvalid = true;
            % Check if matrix is symmetric
            isvalid = isvalid & norm( mat_in - mat_in') <= 1e-5;
            % Check eigenvalues (this might be an expensive step that I might
            % need to omit)
            isvalid = isvalid & all( eig( mat_in) >= 0);
        end
    end
    
%     properties (SetAccess = protected)
%         % Type of this edge
%         type;
%     end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%   ----------------------------------------------------------------------------
%   Change log
%       24-Feb-2021
%           Changed the class name from EdgeR2R2 to FactorR2R2.
%   
%           The reason for this change is that Factors should be treated as
%           nodes, not as edges. 
%
%       28-Feb-2021 changed the following variable names
%           measDim             ->      meas_dim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%