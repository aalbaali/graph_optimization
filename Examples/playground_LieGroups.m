%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Trying out the SE2 factor and variable nodes.
%
%   Amro Al Baali
%   01-Mar-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

addpath( genpath( '../FactorGraph'));
addpath( '../Utils');
addpath( '..');

rng('default');

%% Set up an SE2 node
node_X = NodeSE2( 'left-invariant');
% Set up its value
node_X.setValue( se2alg.expMap( randn( 3, 1)));
node_X.setErrorDefinition( 'left-invariant');
%% Set up a unary SE2 factor (like a prior)
prior_factor = FactorSE2( 'meas', se2alg.expMap(randn( 3, 1)), 'cov', eye( 3));
% Set the end node
prior_factor.setErrorDefinition( node_X.error_definition);
prior_factor.setEndNode( 1, node_X);


% Comparing Jacobians.
%   Lambda function that computes the error value after a perturbation. It uses
%   the static errorFunction 
errFun = @( xi) FactorSE2.errorFunction( {NodeSE2( node_X.error_definition, ...
    node_X + xi) }, prior_factor.meas, prior_factor.params);
% Compute errFun Jacobian
Jac_fd = derivative_finite( errFun, zeros( 3, 1), 1e-6);
% Compare with compute Jacobian
err_jacs = prior_factor.werr_Jacobians{1};

all( abs( Jac_fd - err_jacs) < 1e-3, 'all');

%% Unary SE2 factor (GPS measurement)
params = struct('C_left', [eye(2),zeros(2,1)], 'C_right', [0;0;1]);
factor_meas_gps = FactorSE2Meas( 'params', params);
factor_meas_gps.setErrorDefinition( node_X.error_definition);
factor_meas_gps.setMeas( [1; 2]);
factor_meas_gps.setCov( eye( 2));
factor_meas_gps.setEndNode( 1, node_X);

errFun = @( xi) FactorSE2Meas.errorFunction( {NodeSE2( node_X.error_definition, ...
    node_X + xi) }, factor_meas_gps.meas, factor_meas_gps.params);

% Compute errFun Jacobian
Jac_fd = derivative_finite( errFun, zeros( 3, 1), 1e-6);
% Compare with compute Jacobian
err_jacs = factor_meas_gps.werr_Jacobians{1};

all( abs( Jac_fd - err_jacs) < 1e-3, 'all')