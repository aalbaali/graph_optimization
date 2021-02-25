%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a demo of using graphs with Nodes and Edges. I'll be using the
%   NodeR2 and EdgeR2R2 classes.
%
%   Amro Al Baali
%   24-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

addpath('Nodes\');
addpath('Factors\');
addpath('FactorGraph\');

% Create a factor graph
fg = FactorGraph();

% Add a Pose node
fg.addVariableNode( NodeR2( [1; 2]), "P");
% Add another pose
fg.addVariableNode( NodeR2( [5; 3]), "P");

% Add a landmark node
fg.addVariableNode( NodeR2( [0; 0]), "L");

% Add edges between variables
fg.addFactorNode( FactorR2R2(), 'name', "F", 'node_names', ["P_1", "P_2"]);
fg.addFactorNode( FactorR2R2(), 'name', "F", 'node_names', ["P_1", "L_1"]);
% fg.addFactorNode( FactorR2R2, "F", 'end_nodes_names', ["P_2", "L_1"]);

%% Another way to build the graph
% Let's build this factor graph
%
%   X1 --- X2 --- X3
%
fg = FactorGraph( 'verb', 1);

% Build the edge right away. Make sure to delete it later to avoid changing the
% internal values (since it's a reference)
factor = FactorR2R2( 'end_node', { NodeR2( [0; 0]), NodeR2( [1; 0])});

% Add factor to graph
fg.addFactorNode( factor);

% Add another pose
fg.addVariableNode( NodeR2());

% Connect Pose 2 to pose 3
fg.addFactorNode( FactorR2R2(), 'node_names', ["X_2", "X_3"]);

% Plot factor graph.
close all;
h = plot(fg.G, 'EdgeAlpha',0.7, 'Marker', 'o', 'MarkerSize', 3, ...
    'Layout', 'force', 'LineWidth', 1.0);
% Variable node indices
idx_vars = find( strcmp( G.Nodes.Class, "Variable"));
% Factor node indices
idx_factors = find( strcmp( G.Nodes.Class, "Factor"));

% Highlight Variabls
highlight( h, idx_vars, 'NodeColor', matlabColors( 'blue'), 'MarkerSize', 10,...
    'NodeLabelColor',matlabColors('blue'), 'NodeFontSize', 12);
% Highlight Factors
highlight( h, idx_factors, 'NodeColor', 'k', 'MarkerSize', 5);

