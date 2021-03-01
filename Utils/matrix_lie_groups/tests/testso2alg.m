function so2algTests = testso2alg
%TESTSO2ALG Function-based testing for so2alg.
% To run tests:
%     results = runtests('testso2alg.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    so2algTests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to so2alg class.
    addpath('../');
    
    % Set fixture values.
    theta = pi / 16;
    element_so2alg = [0, -theta; theta, 0];
    element_so2alg_adj = 0;
    element_SO2 = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    
    % Assign fixture values.
    testCase.TestData.theta = theta;
    testCase.TestData.element_so2alg = element_so2alg;
    testCase.TestData.element_so2alg_adj = element_so2alg_adj;
    testCase.TestData.element_SO2 = element_SO2;
end

% Adjoint
function testAdjoint(testCase)
    % Test Lie algebra input
    actSolution = so2alg.adjoint(testCase.TestData.element_so2alg);
    expSolution = testCase.TestData.element_so2alg_adj;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^1 input
    actSolution = so2alg.adjoint(testCase.TestData.theta);
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    actSolution = so2alg.decompose(testCase.TestData.element_so2alg);
    expSolution = testCase.TestData.theta;
    verifyEqual(testCase, actSolution, expSolution);
end

% Exp map
function testExpMap(testCase)   
    % Test Lie algebra input
    actSolution = so2alg.expMap(testCase.TestData.element_so2alg);
    expSolution = testCase.TestData.element_SO2;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^1 input
    actSolution = so2alg.expMap(testCase.TestData.theta);
    verifyEqual(testCase, actSolution, expSolution); 
end

% Synthesize
function testSynthesize(testCase)   
    actSolution = so2alg.synthesize(testCase.TestData.theta);
    expSolution = testCase.TestData.element_so2alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Vee
function testVee(testCase)   
    actSolution = so2alg.vee(testCase.TestData.element_so2alg);
    expSolution = testCase.TestData.theta;
    verifyEqual(testCase, actSolution, expSolution);
end

% Wedge
function testWedge(testCase)   
    actSolution = so2alg.wedge(testCase.TestData.theta);
    expSolution = testCase.TestData.element_so2alg;
    verifyEqual(testCase, actSolution, expSolution);
end

