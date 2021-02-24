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
        % The constructor can take a 'value' argument. If no argument is
        % provided, it'll be set to zero.
        % In the constructor of the implementation class, call the BaseNode
        % constructor using
        %       obj@BaseNode( varargin{:})        
        function obj = BaseNode( varargin)                     
            % @params[in] 'value': (optional) initial value of the node. If not
            % specified, it'll be set to nan.
            % @params[in] 'id' : positive real scalar. 
            defaultValue = nan;
            defaultId    = nan;
            
            % Input parser
            p = inputParser;
            % A scalar nan is a valid value (implies that it's uninitialized).
            validValue = @(v) ( isscalar(v) && isnan(v)) || obj.isValidValue( v);
            validId    = @(id) obj.isValidId( id) || ( isscalar( id) && isnan( id));
            
            % Optional
            addOptional( p, 'value', defaultValue, validValue);            
            addParameter( p, 'id', defaultId, validId);
            
            % Parse 
            parse(p, varargin{:});
            
            % Store results
            obj.value = p.Results.value;
            obj.id    = p.Results.id;
        end
        
        % Internal function setter
        function set.value( obj, value_in)
            obj.m_value_initialized = true;
            obj.value = value_in;
        end
        % Value setter. Verify that the value is a valid element.
        function setValue(obj, value_in)
            % @params[in] value_in: the value to be stored in the node. It
            % accepts a value of nan (scalar) to indicate an empty 'value'
            if isscalar( value_in) && isnan( value_in)
                obj.value = value_in;
                obj.m_value_initialized = false;
                return;
            end
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
        
        % Set ID
        function setId( obj, id_in)
            % @params[in] id: real positive integer
            if obj.isValidId( id_in)
                % Store as an integer
                obj.id = int8( id_in);
            else
                error("Invalid id input");
            end
        end
    end
    
    methods (Abstract = false, Static = true)
        % Function that checks the validity of an id
        function isvalid = isValidId( id_in)
            % Check if it's a scalar (don't want an array or matrix)
            isvalid = isscalar( id_in);
            % Check that it's a real number (not complex or nan, etc)
            isvalid = isvalid && isreal( id_in);
            % Ensure that it's nonnegative
            isvalid = isvalid && id_in >= 0;
            % Ensure that it's a numeric integer (even though it could be stored
            % as a double)
            isvalid = isvalid && ( floor( id_in) == id_in);
        end
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
        
        % static const int: Dimension of the space the robot operatoes on. For
        % example, for SE2, this is 2.
        dim;
        
        % static const int: Degrees of freedom. Degree of the tangent space. For
        % SE2, this is 3.
        dof;
    end
    
    properties (SetAccess = protected)
        % NodeType: This is where the variable is stored (e.g., X_k pose). This
        % will depend on the type of variable stored.
        % Note that this is updated and set using MATLAB's getter and setter
        % functions. 
        % Default value is set to NaN in order to know if it was instantiated.
        value = nan;
        
        % Node Id
        id = nan;
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