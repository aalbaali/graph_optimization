%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a demo of using the NodeR2 and EdgeR2R2.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Addpaths
addpath( 'Nodes\');
addpath( 'Edges\');

clear all;
close all;

% Construct the A, B, and L matrices
A = [0, 1; -1, -1];
B = [0; 1];
L = [ B, eye( 2)];
params = struct('A', A, 'B', B, 'L', L);

% For this system, define a new constructor
Edge = @(varargin) EdgeR2R2('params', params, varargin{:});

% This lambda function would REQUIRE the specification of an ID
% Edge = @(id, varargin) EdgeR2R2('params', params, 'id', id, varargin{:});

% Specify the measurement
u = 1;

% Specify covariance
Sigma = 1e-1 * eye( 3);

% Instantiate the two poses (nodes)
X1 = NodeR2( [ 0; 0]);
X2 = NodeR2( [ 1; 2]);

% Construct the edges between the two poses.
%   Pass in the two nodes to the constructor (optional)
%   Pass in the measurement to the constructor (optional)
%   Pass in the rv covariance to the constructor (optional)
edge_1 = Edge( 'endNodes', { X1, X2}, 'meas', u, 'cov', Sigma);
% Alternatively, the end nodes can be set by calling 
%   edge_1.setEndNodes( { X1, X2}); 
% or
%   edge_1.setEndNode( 1, X1); 
%   edge_1.setEndNode( 2, X2);
%
% Alternatively, the measurements can be set using
%   edge_1.setMeas( u);
%
% Alternatively, the covariance can be set using
%   edge_1.set_cov_mat( Sigma);


% Compute the error value and the weighted error
err_val = edge_1.err_val;
% Compute weighted error value
werr_val = edge_1.werr_val;

% Compare chi2 values analytically
d_m = ([1; 2] - (A * [0; 0] + B * 1))' * ((L * Sigma * L') \ ([1; 2] - (A * [0; 0] + B * 1)));
d_medge = edge_1.chi2;