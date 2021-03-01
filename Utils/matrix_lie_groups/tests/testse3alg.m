function se3algTests = testse3alg
%TESTSE3ALG Function-based testing for se3alg.
% To run tests:
%     results = runtests('testse3alg.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    se3algTests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to se3alg class.
    addpath('../');
    
    % Set fixture values.
    xi_phi = [0.1, pi / 14, -0.54].';
    angle = sqrt(xi_phi.' * xi_phi);
    assert(angle > MLGUtils.tol_small_angle);
    xi_r = [0.05, -0.3, 0.276].';
    element_se3alg = [ so3alg.synthesize(xi_phi), xi_r ;
                       zeros(1, 4)                    ];
    element_se3alg_column = [xi_phi; xi_r];
    element_se3alg_adj = [ so3alg.cross(xi_phi), zeros(3)            ;
                           so3alg.cross(xi_r), so3alg.cross(xi_phi) ]; 
    J = SO3.computeJLeft(xi_phi);
    element_SE3 = [ so3alg.expMap(xi_phi), J * xi_r ;
                    zeros(1, 3), 1                 ];
    
    % Assign fixture values.
    testCase.TestData.xi_phi = xi_phi;
    testCase.TestData.xi_r = xi_r;
    testCase.TestData.element_se3alg = element_se3alg;
    testCase.TestData.element_se3alg_column = element_se3alg_column;
    testCase.TestData.element_se3alg_adj = element_se3alg_adj;
    testCase.TestData.element_SE3 = element_SE3;
end

% Adjoint
function testAdjoint(testCase)
    % Test Lie algebra input
    actSolution = se3alg.adjoint(testCase.TestData.element_se3alg);
    expSolution = testCase.TestData.element_se3alg_adj;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^6 input
    actSolution = se3alg.adjoint(testCase.TestData.element_se3alg_column);
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)
    [actSolution_1, actSolution_2] = ...
        se3alg.decompose(testCase.TestData.element_se3alg);
    expSolution_1 = testCase.TestData.xi_phi;
    expSolution_2 = testCase.TestData.xi_r;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
end

% Exp map
function testExpMap(testCase)   
    % Test Lie algebra input
    actSolution = se3alg.expMap(testCase.TestData.element_se3alg);
    expSolution = testCase.TestData.element_SE3;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^6 input
    actSolution = se3alg.expMap(testCase.TestData.element_se3alg_column);
    verifyEqual(testCase, actSolution, expSolution); 
end

% Synthesize
function testSynthesize(testCase)   
    actSolution = se3alg.synthesize(testCase.TestData.element_se3alg_column);
    expSolution = testCase.TestData.element_se3alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Vee
function testVee(testCase)   
    actSolution = se3alg.vee(testCase.TestData.element_se3alg);
    expSolution = testCase.TestData.element_se3alg_column;
    verifyEqual(testCase, actSolution, expSolution);
end

% Wedge
function testWedge(testCase)   
    actSolution = se3alg.wedge(testCase.TestData.element_se3alg_column);
    expSolution = testCase.TestData.element_se3alg;
    verifyEqual(testCase, actSolution, expSolution);
end

