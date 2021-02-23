%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a base node template class.
%
%   Amro Al Baali
%   23-Feb-2021
%
%   --------------------------------------------------------------------------
%   Change log
%   --------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) BaseNode
    %BASENODE Necessary functions and variables to implement a node class
    
    methods (Abstract = true)
        % Public func: Value setter.
        void = setValue(obj, value_in);
        
        % Public func: value getter
        value_out = getValue(obj);
    end
    
    methods (Abstract = true, Static = true)
        % Static methods can be accessed without instantiating an object. These
        % can be used to access the node type and degrees of freedom (properties
        % that are not specific to any implementation)
        
        % Incrementing the values of the nodes. It updates the internal value by
        % doing value = oplus( value, xi). E.g., for a LI-SE2: oplus(X, xi) = X
        % * se2alg.expMap( - xi). Note that this is a Static function and can be
        % used outside the class.
        value = oplus(value, xi)
        
        % Verify element is of appropriate type/size/shape
        bool = isValidValue( value);
        
        % Verify that the increment is of a valid type/size/shape. This is
        % applicable when using oplus operator. The increment could be an
        % element of the Lie algebra for example.
        bool = isValidIncrement( increment);
    end
    
    properties (Abstract = true, Constant = true)
        %   The m_* prefix indicates that it's a 'member' variable
        
        % static const string: Node type (e.g., "NodeSE2"). I'll use the
        % convention of setting m_type to the class name
        type;
        
        % static const int: Dimention or degrees of freedom (dof) of the variable
        % (e.g., for SE(2), it's 3)
        dim;
    end
    
    properties (Abstract = true, Constant = false, SetAccess = protected, ...
            GetAccess = protected)
        % NodeType: This is where the variable is stored (e.g., X_k pose). This
        % will depend on the type of variable stored.
        m_value;
    end
    
end