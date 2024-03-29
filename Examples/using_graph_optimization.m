%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This example demonstrates how to use the graph optimizer class.
%
%   Amro Al Baali
%   26-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Build the factor graph from the other example
building_graph_batch_R2;

%% Addpaths to optimizer
addpath( '..');
addpath( genpath( '../FactorGraph'));
addpath( '../Utils/');
%% Check if the factor graph is ready for optimization
% Call the static function. Set verbosity to 1.
checkFactorGraph( fg, 1);
keyboard();

% Add the missing measurements and covariances
fg.node("F_4").setMeas( 2 + 1e-3*rand());
fg.node("F_1").setCov( 1e-3 * eye( 2));

keyboard();
% Check again
GraphOptimizer.checkFactorGraph( fg, 1);

%% Using the graph optimizer
go = GraphOptimizer( fg);

% Initialize internal parameters and Jacobian (does not fill in the Jacobian
% values).
go.initializeInternalParameters();

% View the block-level Jacobian
spy( go.m_werr_Jac_blocks);


%% Another factor graph
rng('default');
% Factor graph
fg = FactorGraph();
% Add nodes (3 nodes)
fg.addVariableNode( NodeR2( [ 0; 0] + randn( 2, 1)));
fg.addVariableNode( NodeR2( [ 0; 1] + randn( 2, 1)));
fg.addVariableNode( NodeR2( [ 1; 0] + randn( 2, 1)));

% Prior Factor
%   parameters
params_prior = struct('C', eye( 2), 'L', diag( [1, 1e0]));
%   Factor
factor = FactorR2( 'params', params_prior);
factor.setMeas( zeros( 2, 1));
factor.setCov( 1 * eye( 2));
factor.setEndNode( 1, fg.node("X_1"));
%   Add to factor graph
fg.addFactorNode( factor);

% Add process model factors
% 	Parameters
params_pm = struct('A', [0,1;-1,-1], 'B', [0;1], 'L', eye( 2));
%   Factors
factor = FactorR2R2('params', params_pm);
factor.setMeas( 1);
factor.setCov( eye( 2));
factor.setEndNodes( fg.node("X_1"), fg.node("X_2"));
%   Add to factor graph
fg.addFactorNode( factor);

% Add another process model factor
%   Factors
factor = FactorR2R2('params', params_pm);
factor.setMeas( 1);
factor.setCov( eye( 2));
factor.setEndNodes( fg.node("X_2"), fg.node("X_3"));
%   Add to factor graph
fg.addFactorNode( factor);

% % Plot graph for visualization
% plot( fg.G);

% Set up the graph optimization
go = GraphOptimizer( fg);

go.setOptimizationScheme('gn');
go.setLinearSolver( 'qr');
go.reorder_variables = true;
go.reorder_element_variables = false;
go.verbosity = 1;

% Optimize
[a, b] = go.optimize();

%% Factor graph using Rn
rng('default');

% Create lambda functions for the nodes
PoseNode = @( varargin) NodeRn( 2, varargin{ :});
% 	Parameters
params_odom = struct('A', [0,1;-1,-1], 'B', [0;1], 'L', eye( 2));
OdomFactor = @( varargin) FactorRnRn( 'params', params_odom, varargin{ :});
PriorFactor = @( varargin) FactorRn( 'params', struct('C', eye( 2), 'L', ...
    eye( 2)), varargin{ : });
% Factor graph
fg = FactorGraph();
% Add nodes (3 nodes)
fg.addVariableNode( PoseNode( [ 0; 0] + randn( 2, 1)));
fg.addVariableNode( PoseNode( [ 0; 1] + randn( 2, 1)));
fg.addVariableNode( PoseNode( [ 1; 0] + randn( 2, 1)));

% Prior Factor
factor = PriorFactor( 'meas', zeros( 2, 1), 'cov', eye( 2));
factor.setEndNode( 1, fg.node("X_1"));
%   Add to factor graph
fg.addFactorNode( factor);

% Add process model factors

%   Factors
factor = OdomFactor( 'meas', 1, 'cov', eye( 2));
factor.setEndNodes( fg.node("X_1"), fg.node("X_2"));
%   Add to factor graph
fg.addFactorNode( factor);

% Add another process model factor
%   Factors
factor = OdomFactor( 'meas', 1, 'cov', eye( 2));
factor.setEndNodes( fg.node("X_2"), fg.node("X_3"));
%   Add to factor graph
fg.addFactorNode( factor);

% Set up the graph optimization
go = GraphOptimizer( fg);

go.setOptimizationScheme('gn');
go.setLinearSolver( 'qr');
go.reorder_variables = true;
go.reorder_element_variables = false;
go.verbosity = 1;

% Optimize
[a, b] = go.optimize();