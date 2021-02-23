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
    end
    
    methods (Abstract = true, Static = true)
       
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
        
    end
    
end