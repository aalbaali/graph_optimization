%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   An implementation of the BaseNode class. 
%
%   This is a n-D linear node. This should be generalized into multidimensional
%   linear class (perhaps add another Abstract class that inhertics from
%   BaseNode).
%   
%   Amro Al Baali
%   28-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef NodeRn < BaseNode
    %NODER2 Implementation of BaseNode on elements of R^n space.    
    methods (Access = public)
        % Constructor
        function obj = NodeRn( dim, varargin) 
            %  NODERN( dim) constructs a variable node with dimension dim (for
            %  variables in the linear space, dim == dof)
            
            p = inputParser;
            addRequired( p, 'dim', @( dim) isscalar( dim) && isreal( dim) ...
                && dim >= 1);
            parse( p , dim);          
            dim = p.Results.dim;
            
            % Call superclass constructor
            obj = obj@BaseNode(varargin{ : }, 'dim', dim, 'dof', dim);
        end
    end
    
    methods (Static = false)
        % Static methods can be accessed without instantiating an object. These
        % can be used to access the node type and degrees of freedom (properties
        % that are not specific to any implementation)
        
        
        % Increment value
        function value_out = oplus(~, value_in, xi)
            % Linear case
            value_out = value_in + xi;
        end
        
        % Check validity of the element
        function isvalid = isValidValue(obj, value_in)
            % Value should be a [2x1] column matrix
            isvalid = all( size( value_in) == [ obj.dim, 1]);
                        
            isvalid = isvalid && all( ~isinf( value_in));
            isvalid = isvalid && all( ~isnan( value_in));
        end
        
        % Check validity of the increment
        function isvalid = isValidIncrement(obj, increment)
            % This is the same as valid element
            isvalid = obj.isValidValue( increment);
            
            isvalid = isvalid && all( ~isinf( increment));
            isvalid = isvalid && all( ~isnan( increment));
        end
    end
    
    properties (SetAccess = protected)
        % Type of this node should match that class name
        type;
        
        % Dimension of this node
        dim;
        
        % Degrees of freedom of this node
        dof;
    end          
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%
%   --------------------------------------------------------------------------
%   Change log
%   --------------------------------------------------------------------------