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

classdef BaseNode < handle & matlab.mixin.Copyable
    %BASENODE Necessary functions and variables to implement a node class
    % This class is a handle class which allows internal properties to be
    % modified
    
    
    methods
        %   The constructor can take multiple optional/parameters arguments. To
        %   use the constructore, pass in a value or name-value pair depending
        %   on the type of argument (if it's `optional', then do not specify
        %   name-value pair, if it's `parameter' then specify name-value pair). 
        %
        %   In the constructor of the implementation class, call the BaseNode
        %   constructor using
        %       obj@BaseNode( varargin{:})        
        function obj = BaseNode( varargin)                     
            % @params[in][optional] 'value'
            %   (optional) value of the node. If specified, then it must be
            %   passed as the FIRST argument. 
            %   Note that it canNOT be specified using name-value pair
            %   (i.e., specifying 'value', [1;2] will NOT work!
            %
            % @params[in][parameter] 'id' 
            %   Positive real scalar. If specified, it MUST be passed in using
            %   name-value pairs. E.g., ('id', 5).
            
            % Set UUID (Note: this is an external function in the Utils/
            % directory).
            obj.UUID = generateUUID();
            
            % Default values
            %   A `value' of nan implies it's not initialized.
            default_value = nan;
            %   An `id' of nan implies it's not initialized.
            default_id    = nan;
            %   A `name' is different from `type' and can be user defined.
            default_name  = nan;
            
            % Input parser
            p = inputParser;
            % Lambda functions for validating inputs            
            %   A `value' can either be a valid value (check isValidValue) or it
            %   can be a nan (scalar, not array).
            isValidValue = @(v) ( isscalar(v) && isnan(v)) || obj.isValidValue( v);
            %   An `id' can either be valid id (check isValidId) or it can be a
            %   scalar nan (not array).
            isValidId    = @(id) obj.isValidId( id) || ( isscalar( id) && isnan( id));
            %   A valid name should only be a string
            isValidName  = @(name) isstring( name) || ischar( name);
            isValidDim   = @( dim) isscalar( dim) && isreal( dim) && dim > 0;
            
            % `value' is `optional' (if passed, it MUST be the FIRST argument).
            addOptional ( p, 'value', default_value, isValidValue);            
            % `id' is `parameter' (if passed, it MUST be specified using
            % name-value pair).
            addParameter( p, 'id', default_id, isValidId);
            % `name' is an (optional) parameter. So a name-value argument must
            % be passed.
            addParameter( p, 'name', default_name, isValidName);
            addParameter( p, 'dim', [], isValidDim);
            addParameter( p, 'dof', [], isValidDim);
            
            % Parse 
            parse(p, varargin{:});
            
            % Store results
            obj.setValue( p.Results.value);
            obj.setId( p.Results.id);
            obj.setName( p.Results.name);
            obj.dim = p.Results.dim;
            obj.dof = p.Results.dof;
            
            if obj.dof > obj.dim
                warning( 'dof > dim');
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = setValue(obj, value_in)
            %SETVALUE Checks if a value is valid and stores it in the object.            %
            % @params[in] value_in: 
            %   The value to be stored in the node. It accepts a value of nan
            %   (scalar) which implies a non-initialized 'value'
            
            % Check if input is a scalar nan
            if isscalar( value_in) && isnan( value_in)
                obj.value = value_in;
                % Indicate that the value is no longer initialized.
                obj.m_value_initialized = false;
                return;
            end
            
            p = inputParser;
            addRequired( p, 'value_in', @obj.isValidValue);
            parse( p, value_in);
            value_in = p.Results.value_in;
            
            % Set the internal value
            obj.value = value_in;
            
            % Set the flag to indicate that the value is initialized.
            obj.m_value_initialized = true;
        end
              
        function obj = setId( obj, id_in)
            %SETID  A method to set `id'
            % @params[in] id: real positive integer

            % Check if input is a scalar nan
            if isscalar( id_in) && isnan( id_in)
                obj.id = id_in;                
                return;
            end
            
            % Check if the id is valid
            if obj.isValidId( id_in)
                % Store as an integer
                obj.id = int8( id_in);
            else
                error("Invalid id input");
            end
        end
        
        function obj = setCov( obj, cov)
            %SETCOV sets the covariance on the value of the object. 
            %
            
            % I should check for positive semi-definiteness but I'm not aware of
            % a cheap way to do it. Checking for positive definiteness might be
            % too restrictive.
            isValidCov = @( cov) issymmetric( cov) && length( cov) == obj.dof;            
            
            p = inputParser;            
            addRequired( p, 'cov', isValidCov);
            parse( p, cov);
            
            obj.cov = cov;
        end
        
        function obj = setName( obj, name_in)
            %SETNAME Sets the name of the node
            % @params[in] name_in: string.
            
            if ~isstring( name_in) && isnan( name_in)
                obj.name = nan;
            elseif ischar( name_in) || isstring( name_in)
                % Ensure that it's stored as string
                obj.name = string( name_in);
            else
                error("Invalid name type");
            end
        end
        
        function set.UUID( obj, UUID_in)
            % Ensures that UUID is set only once! Even by an internal function.
            if isempty( obj.UUID)
                obj.UUID = UUID_in;
            else
                error("UUID already defined to %s", obj.UUID);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Getters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function value_out = get.value(obj)
            %GET.VALUE Get the internal value.
            %   Displays a warning if the value is not initialized.
            if ~obj.m_value_initialized
                warning('Value not initialized');
            end
            % Return the internal value
            value_out = obj.value;
        end       
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Other public functions
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function out = increment( obj, increment)
            %INCREMENT : Increment `value' with an increment using the
            %   user-defined `oplus' method.

            % Check if value is initialized
            if ~obj.m_value_initialized
                error("Value not initialized");
            end
            
            % Check validity of the increment            
            if ~obj.isValidIncrement( increment)                
                error("Invalid increment");
            end
            
            % The (static) `oplus' element is called
            obj.value = obj.oplus( obj.value, increment);
            out = obj.value;
        end
        
        % Overload the `+' operator using the `increment' function.
        function out = plus( obj, increment)
            obj.increment( increment);
            out = obj.value;
        end
    end
    
    methods (Abstract = false, Static = true)        
        function isvalid = isValidId( id_in)
            %ISVALIDID Checks the validity of an `id'
            
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
    
    methods (Abstract = true, Static = false)
        % Static methods can be accessed without instantiating an object. These
        % can be used to access the node type and degrees of freedom (properties
        % that are specific to the implemented class but not a function of the
        % instance of the implemented class)
        
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
    
    methods (Access = protected)
        function cp = copyElement( obj)
            % COPYELEMENT allows for deep copies of objects of this class. This
            % method is needed since this class ia a HANDLE class. This means
            % that objects are passed by REFERENCE, not by value. Therefore, to
            % copy an object, the method `copy' must be called. Example:
            %    objectCopy = copy( originaObject);
            % However, we need a unique UUID for each object. Therefore, in this
            % method, a unique UUID is implemented for the new object.
            
            % Shallow copy object (doesn't copy the UUID)
            cp = copyElement@matlab.mixin.Copyable( obj);
            % Set UUID (Note: this is an external function in the Utils/
            % directory).
            cp.UUID = generateUUID();
        end
    end
    
    properties (Abstract = false, SetAccess = protected, NonCopyable)
        % The UUID is noncopyable because it's meant to be unique for any
        % instance of this class (or its derived classes).
        
        % Universally unique identifier
        UUID;
    end
    
    properties (Abstract = true, SetAccess = immutable)        
        
        % static const string: Node type (e.g., "NodeSE2"). I'll use the
        % convention of setting type to the class name.
        % In the inherited classes, simply use 
        %   'type = mfilename;'
        type;
        
        % static const int: Dimension of the space the robot operatoes on. For
        % example, for SE2, this is 2.
        dim;
        
        % static const int: Degrees of freedom. Degree of the tangent space. For
        % SE2, this is 3.
        dof;
    end
    
    properties (SetAccess = protected)        
        % Default value is set to NaN in order to know if it was initialized.
        value = nan;
        
        % Covariance on the estimate. Initialized to an empty variable.
        cov   = [];
        
        % Node Id. Initialzed to nan.
        id = nan;
        
        % Node name. This could be defined by the user (e.g., "PoseX_1")
        name;
    end   
    
    properties (Abstract = false, Access = protected)
        % Tracks whether a value is initialized or not
        m_value_initialized = false;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%       The constructor can take parameters of type name-value paris. This is
%       different than simply 'optional'.
%
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