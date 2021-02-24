%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Edge between two R^2 elements. This could for a linear process model.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef EdgeR2R2 < BaseEdge
    %EDGER2R2 Implementation of BaseEdge between two R^2 elements
    
    methods
        % Constructor
        function obj = EdgeR2R2()
            obj = obj@BaseEdge();
        end
        
        % Functions to set the matrices of the linear process model        
        function set.A( obj, A_in)
            if ~all( size( A_in) == [ obj.errDim, obj.errDim])
                error("Invalid size");
            end
            obj.A = A_in;
        end
        
        function set.B( obj, B_in)
            if ~all( size( B_in) == [ obj.errDim, obj.measDim])
                error("Invalid size");
            end
            obj.B = B_in;
        end
        
        function set.L( obj, L_in)
            if ~all( size( L_in) == [ obj.errDim, obj.numRVs])
                error("Invalid size");
            end
            obj.L = L_in;
        end
        
        function setEndNodes(obj, varargin)
            % varargin should be of length equal to numEndNodes
            if length( varargin) ~= obj.numEndNodes
                warning("Number of input arguments is invalid");
            end
            for lv1 = 1 : obj.numEndNodes
                if ~strcmp( varargin{lv1}.type, obj.endNodeTypes( lv1))
                    error("Node is of wrong type");
                else
                    obj.endNodes{ lv1} = varargin{ lv1};
                end
            end
        end
    end
    
    methods (Static = true)
    end
    
    methods (Static = false, Access = protected)
        % Compute error
        function computeError( obj)
            %COMPUTEERROR Updates the weighted error value and returns the
            %value.
            % First pose
            X1 = obj.endNodes{1}.value;
            X2 = obj.endNodes{2}.value;
            
            % Unweighted error
            obj.err_val = X2 - obj.A * X1 - obj.B * obj.meas;
        end
        
        % A function that computes the error Jacobians w.r.t. states/nodes
        function H = getErrJacobiansNodes( obj)
            H = obj.A;
        end
        % A function that computes the error Jacobians w.r.t. the random
        % variables
        function L = getErrJacobianRVs( obj)
            L = obj.L;
        end
        
        
        % Measurement validator
        function isvalid = isValidMeas( obj, meas_in)
            % Check if the dimensions make sense
            isvalid = all( size( meas_in) == [ obj.measDim, 1]);
            isvalid = isvalid && all( ~isinf( meas_in));
            isvalid = isvalid && all( ~isnan( meas_in));
        end
        
        % Random varaibles covariance validator
        function isvalid = isValidCov( obj, mat_in)
            % First check size
            isvalid = all( size( mat_in) == [obj.numRVs, obj.numRVs]);
            % Check if matrix is symmetric
            isvalid = isvalid & norm( mat_in - mat_in') <= 1e-5;
            % Check eigenvalues (this might be an expensive step that I might
            % need to omit)
            isvalid = isvalid & all( eig( mat_in) >= 0);
        end
    end
    
    properties (Constant = true)
        % Type of this edge
        type = string( mfilename);
        
        % Number of end nodes: it's a binary edge.
        numEndNodes = 2;
        
        % Array of end node types
        endNodeTypes = [ "NodeR2", "NodeR2"];
        
        % Dimension of error function
        errDim = 2;
        
        % Dimension of the measurement (in this class, it could be 1 or 2. I
        % chose to make it 2 to try it out).
        measDim = 1;
        
        % Number of random variables. 1. noise on the interoceptive measurement
        % u, and 2 on process noise w_1 and w_2.
        numRVs = 3;
    end
    
    properties 
        % Sysetm matrices
        A = nan;
        B = nan;
        L = nan;
    end
end