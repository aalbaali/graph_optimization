%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   An implmenetation of the BasicNode class to Lie groups. This is another
%   abstract class that is to be derived by specific Lie groups.
%
%   Amro Al Baali
%   28-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef NodeLieGroups < BaseNode
    % This class forms as an abstract class for Lie group classes.
    
    methods
        function obj = NodeLieGroups( group_name, dim, dof, err_def, varargin)
            % NODELIEGROUPS( group_name, dim, dof, err_def) stores the dim, dof,
            % and the Matrix Lie group name, and the error definition. E.g.,
            % NodeLieGroups( 2, 3, 'SE2', 'left-invariant').
            
            p = inputParser;
            addRequired( p, 'group_name', @(gn) any( validatestring( gn, ...
                NodeLieGroups.valid_lie_groups )));
            addRequired( p, 'dim', @(d) isscalar( d) && d > 0);
            addRequired( p, 'dof', @(d) isscalar( d) && d > 0);            
            addRequired( p, 'err_def', @(ed) any( validatestring( ed, ...
                NodeLieGroups.valid_error_definitions)));
            
            parse( p, group_name, dim, dof, err_def);
            
            dim = p.Results.dim;
            dof = p.Results.dof;
            
            % Call the superclass constructor
            obj = obj@BaseNode( varargin{ :}, 'dim', dim, 'dof', dof);
            
            % Store group name in the object.
            obj.group_name = p.Results.group_name;
        end
        
        function value = oplus( obj, value_in, xi)
            % OPLUS( value_in, xi) "adds" xi (the increment) to value_in. This
            % depends on the choice of the error_definition (default is
            % left-invariant
            
            switch obj.error_definition
                case 'left'
                    value = obj.algebra.expMap( xi) * value_in;
                case 'right'
                    value = value_in * obj.algebra.expMap( xi);                    
                case 'left-invariant'
                    value = value_in * obj.algebra.expMap( - xi);                    
                case 'right-invariant'
                    value = obj.algebra.expMap( - xi) * value_in;
            end
        end        
        
        function value = between( obj, value_k, value_km1)
            % BETWEEN( value_1, value_2) performs X_k \ominus X_km1 depending on the
            % choice of the error definition
            
            % Parse input
            p = inputParser;
            addRequired( p, 'value_k', @obj.isValidValue);
            addRequired( p, 'value_km1', @obj.isValidValue);
            parse( p, value_k, value_km1);
            
            switch obj.error_definition
                case 'left'
                    value = value_k * obj.group.inverse( value_km1);
                case 'right'
                    value = obj.group.inverse( value_km1) * value_k;
                case 'left-invariant'
                    value = obj.group.inverse( value_k) * value_km1;
                case 'right-invariant'
                    value = value_km1 * obj.group.inverse( value_k);
            end
        end
        
        function value = ominus( obj, value_k, value_km1)
            % OMINUS( value_1, value_2) performs Log( X1 \ominus X2) depending on the
            % error_definition
            
            value = obj.algebra.vee( obj.group.logMap( ...
                obj.between( value_k, value_km1)));
        end
        
        function value = minus( obj, value_in)
            % Overloads the ominus operator where value_k is the value stored in
            % the object.
            value = obj.ominus( obj.value, value_in);
        end
        
        function isvalid = isValidValue( obj, value_in)
            % ISVALIDVALUE( value_in) checks if value_in is a valid value for
            % the given group name.
            isvalid = obj.group.isValidElement( value_in);
        end
        
        function isvalid = isValidIncrement( obj, increment_in)
            % ISVALIDINCREMENT( increment_in) checks if the given increment_in
            % is a valid increment. It has to be a column matrix of length
            % equal to the dof of the group.
            isvalid = all( size( increment_in) == [ obj.dof, 1]);
        end
        
        function out = group( obj)
            % GROUP() returns the static class name of the group. This allows
            % the usage of the Lie group functions. For example:
            %   obj.group.decompose( obj.value);
            out = eval( upper( obj.group_name));
        end
        
        function out = algebra( obj)
            % ALGEBRA() returns the Lie algebra of the group. This allows the
            % usage of the Lie algebra class functions. For example,
            % obj.algebra.expMap( [1;2;3]);
            out = eval( strcat( lower( obj.group_name), 'alg'));
        end
    end
    
    properties (SetAccess = protected)
        % The type will be specified from the constructor.
        type;
        
        % Specify the dimension of the node (value). E.g., for SE2, that's 2
        % (not 3).
        dim;
        
        % Degree of freedom of the node. This is basically the dimension of the
        % increment. E.g., for SE2, dof is 3.
        dof;
        
        % Group name (string/char)
        group_name;
        
        % Defined error definition. The default is left-invariant
        error_definition = 'left-invariant';
    end
    
    properties (Constant = true)
        % Valid error definitions
        valid_error_definitions = {'left', 'right', 'left-invariant', ...
            'right-invariant'};
        
        % Valid Lie groups (this set should be updated whenever a new Lie group
        % node is added)
        valid_lie_groups = { 'SE2'};
    end
end