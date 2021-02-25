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
classdef (Abstract) BaseEdge < handle
    %BASEEDGE Necessary functions and variables to implement an Edge class
    
    methods         
        %   The constructor can take multiple optional/parameters arguments. To
        %   use the constructore, pass in a value or name-value pair depending
        %   on the type of argument (if it's `optional', then do not specify
        %   name-value pair, if it's `parameter' then specify name-value pair). 
        %
        %   In the constructor of the implementation class, call the BaseNode
        %   constructor using
        %       obj@BaseEdge( varargin{:})  
        function obj = BaseEdge( varargin)            
            % @params[in][parameter] 'params'
            %   Struct of params needed for the implemented class
            % @params[in][parameter] 'id'
            %   Positive real scalar for the edge id.
            % @params[in][parameter] 'end_nodes'
            %   Cell array of end_nodes. E.g., { X1, X2}
            % @params[in]parameter] 'meas'
            %   Measurement value.
            % @params[in][parameter] 'covariance'
            %   Measurement (random variables) covariance matrix. Not to be
            %   confused with the covariance on the error function.
            
            % Initialize the end nodes to empty cell array of the appropriate
            % size
            obj.end_nodes = cell( 1, obj.numEndNodes);
            % Set all nodes to 'uninitialized'
            obj.valid_end_nodes = false( 1, obj.numEndNodes);
            
            % Default values
            default_params     = struct();
            default_id         = nan();
            default_end_nodes  = cell(1, obj.numEndNodes);
            default_meas       = nan();
            default_covariance = nan();
            
            % No validator for the parameters
            isValidParams = @(params) true;
            isValidId     = @(id) obj.isValidId( id) ||  ( obj.isScalarNan( id));
            isValidEndNodes = @(endNodesCell) length( endNodesCell) ...
                == obj.numEndNodes;
            isValidMeas = @(meas) obj.isScalarNan( meas) ...
                || obj.isValidMeas( meas);
            isValidCov = @(cov) obj.isScalarNan( cov) ...
                || obj.isValidCov( cov);
            
            % Input paraser
            p = inputParser;
            
            addParameter( p, 'params', default_params, isValidParams);
            addParameter( p, 'id', default_id, isValidId);
            addParameter( p, 'end_nodes', default_end_nodes, isValidEndNodes);
            addParameter( p, 'meas', default_meas, isValidMeas);
            addParameter( p, 'cov', default_covariance, isValidCov);
            
            % Parse input
            parse( p, varargin{:});
            
            % Store objects
            obj.setParams(   p.Results.params);
            obj.setId(       p.Results.id);            
            obj.setEndNodes( p.Results.end_nodes{ :});
            obj.setMeas(     p.Results.meas);
            obj.setCov(      p.Results.cov);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = setId( obj, id_in)
            %SETID Sets the edge id.
            
            % Check if input is a scalar nan
            if obj.isScalarNan( id_in)
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
        
        function obj = setMeas( obj, meas_in)
            % SETMEAS: Set the measurement (expected value).
            % Takes a scalar nan or a valid measurement
            
            % Check if measurement is a scalar nan
            if obj.isScalarNan( meas_in)
                obj.meas = nan();
                return;
            else
                obj.meas = meas_in;
            end
        end        

        function setCov( obj, cov_in)
            % Set covariance matrix
            
            % If it's a scalar nan, then simply store that
            if obj.isScalarNan( cov_in)
                obj.cov = nan;
                obj.m_rvs_2ndMoments_up_to_date = false;
                return;
            end
            % Check if matrix is valid
            if obj.isValidCov( cov_in)                
                
                obj.cov = cov_in;                
                
                % Update other matrices
                obj.infm      = inv( obj.cov);
                obj.sqrt_infm = obj.infm2sqrtInfm( obj.infm);
                
            else %its an invalid matrix 
                warning("Invalid covariance matrix");
                
                obj.cov = cov_in;
                
                % Update other matrices. Do not call setInfm to avoid getting in
                % an infinite loop
                obj.infm      = nan( size( obj.cov));
                obj.sqrt_infm = nan( size( obj.cov));                
            end
            
            % Random variable second moments are up to date.
            obj.m_rvs_2ndMoments_up_to_date = true;
            obj.m_err_2ndMoments_up_to_date = false;            
        end
        
        function setInfm( obj, infm_in)
            % Set information matrix and update other matrices
            if obj.isScalarNan( infm_in)
                obj.infm = nan;
                obj.m_rvs_2ndMoments_up_to_date = false;
                return;
            end
            
            if obj.isValidCov( infm_in)              
                obj.infm = infm_in;
                obj.m_infm_up_to_date  = true;
                
                % Update other matrices
                obj.cov       = inv( obj.infm);
                obj.sqrt_infm = obj.infm2sqrtInfm( obj.infm);
            else% its an invalid matrix
                warning("Invalid information matrix");
                
                obj.infm = infm_in;
                
                % Update other matrices
                obj.cov       = nan( size( obj.infm));
                obj.sqrt_infm = nan( size( obj.infm));                
            end
            
            obj.m_rvs_2ndMoments_up_to_date = true;
            obj.m_err_2ndMoments_up_to_date = false;            
        end
        
        function setSqrtInfm( obj, sqrt_infm_in)
            % Check if it's a scalar nan
            if isScalarNan( sqrt_infm_in)
                obj.sqrt_infm = sqrt_infm_in;
                obj.m_rvs_2ndMoments_up_to_date = false;
                return;
            end
            % Check if the square is a valid ifnromation matrix
            if obj.isValidCov( sqrt_infm_in' * sqrt_infm_in)
                obj.sqrt_infm = sqrt_infm_in;
                
                % Update other matrices
                obj.infm = obj.sqrt_infm' * obj.sqrt_infm;
                obj.cov  = inv( obj.infm);
            else% its an invalid matrix
                warning("Invalid square root information matrix");
                
                obj.sqrt_infm = sqrt_infm_in;
                
                % Update other matrices
                obj.infm = nan( size( sqrt_infm_in));
                obj.cov  = nan( size( sqrt_infm_in));
            end
            
            obj.m_rvs_2ndMoments_up_to_date = true;
            obj.m_err_2ndMoments_up_to_date = false;            
        end
        
        function setErrInfm( obj, err_infm_in)            
            % Set information matrix and update other matrices
            if obj.isScalarNan( err_infm_in)
                obj.err_infm = nan;     
                obj.m_err_2ndMoments_up_to_date = false;
                return;
            end
            
            if obj.isValidCov( err_infm_in)              
                obj.err_infm = err_infm_in;                
                
                % Update other matrices
                obj.err_cov       = inv( obj.err_infm);
                obj.err_sqrt_infm = obj.infm2sqrtInfm( obj.err_infm);
            else% its an invalid matrix
                warning("Invalid information matrix");
                
                obj.err_infm = err_infm_in;
                
                % Update other matrices
                obj.err_cov       = nan( size( obj.err_infm));
                obj.err_sqrt_infm = nan( size( obj.err_infm));                
            end
            
            obj.m_err_2ndMoments_up_to_date = true;
            obj.m_rvs_2ndMoments_up_to_date = false;
        end
        
        function setErrCov( obj, err_cov_in)
            % Set information matrix and update other matrices
            if obj.isScalarNan( err_cov_in)
                obj.err_cov = nan;    
                obj.m_err_2ndMoments_up_to_date = false;            
                return;
            end
            
            if obj.isValidCov( err_cov_in)              
                obj.err_cov = err_cov_in;                
                obj.m_err_2ndMoments_up_to_date = true;                
            
                % Update other matrices
                obj.err_infm       = inv( obj.err_cov);
                obj.err_sqrt_infm  = obj.infm2sqrtInfm( obj.err_infm);
            else% its an invalid matrix
                warning("Invalid information matrix");
                
                obj.err_cov = err_cov_in;
                obj.m_err_2ndMoments_up_to_date = true;
                
                % Update other matrices
                obj.err_infm      = nan( size( obj.err_cov));
                obj.err_sqrt_infm = nan( size( obj.err_infm));                
            end
            
            obj.m_rvs_2ndMoments_up_to_date = false;
        end
        
        function setEndNodes(obj, varargin)
            % This sets the end_nodes cell array. 
            %   Note that the end nodes should be passed by reference.
            % varargin should be of length equal to numEndNodes. If a specific
            % node is to be set, then use `setEndNode'
            if length( varargin) ~= obj.numEndNodes
                error("Number of input arguments is invalid");
            end
            for lv1 = 1 : obj.numEndNodes                
                obj.setEndNode( lv1, varargin{ lv1});                
            end
        end
        
        
        function setEndNode( obj, num, node)
            % Sets a single endNode
            % @params[in] num : 
            %   The NUMBER (positive int) of the node to be added (the order
            %   from the cell array). E.g., num = 2 indicates that we want to
            %   set the second node.
            % @params[in] node : 
            %   Node struct. A reference to the node to be added.
            
            % Check validity of the number
            if ~( isscalar( num) && isreal( num) && num > 0 ...
                && num <= obj.numEndNodes)
                error("Invalid number");
            end
            
            % Check if node is an empty variable. In such case, just fill an
            % empty cell.
            if isempty( node)
                obj.end_nodes{ num} = nan;
                return;
            end
            % Check if node is valid
            if ~( strcmp( node.type, obj.endNodeTypes( num)))
                % Invalid type
                error("Invalid node type. It should be of type %s", ...
                    obj.endNodeTypes( num));
            end
            obj.end_nodes{ num} = node;  
            
            % Set the node to a 'valid' node.
            obj.valid_end_nodes( num) = true;
        end
        
        % params setter
        function setParams( obj, params_in)
            obj.params = params_in;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Getters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function val = get.meas( obj)         
            % Get measurement
            
            % Display a warning if measurement is not initialized
            if obj.isScalarNan( obj.meas)
                warning('Measurement not set');
            end
            val = obj.meas;
        end
        
        function val = get.cov( obj)
            if obj.isScalarNan( obj.cov)
                warning("Meas. covariance matrix not initialized");
            end
            val = obj.cov;
        end
        
        function val = get.err_cov( obj)
            % Check if the error covariance is up to date
            if ~obj.m_err_2ndMoments_up_to_date ...
                    && obj.m_rvs_2ndMoments_up_to_date
                % Update error covariance
                obj.updateErrCov();
            end
            % Warn user if the error covariance matrix is not initialized
            if obj.isScalarNan( obj.err_cov)
                warning("Error covariance matrix not initialized");
            end                 
            if ~obj.m_err_2ndMoments_up_to_date
                warning("Error covariance matrix is not up to date");
            end
            val = obj.err_cov;
        end
                
        function val = get.err_infm( obj)            
            if ~obj.m_err_2ndMoments_up_to_date
                % Update 2nd moment information
                obj.updateErrCov();
            end
            % Warn user if the error information matrix is not initialized
            if obj.isScalarNan( obj.err_infm)
                warning("Error information matrix not initialized");
            end
            val = obj.err_infm;
        end
        
        % Get error sqrt information matrix
        function val = get.err_sqrt_infm( obj)
            if obj.isScalarNan( obj.err_sqrt_infm)
            if ~obj.m_err_2ndMoments_up_to_date
                % Update matrices
                obj.updateErrCov();
            end
                warning("Error sqrt information matrix not initialized");
            end
            val = obj.err_sqrt_infm;
        end
        
        % Get error values
        function val = get.err_val( obj) 
            % Need to compute error just in case the values of the nodes were
            % updated (they can be updated externally since they are referenced
            % objects).
            obj.computeError();
            
            % Output the error value.
            val = obj.err_val;
        end
        
        function val = get.werr_val( obj)
            % Get wegithed error value
            
            % Update error covariances
            obj.updateErrCov();
            val = obj.err_sqrt_infm * obj.err_val;
        end
        
        % Get chi-squared distance
        function val = get.chi2( obj)
            % Compute the weighted error and return it's inner product
            val = obj.werr_val' * obj.werr_val;
        end
        
        
        % Update error covariance, information, and sqrt information
        function updateErrCov( obj)
            % The error function is a function of the noise terms. Therefore,
            % the covariance on the error function is propagated using
            % first-order methods or sigma point, or any other method.
            % The user must be careful not to update the error covariance during
            % a batch optimization problem; this would mess up the results.
            
            % If the 2nd-moment information on the random variables are
            % up-to-date but the 2nd-moment informaiton on the error function
            % are NOT up-to-date, then update the error function 2nd moments by
            % propagating the covariance
            if obj.m_rvs_2ndMoments_up_to_date && ~obj.m_err_2ndMoments_up_to_date
                % Propagate covariance using first-order methods                
                %   Get the Jacobian of the error function w.r.t. random variables
                J_rv = obj.getErrJacobianRVs();
                if any( isnan( J_rv))
                    error( "Jacobian of error function w.r.t. random variables contains NaNs");
                end
                % Set the error covariance: this will also update the
                % information and sqrt information matrices 
                obj.setErrCov( J_rv * obj.cov * J_rv');
                
                % Both the RVs and error function 2nd-moment information are
                % up-to-date.
                obj.m_err_2ndMoments_up_to_date = true;
                obj.m_rvs_2ndMoments_up_to_date = true;                
            end
        end
    end
    
    
    methods (Abstract = true, Static = false, Access = protected)
        % computeError;
        computeError( obj);
        
        % get error jacobians w.r.t. states/nodes
        getErrJacobiansNodes( obj);
        
        % get error jacobians w.r.t. random variables
        getErrJacobianRVs( obj);
        
        % Measurement validator
        bool = isValidMeas( obj, meas);
        
        % RV covariance validator
        isvalid = isValidCov( obj, mat);     
    end
    
    methods (Abstract = false, Static = true)        
        function sqrt_mat = infm2sqrtInfm( inf_mat)
            % infm2sqrtInfm
            %   Information matrix to sqrt information matrix
            %   This gives 
            %       sqrt_mat' * sqrt_mat == inf_mat
            [V, D] = eig( inf_mat);
            sqrt_mat = sqrt( D) * V';
        end
        
        % A function that checks whether an ID is valid. It uses the BaseNode
        % static method.
        function isvalid = isValidId( id_in)
            isvalid = BaseNode.isValidId( id_in);
        end
        
        % Check whether an element is a scalar nan
        function out = isScalarNan( arg)
            out = isscalar( arg) && isnan( arg);
        end
    end
    properties (Abstract = true, Constant = true)
        %   The m_* prefix indicates that it's a 'member' variable
        
        % static const string: Edge type (e.g., "EdgeSE2" or "EdgeSE2R2"). I'll
        % use the convention of setting type to the class name
        type;
        
        % static const int: Number of nodes attached to this edge (usually
        % it's either 1 or 2 for SLAM problems)
        numEndNodes;
        
        % static const string array of types of the end nodes. The order
        % matters! It should match the class name (e.g., "EdgeSE2R2" is
        % different from "EdgeR2SE2"). E.g., endNodes = {"NodeSE2", "NodeR2"};
        % The elements can be set using class(NodeR2) or more easily "NodeR2"
        endNodeTypes;
        
        % Dimension of the error function (or degrees of freedom)
        errDim;
        
        % Dimension of the measurement
        measDim;
        
        % Number of random variables (including the measurement if it's counted
        % as a random variable)
        numRVs;
    end
    
    properties (SetAccess = protected)
        
        % Computed error value. This should only be set internally, cannot be
        % modified by user.
        err_val = nan;
                
        % Weighted error
        werr_val = nan;
        
        % Chi squared value
        chi2 = nan;
        
        % Square root information matrix of the ERROR function.
        err_sqrt_infm = nan;
        
        % Covariance matrix on the ERROR function, not the measurements!        
        err_cov = nan;      
        
        % Information matrix of the ERROR function, not the measurements! The
        % information will be stored in information form. The informaiton matrix
        % can be set by the user (for example to zero). This is the ``inverse''
        % of the `err_cov' matrix if the matrix is invertible.
        err_infm = nan;      
        
        % Covariance matrix on the RANDOM VARAIBLES (i.e., the process or
        % measurement noise).
        cov = nan;
        
        % Information matrix on the RANDOM VARAIBLES (i.e., the
        % process or measurement noise). This is the inverse of `cov'        
        infm = nan;
        
        % Square root information matrix on the RANDOM VARAIBLES (i.e., the
        % process or measurement noise).
        sqrt_infm = nan;

        % Random variable second moments (covariance, information, sqrt
        % information) are up to date
        m_rvs_2ndMoments_up_to_date = false;
        % Error function second moments (covariance, information, sqrt
        % information) are up to date
        m_err_2ndMoments_up_to_date = false;
        
        % Parameters. A struct of parameters that can be used by the implemented
        % class.
        params = struct();
        
        % Edge id
        id = nan;        
        
        % Instances of the end nodes. They should be REFERENCES to the nodes.
        end_nodes;
        
        % Initialized end_nodes
        valid_end_nodes;
        
        % Measurements realization (expected value)
        meas = nan;        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Explanation
%       For inference, we need the covariance/information matrices on the error
%       function. Therefore, we need a transformation from the random variables
%       (e.g., white process or measurement noise) to the error function. This
%       is usually encoded by the Jacobian L or M for process models and
%       measurement functions, respectively.
%
%       Therefore, it'll be a requirement to provide the Jacobian of the ERROR
%       function w.r.t. random variables (i.e., noise).
%       
%       The Nodes are passed by REFERENCE! This would allow for efficiency in
%       implementation but caution must also be exercised.
%   TODO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%