%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Unit tests for the NodeR2 class.
%
%   Amro Al Baali
%   23-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function testResults = testNodeR2
    % Add paths to nodes
    addpath( '../Nodes/');
    testResults = functiontests( localfunctions);
end

% Node type should be access statically
function testTypeStatic( testCase)
    exp_output = "NodeR2";
    act_output = NodeR2.type;
    
    assertTrue( testCase, strcmp( exp_output, act_output));
end

% Node type should be access internally
function testTypeInternal( testCase)
    % Instantiate object
    node_R2 = NodeR2();
    
    exp_output = "NodeR2";
    act_output = node_R2.type;
    
    assertTrue( testCase, strcmp( exp_output, act_output));
end

% Initial value should be nans
function testInitialValue( testCase)
    % Instantiate object
    node_R2 = NodeR2();
    
    exp_output = nan;
    act_output = node_R2.value;
        
    out = all( size( act_output) == size( exp_output)) && ...
        isnan( act_output);
    assertTrue( testCase, out);
end

% Value setter and getter tested
function testValueSetterAndGetter( testCase)
    % Instantiate object
    node_R2 = NodeR2();
    
    exp_output = rand( 2, 1);
    node_R2.value = exp_output;
    
    act_output = node_R2.value;
        
    out = all( size( act_output) == size( exp_output)) && ...
        all(~isnan( act_output));
    assertTrue( testCase, out);
end


% oplus static
function testOplusStatic( testCase)
    % Instantiate object
    n1 = rand( 2, 1);
    n2 = rand( 2, 1);
    
    exp_output = n1 + n2;    
    act_output = NodeR2.oplus( n1, n2);
        
    assertEqual( testCase, exp_output, act_output);    
end