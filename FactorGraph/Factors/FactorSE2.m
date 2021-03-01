%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SE2 prior factor.
%
%   Amro Al Baali
%   28-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FactorSE2 < BaseFactor & LieGroups
    methods
        function obj = FactorSE2( varargin)
            obj = obj@BaseFactor( varargin{ :});
            
            % Set end node types
            obj.setEndNodeTypes( "NodeSE2");
            obj.type = string( mfilename);
        end
        
        function obj = setEndNode( obj, num, node)
            % Overload the function to check whether the end nodes have the same
            % error definition
            
            % Call the function from the base class
            setEndNode@BaseFactor( obj, num, node);
            
            % Check end node error definition
            if ~ strcmp( obj.error_definition, node.error_definition)
                warning("Error definitions from the node: ('%s' error) " + ...
                    "does not match with the factor error defintion('%s' error)", ...
                    node.error_definition, obj.error_definition);
            end
        end
        
        function obj = setErrorDefinition( obj, err_def)
            % Overload the function from the Lie group class in order to update
            % the nodes' error definitions.
            setErrorDefinition@LieGroups( obj, err_def);
            
            cellfun(@( node) node.setErrorDefinition( err_def), obj.end_nodes);
        end
    end
    
    methods (Access = protected)
        
        function isvalid = isValidCov( ~, mat_in)
            % First check size
            isvalid = all( size( mat_in) == [ 3, 3]);
            % Check if matrix is symmetric
            isvalid = isvalid & norm( mat_in - mat_in') <= 1e-5;
            % Check eigenvalues (this might be an expensive step that I might
            % need to omit)
            isvalid = isvalid & all( eig( mat_in) >= 0);
        end
        
        function isvalid = isValidMeas( ~, meas_in)
            % ISVALIDMEAS( meas_in) checks whether meas_in is an element of SE2
            % (this is expected to be like a prior or a full-state measurement).
            
            isvalid = SE2.isValidElement( meas_in);
        end
        
        function computeError( obj)
            % COMPUTEERROR() computes the error or residual value depending on
            % the choice of the procee model
            
            % First pose
            X = obj.end_nodes{1};
            
            % Compute measurement based on the error definition
            obj.err_val = X - obj.meas;
        end
        
        
        function jacs = getErrJacobiansNodes( obj)
            % Get the errors w.r.t. the variable nodes
            switch obj.error_definition
                case 'left'
                    jacs = { - eye( 3)};
                case 'right'
                    jacs = { -SE2.adjoint( SE2.inverse( obj.value))};
                case 'left-invariant'
                    % Jacobian of Y\inv X \approx -\eye
                    jacs = { - eye( 3)};
                case 'right-invariant'
                    jacs = { - eye( 3)};
            end
        end
        
        function getErrJacobianRVs( obj)
        end
    end
    
    methods (Static = true)        
        function err_val = errorFunction( end_nodes, meas)
            % Static error function
            X = end_nodes{ 1};
            % Compute measurement based on the error definition
%             err_val = X - meas;
            err_val = NodeSE2(X.error_definition, meas) - X.value;
        end
    end
end