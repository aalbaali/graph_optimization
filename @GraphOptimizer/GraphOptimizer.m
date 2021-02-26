classdef GraphOptimizer < handle
    %GRAPHOPTIMIZER takes a factor graph and optimizes over its set of
    %variables. 
    
    methods 
        function obj = GraphOptimizer( varargin)
            %GRAPHOPTIMIZER 
            %   GRAPHOPTIMIZER( factor_graph) stores the factor_graph
            %   (reference).
            %
            %   GRAPHOPTIMIZER( factor_graph, verbosity) stores the factor graph
            %   (as a reference) and sets verbosity. Verbosity is either 0 or 1.
            %   Default value is 1.
            
            isValidFactorGraph = @(fg) isa( fg, 'FactorGraph');
            isValidVerb        = @(verb) isscalar( verb) && ( verb == 0 ...
                || verb == 1);
            
            defaultFactorGraph = [];
            defaultVerb        = 1;
            
            p = inputParser;
            
            addOptional( p, 'factor_graph', defaultFactorGraph, ...
                isValidFactorGraph);
            addOptional( p, 'verb', defaultVerb, isValidVerb);
            
            parse(p, varargin{ :});
            
            % Store factor graph
            obj.factor_graph = p.Results.factor_graph;
            obj.verbosity    = p.Results.verb;
        end
        
        function obj = optimize( obj)
            %OPTIMIZE This is the main function that optimizes over the graph.
            %
            %   OPTIMIZE('linear_solver', lin_solver) specifies the linear
            %   solver.
            
            obj.descend();
        end
        
        function obj = setLinearSolver( obj, lin_solver)
            %SETLINEARSOLVER set the linear solver.
            
            % Convert to lower case
            lin_solver = lower( lin_solver);
            
            % Expected solvers
            expected_solvers = {'qr', 'cholesky'};
            % Check if solver is in the list
            isValidLinSolver = @( solver) any( validatestring( solver, ...
                expected_solvers));           
            p = inputParser;
            addRequired( p, lin_solver, isValidLinSolver);
            
            obj.linear_solver = lin_solver;
        end
        
        function node_obj = node( obj, node_name)
            %NODE( node_name) returns the node object in the graph. It simply
            %calls the NODE method from the factor_graph object.
            node_obj = obj.factor_graph.node( node_name);
        end
    end
    
    methods (Access = public)
        % TEMPORARILY set to public for debugging
        
        % Initialize matrices constructs empty matrices of appropriate sizes
        initializeInternalParameters( obj);
        
        % DESCEND finds the next set of nodes (as part of the main loop)
        % that minimizes the objective function.             
        descend( obj);
        
        % Computes search direction and stores it in a private object in this
        % class instead of passing it by value.
        computeSearchDirection();
        
        % Computes step length depending on the system used (GN, LM, etc.)
        computeStepLength();
        
        % Constructs a linear system to be solved. This depends on the choice of
        % the optimization scheme. E.g., GN, LM, etc.
        constructLinearSystem();
        
        % Builds the Jacobian of the weighted err function and stores it in a
        % private sparse Jacobian.
        buildWerrJacobian();
        
        % Computes the weighted error and stores it in a private object.
        computeWerror();
        
        % Solves the (perturbed)linear system. This would depend on the choice
        % of the linear solver (QR, cholesky, etc.). This should implement
        % COLAMD.
        solveLinearSystem();
        
        % Updates the graph object by incrementing the search direction and step
        % lengths into the innner nodes.
        updateGraph();
        
        function printf( obj, varargin)
            % A function that prints to the console based on verbosity
            switch obj.verbosity
                case 0                    
                case 1
                    fprintf( varargin{ :});
            end
        end
    end
    
    methods (Static = true)
        function isready = checkFactorGraph( factor_graph, varargin)
            % CHECKFACTORGRAPH( factor_graph) checks whether a factor_graph is
            % ready for optimization. This means that each node
            %   1. has an initial value (if it's a variable node), 
            %   2. has a measurement (if it's a factor node), and
            %   3. has a covariance (if it's a factor node).
            % It does not check whether a factor returns a valid error function
            % or if it's missing some parameters. This may be done in the
            % future.
            %
            % CHECKFACTORGRAPH( factor_graph, verb) does the same as above, but
            % verbosity is changed. VERB can be be 0 (off) or 1 (on). Default
            % value is 1.
            
            isValidFactorGraph = @( fg) isa( factor_graph, 'FactorGraph');
            isValidVerb        = @( verb) isscalar( verb) && ( verb == 0 ...
                || verb == 1);
            
            defaultVerb = 1;
            
            p = inputParser;
            
            addRequired( p, 'factor_graph', isValidFactorGraph);
            addOptional( p, 'verb', defaultVerb, isValidVerb);
            
            parse( p, factor_graph, varargin{ :});
            
            verb = p.Results.verb;
            
            % Turn off all warnings. (It'll be turned on by the end of the
            % script)
            warning('off', 'all');
            
            % 1. Check variable nodes
            % Get variable node names
            node_names = factor_graph.getVariableNodeNames();
            
            % Go over each each variable node and check if value is initialized
            values_initialized = cellfun( @(c) ~any( isnan( ...
                factor_graph.node(c).value)), ...
                    node_names );
            
            % If some values are not initialized, list the nodes
            if verb && ~ all( values_initialized)
                disp( 'The variable nodes')
                cellfun(@(c) fprintf('\t%s\n', c), ...
                    node_names( ~ values_initialized));                
                disp('are not initialized');
            end
            
            isready = all( values_initialized);
            
            % 2. Check factor nodes
            factor_names = factor_graph.getFactorNodeNames();
            
            % Go over each factor node and check if measurement is initialized
            factors_includeMeas = cellfun( @(c) ~any( isnan( ...
                factor_graph.node(c).meas)), ...
                    factor_names );
                
            % If some measurements are not initialized, list the nodes
            if verb &&  ~ all( factors_includeMeas)
                disp( 'The factor nodes')
                cellfun(@(c) fprintf('\t%s\n', c), ...
                    factor_names( ~ factors_includeMeas));                
                disp('do not include measurements');
            end
            isready = isready && all( factors_includeMeas);
            
            % 3. Check the error covariances Go over each factor node and check
            % if error covariance is initialized
            factors_includeErrCov = cellfun( @(c) ~any( isnan( ...
                factor_graph.node(c).err_cov), 'all'), ...
                    factor_names );
            
            % List the factor nodes without error covariances
            if verb && ~ all( factors_includeErrCov)
                disp( 'The factor nodes')
                cellfun(@(c) fprintf('\t%s\n', c), ...
                    factor_names( ~ factors_includeErrCov));                
                disp('do not include error covariances');
            end
            isready = isready && all( factors_includeErrCov);
            
            % Turn on warnings back on
            warning('on', 'all');
        end
    end
    
    properties         
        % Verbosity. Default value is 1.
        verbosity = 1;
    end
    
%     properties (SetAccess = protected)
    properties (SetAccess = public)
        % TEMPORARILY set to public
        
        % Internal variables. But I kept the GetAccess to public for debugging
        
        % Number of variable nodes
        m_num_variable_nodes;
        
        % Number of factor nodes
        m_num_factor_nodes;
        
        % Struct array of factors. This each element, contains a struct that
        % includes 
        %   1. the name (name) of the factor node in the graph, and        
        %   2. the dimension (dim) of the error function of the factor.
        m_info_factors = struct( 'name', {}, 'dim', []);
        
        % Struct array of variables. This each element, contains a struct that
        % includes 
        %   1. the name (name) of the variable node in the graph, and        
        %   2. the degree of freedom (dof) of the variable of the factor.
        m_info_variables = struct( 'name', {}, 'dof', []);
        
        % Array of Jacobian column index for each variable. The variables are in
        % the same order as in m_info_factors
        m_idx_Jac_variables;
        
        % Number of rows of the error Jacobian
        m_num_rows_Jac;
        
        % Number of columns of the error Jacobian
        m_num_cols_Jac;
        
        %Search direction
        m_search_direction;
        
        % Weighted error column matrix
        m_werr_val;
        
        % Sparse weighted error Jacobian
        m_werr_Jac;
        
        % Sparse block-level error Jacobian filled with ones and zeros. This
        % represents the "shape" of the Jacobian (where it has nonzero
        % elements).
        m_werr_Jac_blocks;
        
        % Step length
        m_step_length;
    end
    
    properties
        % Parameters to be used by the optimization
        
        % Optimization scheme is usually either Gauss-Newton (GN) or
        % Levenberg-Marquardt. Though in theory we can add other methods such as
        % steepest descent or better methods.
        optimization_scheme = 'GN';
        
        % Linear solver. This can be QR, Cholesky, or some other powerful linear
        % solvers.
        linear_solver = 'QR';
        
        % Boolean flag to indicate whether COLAMD is to be used or not
        use_colamd = true;
    end
    
    properties (SetAccess = protected)
        % The graph to optimizer over. Should be set in the constructor. Once
        % set, cannot be changed.
        factor_graph = [];
    end
end