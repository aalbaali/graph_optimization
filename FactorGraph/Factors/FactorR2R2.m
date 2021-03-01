%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Edge between two R^n elements. This could for a linear process model.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FactorR2R2 < FactorRnRn
    %FACTORR2R2 Implementation of BaseEdge between two R^2 elements
    
    methods
        % Constructor
        function obj = FactorR2R2( varargin)
            obj = obj@FactorRnRn( varargin{:});           
            
            % Array of end node types
            obj.setEndNodeTypes( [ "NodeR2", "NodeR2"]);
            obj.type = string( mfilename);
        end
        
        function setParam( obj, field_in, param_in)
            obj.params.(field_in) = param_in;
            
            switch field_in
                case 'A'
                    % Dimension of error function
                    obj.setErrDim( size( obj.params.A, 1));                    
                    
                    % Set the descriptor matrix to be identity of the same size
                    % as the A matrix
                    obj.setParam( 'E', eye( size( obj.params.A)));
                case 'B'
                    % Dimension of the measurement (in this class, it could be 1
                    % or 2. I chose to make it 2 to try it out).
                    obj.setMeasDim( size( obj.params.B, 2));
                    
                case 'L'
                    % Number of random variables. 1. noise on the interoceptive
                    % measurement u, and 2 on process noise w_1 and w_2.
                    obj.setNumRvs( size( obj.params.L, 2));
            end
        end        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%   ----------------------------------------------------------------------------
%   Change log
%       24-Feb-2021
%           Changed the class name from EdgeR2R2 to FactorR2R2.
%   
%           The reason for this change is that Factors should be treated as
%           nodes, not as edges. 
%   
%       28-Feb-2021
%           Created another subclass for RnRn which I inherited from.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%