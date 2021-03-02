%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SE2 measurements factor.
%
%   Amro Al Baali
%   28-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FactorSE2Meas < BaseFactor & LieGroups
    methods
        function obj = FactorSE2Meas( varargin)
            % TODO: input parser with optional error_definition
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
            
            % Store the error definition in the parameters as well.
            obj.params.error_definition = err_def;
        end
    end
    
    methods (Static = true)
        function err_val = errorFunction( end_nodes, meas, params)
            % COMPUTEERROR() computes the error or residual value depending on
            % the choice of the procee model
            
            % First pose
            X = end_nodes{1};
            
            % Compute measurement based on the error definition            
            err_val = meas - params.C_left * X.value * params.C_right;
        end
        
        
        function err_jacs = errorJacobiansVars( end_nodes, meas, params)
            
            X = end_nodes{ 1};
            
            % Get the errors w.r.t. the variable nodes
            switch params.error_definition
                case 'left'
                    err_jacs = { - params.C_left * NodeSE2.odot( X.value * ...
                        params.C_right)};
                case 'right'
                    err_jacs = { - params.C_left * X.value * ...
                        NodeSE2.odot( params.C_right)};
                case 'left-invariant'                    
                    err_jacs = { params.C_left * X.value * ...
                            NodeSE2.odot( params.C_right)};
                case 'right-invariant'
                    err_jacs = { params.C_left * NodeSE2.odot( X.value * ...
                        params.C_right)};
            end
        end
        
        function err_jac = errorJacobiansRandomVars( end_nodes, meas, params)
            err_jac = eye(2);
        end
    end
    methods (Access = protected)
        
        function isvalid = isValidCov( ~, mat_in)
            % First check size
            isvalid = all( size( mat_in) == [ 2, 2]);
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
    end
end