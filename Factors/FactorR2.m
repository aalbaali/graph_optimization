%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Edge between two R^2 elements. This could for a linear process model.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FactorR2 < FactorRn
    %FACTORR2 Implementation of BaseEdge to a single R^2 element
    
    methods
        % Constructor
        function obj = FactorR2( varargin)
            obj = obj@FactorRn( varargin{:});            
            
            % Array of end node types
            obj.setEndNodeTypes( [ "NodeR2"]);
        end
        
        function setParam( obj, field_in, param_in)
            % Overload to function to make it specific to this node
            
            % Update field
            obj.params.(field_in) = param_in;
            
            % Specific instructions to certain fields
            switch field_in
                case 'C'       
                    if size( param_in, 2) ~= 2
                        error("C matrix is of wrong size");
                    end
                    % Update error dimension
                    obj.setErrDim( size( param_in, 1));
                    obj.setMeasDim( size( param_in, 1));
                    
                case 'L'
                    obj.setNumRvs( size( param_in, 2));
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%   ----------------------------------------------------------------------------
%   Change log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%