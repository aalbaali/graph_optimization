%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   An implmenetation of the NodeLieGroups class on SE2. Includes additional
%   methods.
%
%   Amro Al Baali
%   28-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef NodeSE2 < NodeLieGroups
    methods
        function obj = NodeSE2( err_def, varargin)
            % NODESE2() creates a new SE2 node with a left-invariant definition.
            %
            % NODESE2( err_def) creates a new SE2 node and sets the error
            % definition to err_def.
            
            % Set default error definition to 'left-invariant'
            defaultErrorDefinition = 'left-invariant';
            if ~exist('err_def', 'var')
                err_def = defaultErrorDefinition;
            end
            % First, create the class. Then take the input
            p = inputParser; 
            p.KeepUnmatched = true;
            addOptional( p, 'err_def', defaultErrorDefinition, ...
                @NodeLieGroups.isValidErrorDefinition);
            parse( p, err_def);
    
            obj = obj@NodeLieGroups( 2, 3, p.Results.err_def, varargin{ :});
            
            obj.type = string( mfilename);
        end
        
        function isvalid = isValidValue( ~, value_in)
            % Overload the validity method. This is needed only when the node
            % value is initialized in the constructor.
            isvalid = SE2.isValidElement( value_in);
        end
    end
    
    methods (Static = true)        
        function out = odot( b)
            % ODOT( b) computes the matrix b\odot such that \xi^\wedge b ==
            % b\odot\xi where \xi is a tangent vector (twist)
            out = [so2alg.wedge(1) * b(1:2), b(3)*eye(2);zeros(1,3)];
        end
    end
    
    properties (Constant = true)
        % Static Lie group class (e.g., SE2)
        lie_group_class = SE2;
        
        % Static Lie algebra class (e.g., se2alg)
        lie_algebra_class = se2alg;
    end
end