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
%% Check if the factor graph is ready for optimization
% Call the static function. Set verbosity to 1.
GraphOptimizer.checkFactorGraph( fg, 1);
keyboard();

% Add the missing measurements and covariances
fg.node("F_4").setMeas( rand());
fg.node("F_1").setCov( eye( 2));

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