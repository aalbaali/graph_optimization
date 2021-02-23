%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a base edge abstract class.
%
%   Amro Al Baali
%   23-Feb-2021
%
%   --------------------------------------------------------------------------
%   Change log
%   --------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) BaseEdge
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
        
        % static const string: Edge type (e.g., "EdgeSE2" or "EdgeSE2R2"). I'll
        % use the convention of setting type to the class name
        type;
        
        % static const int: Number of nodes attached to this edge (usually
        % it's either 1 or 2 for SLAM problems)
        numEndNodes;
        
        % static const string cell array of types of the end nodes. The order
        % matters! It should match the class name (e.g., "EdgeSE2R2" is
        % different from "EdgeR2SE2"). E.g., endNodes = {"NodeSE2", "NodeR2"};
        % The elements can be set using class(NodeR2) or more easily "NodeR2"
        endNodes;
    end
    
    properties (Abstract = true, Constant = false, SetAccess = protected, ...
            GetAccess = protected)
        % NodeType: This is where the variable is stored (e.g., X_k pose). This
        % will depend on the type of variable stored.
        m_value;
    end
    
end