%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Edge between two R^n elements. This could for a linear process model.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FactorRn < BaseFactor
    %FACTORR2 Implementation of BaseEdge to a single R^2 element
    
    methods
        % Constructor
        function obj = FactorRn( varargin)
            obj = obj@BaseFactor( varargin{:});            
            
            % Array of end node types
            obj.setEndNodeTypes( [ "NodeRn"]);
            
            obj.type = string( mfilename);
        end
        
        function setParam( obj, field_in, param_in)
            % Overload to function to make it specific to this node
            
            % Update field
            obj.params.(field_in) = param_in;
            
            % Specific instructions to certain fields
            switch field_in
                case 'C'                                
                    % Update error dimension
                    obj.setErrDim( size( param_in, 1));
                    obj.setMeasDim( size( param_in, 1));
                    
                case 'L'
                    obj.setNumRvs( size( param_in, 2));
            end
        end
    end
    
    methods (Static = false, Access = protected)
        % Compute error
        function computeError( obj)
            %COMPUTEERROR Updates the weighted error value and returns the
            %value.
            
            % Check if poses are valid
            if ~obj.valid_end_nodes( 1)
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
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%   ----------------------------------------------------------------------------
%   Change log
%       28-Feb-2021 changed the following variable names
%           measDim             ->      meas_dim
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%