%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Edge between two R^2 elements. This could for a linear process model.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FactorR2 < BaseFactor
    %FACTORR2 Implementation of BaseEdge to a single R^2 element
    
    methods
        % Constructor
        function obj = FactorR2( varargin)
            obj = obj@BaseFactor( varargin{:});            
            
            % TEMPORARY!!!
            % Number of end nodes: it's a binary edge.
            obj.numEndNodes = 1;

            % Array of end node types
            obj.endNodeTypes = [ "NodeR2"];

            % Dimension of error function
            obj.errDim = 2;

            % Dimension of the measurement (in this class, it could be 1 or 2. I
            % chose to make it 2 to try it out).
            obj.measDim = 2;

            % Number of random variables. 1. noise on the interoceptive measurement
            % u, and 2 on process noise w_1 and w_2.
            obj.numRVs = 2;
            
            if isempty(fields(obj.params))
                obj.params = struct( 'L', eye( obj.numRVs), 'C', ...
                eye( obj.measDim));
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
            X = obj.end_nodes{1}.value;            
            
            % Unweighted error
            obj.err_val = obj.meas - obj.params.C * X;
        end
        
        % A function that computes the error Jacobians w.r.t. states/nodes
        function J_cell = getErrJacobiansNodes( obj)
            %GETERRJACOBIANSNODES gets the Jacobian of the (unweighted) error
            %function w.r.t. nodes. Note that the order matters!
            J_cell = { - obj.params.C};
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%