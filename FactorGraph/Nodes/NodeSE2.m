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
            % First, create the class. Then take the input
            p = inputParser; 
            p.KeepUnmatched = true;
            addOptional( p, 'err_def', defaultErrorDefinition, ...
                @NodeLieGroups.isValidErrorDefinition);
            parse( p, err_def);
    
            obj = obj@NodeLieGroups( 'SE2', 2, 3, p.Results.err_def, varargin{ :});
        end
        
        function isvalid = isValidValue( ~, value_in)
            % Overload the validity method. This is needed only when the node
            % value is initialized in the constructor.
            isvalid = SE2.isValidElement( value_in);
        end
    end
end