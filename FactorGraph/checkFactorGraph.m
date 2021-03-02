function isready = checkFactorGraph( factor_graph, varargin)
    % CHECKFACTORGRAPH( factor_graph) checks whether a factor_graph is
    % ready for optimization. This means that each node
    %   1. has an initial value (if it's a variable node), 
    %   2. has a measurement (if it's a factor node), and
    %   3. has a covariance (if it's a factor node).
    % It does not check whether a factor returns a valid error function
    % or if it's missing some parameters. This may be done in the
    % future.
    %
    % CHECKFACTORGRAPH( factor_graph, verb) does the same as above, but
    % verbosity is changed. VERB can be be 0 (off) or 1 (on). Default
    % value is 1.

    isValidFactorGraph = @( fg) isa( factor_graph, 'FactorGraph');
    isValidVerb        = @( verb) isscalar( verb) && ( verb == 0 ...
        || verb == 1);

    defaultVerb = 1;

    p = inputParser;

    addRequired( p, 'factor_graph', isValidFactorGraph);
    addOptional( p, 'verb', defaultVerb, isValidVerb);

    parse( p, factor_graph, varargin{ :});

    verb = p.Results.verb;

    % Turn off all warnings. (It'll be turned on by the end of the
    % script)
    warning('off', 'all');

    % 1. Check variable nodes
    % Get variable node names
    node_names = factor_graph.getVariableNodeNames();

    % Go over each each variable node and check if value is initialized
    values_initialized = cellfun( @(c) ~any( isnan( ...
        factor_graph.node(c).value), 'all'), ...
            node_names );

    % If some values are not initialized, list the nodes
    if verb && ~ all( values_initialized)
        disp( 'The variable nodes')
        cellfun(@(c) fprintf('\t%s\n', c), ...
            node_names( ~ values_initialized));                
        disp('are not initialized');
    end

    isready = all( values_initialized);

    % 2. Check factor nodes
    factor_names = factor_graph.getFactorNodeNames();

    % Go over each factor node and check if measurement is initialized
    factors_includeMeas = cellfun( @(c) ~any( isnan( ...
        factor_graph.node(c).meas), 'all'), ...
            factor_names );

    % If some measurements are not initialized, list the nodes
    if verb &&  ~ all( factors_includeMeas)
        disp( 'The factor nodes')
        cellfun(@(c) fprintf('\t%s\n', c), ...
            factor_names( ~ factors_includeMeas));                
        disp('do not include measurements');
    end
    isready = isready && all( factors_includeMeas);

    % 3. Check the error covariances Go over each factor node and check
    % if error covariance is initialized
    factors_includeErrCov = cellfun( @(c) ~any( isnan( ...
        factor_graph.node(c).err_cov), 'all'), ...
            factor_names );

    % List the factor nodes without error covariances
    if verb && ~ all( factors_includeErrCov)
        disp( 'The factor nodes')
        cellfun(@(c) fprintf('\t%s\n', c), ...
            factor_names( ~ factors_includeErrCov));                
        disp('do not include error covariances');
    end
    isready = isready && all( factors_includeErrCov);

    if verb && isready
        fprintf("Factor graph ready for optimization\n");
    end
    % Turn on warnings back on
    warning('on', 'all');
end