%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   An implementation of the BaseNode class. 
%
%   This is a 2D linear node. This should be generalized into multidimensional
%   linear class (perhaps add another Abstract class that inhertics from
%   BaseNode).
%   
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef NodeR2 < NodeRn
    %NODER2 Implementation of BaseNode on elements of R^2 space.    
    methods (Access = public)
        % Constructor
        function obj = NodeR2( varargin)
            % This is a subclass of Rn class. Set the dimension and degree of
            % freedom to 2.
            obj = obj@NodeRn( 2, varargin{:});            
            obj.type = string( mfilename);
        end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%
%   --------------------------------------------------------------------------
%   Change log
%   --------------------------------------------------------------------------