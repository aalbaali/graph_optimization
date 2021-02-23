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
    end
    
    methods (Abstract = true, Static = true)
        % Static methods can be accessed without instantiating an object. These
        % can be used to access the node type and degrees of freedom (properties
        % that are not specific to any implementation)
        
        % Returns the node type
        type();
        
        % Returns the dimensions or degrees of freedom of this class
        dim();
    end
    
    properties (Abstract = true)
        %   The m_* prefix indicates that it's a 'member' variable
        
        % static const string: Node type (e.g., "NodeSE2"). This could also by
        % 'Name'
        m_type;
        
        % NodeType: This is where the variable is stored (e.g., X_k pose). This
        % will depend on the type of variable stored.
        m_value;
        
        % static const int: Dimention or degrees of freedom (dof) of the variable
        % (e.g., for SE(2), it's 3)
        m_dim;
    end
    
end