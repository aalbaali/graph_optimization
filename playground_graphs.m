%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a demo of using graphs with Nodes and Edges. I'll be using the
%   NodeR2 and EdgeR2R2 classes.
%
%   Amro Al Baali
%   24-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
fg.addFactorNode( FactorR2R2(), "F", 'end_nodes_names', ["P_1", "P_2"]);
fg.addFactorNode( FactorR2R2(), "F", 'end_nodes_names', ["P_1", "L_1"]);
% fg.addFactorNode( FactorR2R2, "F", 'end_nodes_names', ["P_2", "L_1"]);