%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   A template of a class to implement a class derived from BaseNode
%
%   Amro Al Baali
%   28-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef NodeTemplate < BaseNode
    % Replace the 'Template' in NODETEMPLATE with an appropriate name (e.g.,
    % SE2, Rn, etc.). Make sure that it inherits the BASENODE class
    
    methods
        function obj = NodeTemplate( varargin)
            % NODETEMPLATE is the constructor for this class. Ensure that the
            % right parsing method is used (if an argument is required, then
            % specify it as an argument (not in varargin). Similarly, add the
            % required parameters accordingly.
            
            % For example, in the NodeRn class, it's a requirement to specify
            % the dimension of the node.
            
            % Call the superclass constructor
            obj = obj@BaseNode( varargin{ :});
        end
        
        function value = oplus( ~, value_in, xi)
            %OPLUS( value_in, xi) "adds" xi (the increment) to value_in. This is
            %straightforward in a linear space, but in Lie groups, this would
            %depend on the error definition (left perturbation, left-invariant
            %perturbation, etc.)
            
            % Note. The '+' operator is overloaded and calls this class, where
            % value_in is the stored value.
        end
        
        function isvalid = isValidValue( obj, valiue_in)
            % ISVALIDVALUE( value_in) checks if value_in is a valid value for
            % this class. This method is class-specific.
        end
        
        function isvalid = isValidIncrement( obj, increment_in)
            % ISVALIDINCREMENT( increment_in) checks if the given increment_in
            % is a valid increment. This validator is class-specific (i.e., it's
            % different for different classes.            
        end
    end
    
    properties (SetAccess = protected)
        % These properties are abstract properties which means they must be
        % implemented/defined in this class. Their values can be initialized in
        % the constructor or here, but not both.
        
        % Let the class type be the class name (which is also the file name)
        type = string( mfilename);
        
        % Specify the dimension of the node (value). E.g., for SE2, that's 2
        % (not 3).
        dim;
        
        % Degree of freedom of the node. This is basically the dimension of the
        % increment. E.g., for SE2, dof is 3.
        dof;
    end
end