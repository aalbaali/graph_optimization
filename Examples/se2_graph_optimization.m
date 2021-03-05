%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Demonstrating batch optimizaiton using SE2
%
%   Amro Al Baali
%   1-Mar-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all;
close all;

if true
    % Add necessary paths
    run ../paths.m;

    % Number of poses
    K = 1e3;

    dt = 1;

    % Prior 
    X0 = eye( 3);
    P0 = 1e-3 * eye( 3);

    % Odometery
    u_arr = [ 1e-1 * ones( 1, K - 1); 1 * ones( 1, K - 1); zeros( 1, K -1)];
    Q     = 1e-1 * eye( 3);

    rng('default');

    %% Dead-reckoning (true) solution
    X_odom( :, :, 1) = X0;
    for kk = 2 : K
        X_odom(:, :, kk) = X_odom( :, :, kk - 1) ...
            * se2alg.expMap( dt * u_arr(:, kk - 1));
    end

    %% Set up the factor graph
    disp('Building factor graph');
    tic();
    % Error definition
    error_definition = 'left-invariant';
    % Create lambda functions for the nodes
    PoseNode = @( varargin) NodeSE2( error_definition, varargin{ :});
    % Process model factor
    FactorPM = @( varargin) FactorSE2SE2( error_definition, 'params', ...
            struct( 'dt', dt), varargin{ :});

    % Factor graph
    fg = FactorGraph();
    % Add nodes and randomly assign values
    fg.addVariableNode( PoseNode( se2alg.expMap( randn( 3, 1))));

    % Prior factor
    priorFactor = FactorSE2( 'meas', X0, 'cov', P0);
    priorFactor.setErrorDefinition( error_definition);
    priorFactor.setEndNode( 1, fg.node("X_1"));

    fg.addFactorNode( priorFactor);
    clear priorFactor;

    % Odometry factors
    for kk = 1 : K - 1
        fg.addVariableNode( PoseNode( se2alg.expMap( randn( 3, 1))));

        odomFactor = FactorPM( 'meas', u_arr(:, kk), 'cov', Q);
        odomFactor.setEndNodes( fg.node("X", kk), fg.node("X", kk + 1));
        fg.addFactorNode( odomFactor);

        pause(1e-2);
    end
    clear odomFactor;
    toc();
    fprintf('Done\n\n')
end
%% Optimization
% keyboard();
tic();
% Set factor graph to release mode
fg.setToReleaseMode();
% Set up the graph optimization
go = GraphOptimizer( fg);

go.setOptimizationScheme('gn');
go.setLinearSolver( 'qr');
go.reorder_variables = true;
go.reorder_element_variables = false;
go.verbosity = 1;

% Optimize
go.optimize();
toc();