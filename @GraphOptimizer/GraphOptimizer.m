classdef GraphOptimizer < handle
    %GRAPHOPTIMIZER takes a factor graph and optimizes over its set of
    %variables. 
    
    methods 
        function obj = GraphOptimizer( varargin)
            %GRAPHOPTIMIZER 
            %   GRAPHOPTIMIZER( factor_graph) stores the factor_graph
            %   (reference).
            %
            %   GRAPHOPTIMIZER( factor_graph, 'verb', verbosity) stores the factor graph
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
            addParameter( p, 'verb', defaultVerb, isValidVerb);
            
            parse(p, varargin{ :});
            
            % Store factor graph
            obj.factor_graph = p.Results.factor_graph;
            obj.verbosity    = p.Results.verb;
        end
        
        function obj = setOptimizationScheme( obj, optimization_scheme)
            % SETOPTIMIZATIONSCHEME( optimization_scheme) sets the optimizaition
            % scheme (if it's a valid one)
            
            % Convert to lower case
            optimization_scheme = lower( optimization_scheme);
            
            % Check if solver is in the list
            isValidOptimizationScheme = @( opt) any( validatestring( opt, ...
                obj.valid_optimization_schemes));           
            p = inputParser;
            addRequired( p, 'opt_scheme', isValidOptimizationScheme);
            
            parse( p, optimization_scheme);
            
            obj.optimization_scheme = p.Results.opt_scheme;
            
        end
        function obj = setLinearSolver( obj, lin_solver)
            %SETLINEARSOLVER set the linear solver.
            
            % Convert to lower case
            lin_solver = lower( lin_solver);
            
            % Check if solver is in the list
            isValidLinSolver = @( solver) any( validatestring( solver, ...
                obj.valid_linear_solvers));           
            p = inputParser;
            addRequired( p, 'lin_solver', isValidLinSolver);
            parse( p, lin_solver)
            
            obj.linear_solver = p.Results.lin_solver;
        end
        
        function node_obj = node( obj, node_name)
            %NODE( node_name) returns the node object in the graph. It simply
            %calls the NODE method from the factor_graph object.
            node_obj = obj.factor_graph.node( node_name);
        end
        
        % Main optimization function. Has the main loop.
        [ success, optim_stats] = optimize( obj);
        
        function obj_val = getObjectiveValue( obj)
            % GETOBJECTIVEVALUE returns the value of the objective function
            % using the current m_werr_val value.
            obj_val = (1/2) * sum( obj.m_werr_val .^2);
        end
    end
    
    methods (Access = private)
        % TEMPORARILY set to public for debugging
        
        % Initialize matrices constructs empty matrices of appropriate sizes
        initializeInternalParameters( obj);
        
        % Reorder columns
        reorderVariables( obj);

        % Computes search direction and stores it in a private object in this
        % class instead of passing it by value.
        computeSearchDirection( obj);
        
        % Builds the weighted error value column matrix and the full Jacobian
        % and stores them in private members of the class.
        % sparse Jacobian.
        computeWerrValueAndJacobian( obj, varargin);
        
        % Method to compute the weighted error only (without the Jacobian)
        [werr_val, wobj_val] = computeWerr( obj);
        
        % Computes step length for the given search direction. For now, it'll be
        % Armijo rule. In the future, it could be updated to Wolfe-Powell, or a
        % better method.
        computeStepLength( obj);
                
        % Updates the graph object by incrementing the search direction and step
        % lengths into the innner nodes.
        updateGraph( obj, varargin);
        
        function obj = updateJacobianRowIndices( obj)
            % UPDATEJACOBIANROWINDICES() updates m_idx_Jac_rows which is the
            % first row of the Jacobian matrix for the list of factor node
            % variables.
            obj.m_idx_Jac_rows = cumsum( [ obj.m_info_factors.dim]) ...
                - [obj.m_info_factors.dim] + 1;
        end
        
        function obj = updateJacobianColIndices( obj)
            % UPDATEJACOBIANCOLINDICES() updates m_idx_Jac_cols which is the
            % first column of the Jacobian matrix for the list of variable node
            % variables.
            obj.m_idx_Jac_cols = cumsum( [ obj.m_info_variables.dof]) ...
                - [ obj.m_info_variables.dof] + 1;
        end
        
        function printf( obj, varargin)
            % A function that prints to the console based on verbosity
            switch obj.verbosity
                case 0                    
                case 1
                    fprintf( varargin{ :});
            end
        end
    end
    
    methods
        function out = get.m_search_direction( obj)
            % Output it in a column matrix            
            size_err = size( obj.m_search_direction);
            if size_err( 2) == 1 && size_err( 1) == obj.m_num_cols_Jac
                out = obj.m_search_direction;
            elseif size_err( 1) == 1 && size_err( 2) == obj.m_num_cols_Jac
                out = reshape( obj.m_search_direction , [], 1);
            else
                out = obj.m_search_direction;
            end
        end
        
        function out = get.m_werr_val( obj)
            % Output it in a column matrix            
            size_err = size( obj.m_werr_val);
            if size_err( 2) == 1 && size_err( 1) == obj.m_num_cols_Jac
                out = obj.m_werr_val;
            elseif size_err( 1) == 1 && size_err( 2) == obj.m_num_cols_Jac
                out = reshape( obj.m_werr_val , [], 1);
            else
                out = obj.m_werr_val;
            end
        end
        
        function set.reorder_variables( obj, val_in)
            % Check that it's a logical argument
            p = inputParser;
            addRequired( p, 'val_in', @(val_in) islogical( val_in));
            parse( p, val_in);
            obj.reorder_variables = p.Results.val_in;
        end
        
        function set.reorder_element_variables( obj, val_in)
            % Check that it's a logical argument
            p = inputParser;
            addRequired( p, 'val_in', @(val_in) islogical( val_in));
            parse( p, val_in);
            obj.reorder_element_variables = p.Results.val_in;
        end
        
        function set.verbosity( obj, verb_in)
            % Check that it's a logical argument
            p = inputParser;
            addRequired( p, 'verb_in', @(val_in) any( cellfun(@(c) ...
                c == verb_in, obj.valid_verbosity)));
            parse( p, verb_in);
            obj.verbosity = p.Results.verb_in;
        end
    end
    
    properties (SetAccess = protected)    
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
        % the same order as in m_info_variables
        m_idx_Jac_cols;
        
        % Array of Jacobian row index for each factor. The factors are in the
        % same order as in m_info_factors
        m_idx_Jac_rows;
        
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
        m_step_length = 1;

        % Optimization scheme is usually either Gauss-Newton (GN) or
        % Levenberg-Marquardt. Though in theory we can add other methods such as
        % steepest descent or better methods.
        optimization_scheme = 'GN';
        
        % Linear solver. This can be QR, Cholesky, or some other powerful linear
        % solvers.
        linear_solver = 'QR';
        
        % Optimization options:
        %   max_iterations  
        %       overall optimization maximum iterations
        %   max_armijo_iterations 
        %       Armijo (line search) maximum iteration (keep it small)
        %   alpha_0
        %       Initial step length (usually 1).
        %   beta 
        %       The step length multiplier (should be in the range (0, 1))
        %   sigma
        %       Used in Armijo condition. Values should be in the range (0, 1)
        %       (check (3.3) in Hoheisel-2018)
        %   tol_norm_obj_grad
        %       Tolerance on the norm of the objective function gradient.
        %       Perhaps this should depend on the number of design variables
        optim_params = struct('max_iterations', 1e2, 'beta', 0.6, ...
            'max_armijo_iterations', 15, 'sigma', 1e-4, 'stoppint_criterion',...
            1e-4, 'alpha_0', 1, 'tol_norm_obj_grad', 1e-5);
    end
    
    properties
        % Parameters to be used by the optimization
        
        % Boolean flag to indicate whether to reorder variables (block-wise).
        reorder_variables = true;
        
        % Boolean flag to reorded design variables at the element level (not
        % variable level)
        reorder_element_variables = false;
        
        % Verbosity. Default value is 1.
        verbosity = 1;
    end
    
    properties (SetAccess = protected)
        % The graph to optimizer over. Should be set in the constructor. Once
        % set, cannot be changed.
        factor_graph = [];
    end
    
    properties (Constant = true)
        % Valid linear solvers
        valid_linear_solvers = {'qr', 'cholesky'};
        
        % Valid optimization schemes
        valid_optimization_schemes = { 'gn', 'lm'};
        
        valid_verbosity = { 0, 1};
    end
end