%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This is a demo of using the NodeR2 and EdgeR2R2.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

% Construct the A, B, and L matrices
A = [0, 1; -1, -1];
B = [0; 1];
L = [ B, eye( 2)];

% Specify the measurement
u = 1;

% Specify covariance
Sigma = 1e-1 * eye( 3);

% Instantiate the two poses (nodes)
X1 = NodeR2();
X2 = NodeR2();

% Construct the edges between the two poses
edge_x1x2 = EdgeR2R2();

% Specfiy the process parameters
edge_x1x2.A = A;
edge_x1x2.B = B;
edge_x1x2.L = L;

% Specify the information matrix
% Add the two poses to the edges
edge_x1x2.setEndNodes( X1, X2);
% Add the measurement
edge_x1x2.meas = u;
% Add the covariance on the random variables
edge_x1x2.set_cov_mat( Sigma);

% Set the values of the nodes (they're passed by reference so they'll update
% inside the edges). But I wouldn't recommend updating the values using such
% method.
X1.value = [0; 0];
X2.value = [1; 2];

% Compute the error value and the weighted error
err_val = edge_x1x2.err_val;
% Compute weighted error value
werr_val = edge_x1x2.werr_val;

% Compare analytically
d_m = ([1; 2] - (A * [0; 0] + B * 1))' * ((L * Sigma * L') \ ([1; 2] - (A * [0; 0] + B * 1)));
d_edge = werr_val' * werr_val;