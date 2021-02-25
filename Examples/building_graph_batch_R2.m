%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This example demonstrates how to build a factor graph for a batch problem.
%
%   The problem presented here is on a mass-spring-damper system with some
%   exteroceptive measurements. The pose graph looks as follows
%   X1 --*-- X2 --*-- X3
%    \              /
%        \       /
%            *
%   The asterisks * indicate a factor.
%   
%   At this point in time, I didn't implement a unary factors. So I'm not
%   implementing priors on the poses. Nor am I trying to solve the batch
%   problem. I'll just build the factor graph and plot it. In the future, there
%   should be a customized graph plotter.
%
%   Amro Al Baali
%   25-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

%% Add paths
addpath( '../Nodes');
addpath( '../Factors');
addpath( '../FactorGraph');

%% System parameters
% This is a second order linear system. Set up the matrices for the system
%   x_k = A * x_km1 + B * u_km1 + L * w_km1, 
% where w_km1 is the process noise with zero-mean and covariance Q. It's size is
% a [3 x 1] column matrix. The first element of w_km1 is the noise on the
% control input u_km1.

%   System matrix
A = [ 0, 1; -1 -1];
%   Control matrix
B = [ 0; 1];
%   Jacobian of process model w.r.t. process noise. Note that since the first
%   element of the noise column matrix w_km1 is noise on control input u_km1,
%   then the Jacobian of the process model w.r.t. the control noise is B.
L = [ B, eye( 2)];

% Store in params struct
params = struct( 'A', expm( A), 'B', B, 'L', L);

% Variance on all noises (including the noise on the control input)
Q = 1e-1 * eye( 3);

%% Set up variable and factor node constructore.
%   Since this is a linear system, then the system matrices (A, B, and L) are
%   constant and do not change over time. Furthermore, I assume that the
%   covariance Q is also constant. So I'll set up a FactorR2R2 constructor that
%   constructs a factor node using the same matrices

% Process model factor/odometry. We'll add another loop closure factor. It has a
% different system matrix A and B.
Factor_odom = @( varargin) FactorR2R2('cov', Q, 'params', params, varargin{ :});
Node   = @( varargin) NodeR2( varargin{ :});

%% Set up factor graph
% Create a factor graph object. Set verbosity to 1 to see the nodes and factors
% being added.
fg = FactorGraph( 'verb', 1);

for kk = 1 : 3
    % Add nodes. We'll set up the initial estimates later.
    fg.addVariableNode( Node( rand( 2, 1)));
end

% Add odometry factors (process model)
for kk = 1 : 2
    % Set up random measurements
    factor = Factor_odom( 'meas', rand());
    % Set up end nodes
    factor.setEndNodes( fg.node( "X", kk), fg.node( "X", kk + 1));
    fg.addFactorNode( factor);
end
% Finally, add a loop closure factor
% System matrices
params_lc = struct( 'A', eye( 2), 'B', eye( 2), 'L', [zeros(2,1), eye(2)]);
factor_lc = FactorR2R2( 'params', params_lc, 'cov', 1e-2 * eye( 3));
% Set end nodes
factor_lc.setEndNodes( fg.node("X_1"), fg.node("X_3"));
% Add LC factor to graph
fg.addFactorNode( factor_lc);

%% Plot factor graph.
close all;
h = plot(fg.G, 'EdgeAlpha',0.7, 'Marker', 'o', 'MarkerSize', 3, ...
    'Layout', 'force', 'LineWidth', 1.0);
% Variable node indices
idx_vars = find( strcmp( fg.G.Nodes.Class, "Variable"));
% Factor node indices
idx_factors = find( strcmp( fg.G.Nodes.Class, "Factor"));

% Highlight Variabls
highlight( h, idx_vars, 'NodeColor', matlabColors( 'blue'), 'MarkerSize', 10,...
    'NodeLabelColor',matlabColors('blue'), 'NodeFontSize', 12);
% Highlight Factors
highlight( h, idx_factors, 'NodeColor', 'k', 'MarkerSize', 5);


