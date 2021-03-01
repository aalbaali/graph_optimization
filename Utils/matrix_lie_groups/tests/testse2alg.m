function se2algTests = testse2alg
%TESTSE2ALG Function-based testing for se2alg.
% To run tests:
%     results = runtests('testse2alg.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    se2algTests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to se2alg class.
    addpath('../');
    
    % Set fixture values.
    xi_theta = pi / 12;
    assert(abs(xi_theta) > MLGUtils.tol_small_angle);
    xi_r = [1, 2].';
    element_se2alg = [ so2alg.synthesize(xi_theta), xi_r ;
                       zeros(1, 3)                      ];
    element_se2alg_column = [xi_theta; xi_r];
    element_se2alg_adj = [ zeros(1, 3)            ;
                           xi_r(2), 0, -xi_theta  ;
                           -xi_r(1), xi_theta, 0 ];
    J = SO2.computeJLeft(xi_theta);
    element_SE2 = [ so2alg.expMap(xi_theta), J * xi_r ;
                   0, 0, 1                           ];
    abs_tol = 1e-14;
    
    % Assign fixture values.
    testCase.TestData.xi_theta = xi_theta;
    testCase.TestData.xi_r = xi_r;
    testCase.TestData.element_se2alg = element_se2alg;
    testCase.TestData.element_se2alg_column = element_se2alg_column;
    testCase.TestData.element_se2alg_adj = element_se2alg_adj;
    testCase.TestData.element_SE2 = element_SE2;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)
    % Test Lie algebra input
    actSolution = se2alg.adjoint(testCase.TestData.element_se2alg);
    expSolution = testCase.TestData.element_se2alg_adj;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^3 input
    actSolution = se2alg.adjoint(testCase.TestData.element_se2alg_column);
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)
    [actSolution_1, actSolution_2] = ...
        se2alg.decompose(testCase.TestData.element_se2alg);
    expSolution_1 = testCase.TestData.xi_theta;
    expSolution_2 = testCase.TestData.xi_r;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
end

% Exp map
function testExpMap(testCase)   
    % Test Lie algebra input
    actSolution = se2alg.expMap(testCase.TestData.element_se2alg);
    expSolution = testCase.TestData.element_SE2;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^3 input
    actSolution = se2alg.expMap(testCase.TestData.element_se2alg_column);
    verifyEqual(testCase, actSolution, expSolution); 
end

% Synthesize
function testSynthesize(testCase)   
    actSolution = se2alg.synthesize(testCase.TestData.element_se2alg_column);
    expSolution = testCase.TestData.element_se2alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Vee
function testVee(testCase)   
    actSolution = se2alg.vee(testCase.TestData.element_se2alg);
    expSolution = testCase.TestData.element_se2alg_column;
    verifyEqual(testCase, actSolution, expSolution);
end

% Wedge
function testWedge(testCase)   
    actSolution = se2alg.wedge(testCase.TestData.element_se2alg_column);
    expSolution = testCase.TestData.element_se2alg;
    verifyEqual(testCase, actSolution, expSolution);
end

