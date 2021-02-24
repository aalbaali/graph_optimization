%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a base node abstract class.
%  
%   Further explanation is provided at the end of this file.
%   A log of major changes is attached at the end of this file.
%
%   Amro Al Baali
%   23-Feb-2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef BaseNode < handle
    %BASENODE Necessary functions and variables to implement a node class
    % This class is a handle class which allows internal properties to be
    % modified
    
    
    methods
        function obj = BaseNode()                     
        end
        % Value setter. Verify that the value is a valid element.
        function set.value(obj, value_in)
            if ~obj.isValidValue( value_in)
                error("Invalid input");
            end
            % Set the internal value
            obj.value = value_in;
            
            % Set the marker to inialized
            obj.m_value_initialized = true;
        end
        
        % Value getter. Generate warning if value is not initialized.
        function value_out = get.value(obj)
            if ~obj.m_value_initialized
                warning('Value not initialized');
            end
            % Return the internal value
            value_out = obj.value;
        end       
        
        % Increment local value with an increment
        function out = increment( obj, increment)
            % Check if value is instantiated
            if isnan( obj.value)
                error("Value not initialized");
            end
            
            % Check validity of the increment
            % The static `oplus' isValidIncrement is called.
            if ~obj.isValidIncrement( increment)                
                error("Invalid increment");
            end
            
            % The static `oplus' element is called
            obj.value = obj.oplus( obj.value, increment);
            out = obj.value;
        end
        
        % Overload the `+' operator using the `increment' function.
        function out = plus( obj, increment)
            obj.increment( increment);
            out = obj.value;
        end
        
        % Display function
%         function out = disp( obj)
%             if ~obj.m_value_initialized                
%                 out = obj;
%                 return
%             end
%             disp( obj.value);            
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
    
    properties (Abstract = false, Access = protected)
        % Tracks whether a value is initialized or not
        m_value_initialized = false;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%       Types of properties
%       the 'type' and 'dim' properties are set to constant
%       because they shouldn't change for the implemented class. They are set to
%       constant because they do not rely on the implementation of the class. 
%       The reason I want them to be static is that if we are simply provided
%       the class name, then we can access its type and dimension without
%       creating an instance of the class.
%
%       The 'value' property is public, but it comes with its own setters and
%       getters. The setters ensure that that the provided values are valid.
%       This approach should be convenient and safe (reliable).
%       
%       The validity checkers are abstract methods since they are specific to
%       the implementation. This is also the case for the oplus operator. For
%       general codes, another subclass can be inherited from this class. For
%       example, for linear nodes, a subclass can be inherited from this base
%       class and it can serve as another abstract class for specific
%       implementations.
%       
%       The reason I'm using 'eval(obj.type)' is to use the static methods from
%       the inherited class.
%   --------------------------------------------------------------------------
%   Change log
%   --------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%