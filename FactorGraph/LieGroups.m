%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Abstract class for Lie group factors. It inherits from the BaseFactor class
%   and adds few properties.
%
%   Amro Al Baali
%   28-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) LieGroups < handle
    methods 
        function obj = setErrorDefinition( obj, err_def)
            % SETERRORDEFINITION( err_def) checks if the error definition is a
            % valid definition and stores it to the object.
            p = inputParser;
            addRequired( p, 'err_def', @obj.isValidErrorDefinition);
            parse( p, err_def);
            obj.error_definition = err_def;
        end
    end
    
    methods (Static = true)
        function isvalid = isValidErrorDefinition( err_def)
            % ISVALIDERRORDEFINITION( err_def) checks whether err_def is a valid
            % error function.
            
            isvalid = any( validatestring( err_def, ...
                NodeLieGroups.valid_error_definitions));
        end
    end
    properties (SetAccess = protected)
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