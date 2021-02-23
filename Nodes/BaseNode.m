%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a base node abstract class.
%
%   Amro Al Baali
%   23-Feb-2021
%
%   --------------------------------------------------------------------------
%   Change log
%   --------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef BaseNode < handle
    %BASENODE Necessary functions and variables to implement a node class
    % This class is a handle class which allows internal properties to be
    % modified
    
    
    methods
        function obj = BaseNode( )                     
        end
        % Public func: Value setter.
        function set.value(obj, value_in)
            if ~obj.isValidValue( value_in)
                error("Invalid input");
            end
            % Set the internal value
            obj.value = value_in;
        end
        
        function value_out = get.value(obj)
            if all( isnan( obj.value))
                warning('Value not initialized');
            end
            % Return the internal value
            value_out = obj.value;
        end
        
%         function set.dd(obj, ~)
%             obj.dd = class(obj);
%         end
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
        % convention of setting type to the class name.
        % Therefore, in the inherited classes, simply use 'type = mfilename;'
        type;
        
        % static const int: Dimention or degrees of freedom (dof) of the variable
        % (e.g., for SE(2), it's 3)
        dim;
    end
    
    properties
        % NodeType: This is where the variable is stored (e.g., X_k pose). This
        % will depend on the type of variable stored.
        % Note that this is updated and set using MATLAB's getter and setter
        % functions. 
        % Default value is set to NaN in order to know if it was instantiated.
        value = nan;
    end   
end