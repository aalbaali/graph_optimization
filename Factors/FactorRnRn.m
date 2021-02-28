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
            obj = obj@BaseFactor( varargin{:});
            
            % TEMPORARY!!! I should implement an input parser.
            % Array of end node types
            obj.setEndNodeTypes( [ "NodeR2", "NodeR2"]);
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
    
    methods (Static = false, Access = protected)
        % Compute error
        function computeError( obj)
            %COMPUTEERROR Updates the weighted error value and returns the
            %value.
            
            % Check if poses are valid
            if ~obj.valid_end_nodes( 1) || ~obj.valid_end_nodes( 2)
                error("Invalid end_nodes. May need initialization");
            end
            % First pose
            X1 = obj.end_nodes{1}.value;
            X2 = obj.end_nodes{2}.value;
            
            % Unweighted error
            obj.err_val = X2 - obj.params.A * X1 - obj.params.B * obj.meas;
        end
        
        % A function that computes the error Jacobians w.r.t. states/nodes
        function J_cell = getErrJacobiansNodes( obj)
            %GETERRJACOBIANSNODES gets the Jacobian of the (unweighted) error
            %function w.r.t. nodes. Note that the order matters!
            J_cell = { -obj.params.A, eye( 2)};
        end
        % A function that computes the error Jacobians w.r.t. the random
        % variables
        function L = getErrJacobianRVs( obj)
            L = obj.params.L;
        end
        
        % Measurement validator
        function isvalid = isValidMeas( obj, meas_in)
            % Check if the dimensions make sense
            isvalid = all( size( meas_in) == [ obj.measDim, 1]);
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
    
    properties (Constant = true)
        % Type of this edge
        type = string( mfilename);
    end
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%