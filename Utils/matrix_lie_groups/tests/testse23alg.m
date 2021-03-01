function se23algTests = testse23alg
%TESTSE23ALG Function-based testing for se23alg.
% To run tests:
%     results = runtests('testse23alg.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    se23algTests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to se23alg class.
    addpath('../');
    
    % Set fixture values.
    xi_phi = [0.1, pi / 14, -0.54].';
    angle = sqrt(xi_phi.' * xi_phi);
    % Have verified behaviour for angle > pi, so restrict positive range.
    assert(angle > MLGUtils.tol_small_angle && angle <= pi);
    xi_v = [1.2, -3.64, 0.7].';
    xi_r = [0.05, -0.3, 0.276].';
    element_se23alg = [ so3alg.synthesize(xi_phi), xi_v, xi_r ;
                        zeros(2, 5)                          ];
    element_se23alg_column = [xi_phi; xi_v; xi_r];
    element_se23alg_adj = [ so3alg.wedge(xi_phi), zeros(3, 6)                   ;
                            so3alg.wedge(xi_v), so3alg.wedge(xi_phi), zeros(3)  ;
                            so3alg.wedge(xi_r), zeros(3), so3alg.wedge(xi_phi) ];
    J = SO3.computeJLeft(xi_phi);
    element_SE23 = [ so3alg.expMap(xi_phi), J * xi_v, J * xi_r ;
                     zeros(2, 3), eye(2)                       ];
    abs_tol = 1e-14;
    
    % Assign fixture values.
    testCase.TestData.xi_phi = xi_phi;
    testCase.TestData.xi_v = xi_v;
    testCase.TestData.xi_r = xi_r;
    testCase.TestData.element_se23alg = element_se23alg;
    testCase.TestData.element_se23alg_column = element_se23alg_column;
    testCase.TestData.element_se23alg_adj = element_se23alg_adj;
    testCase.TestData.element_SE23 = element_SE23;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)
    % Test Lie algebra input
    actSolution = se23alg.adjoint(testCase.TestData.element_se23alg);
    expSolution = testCase.TestData.element_se23alg_adj;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^9 input
    actSolution = se23alg.adjoint(testCase.TestData.element_se23alg_column);
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)
    [actSolution_1, actSolution_2, actSolution_3] = ...
        se23alg.decompose(testCase.TestData.element_se23alg);
    expSolution_1 = testCase.TestData.xi_phi;
    expSolution_2 = testCase.TestData.xi_v;
    expSolution_3 = testCase.TestData.xi_r;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
    verifyEqual(testCase, actSolution_3, expSolution_3);
end

% Exp map
function testExpMap(testCase)   
    % Test Lie algebra input
    actSolution = se23alg.expMap(testCase.TestData.element_se23alg);
    expSolution = testCase.TestData.element_SE23;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^9 input
    actSolution = se23alg.expMap(testCase.TestData.element_se23alg_column);
    verifyEqual(testCase, actSolution, expSolution); 
end

% Synthesize
function testSynthesize(testCase)   
    actSolution = se23alg.synthesize(testCase.TestData.element_se23alg_column);
    expSolution = testCase.TestData.element_se23alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Vee
function testVee(testCase)   
    actSolution = se23alg.vee(testCase.TestData.element_se23alg);
    expSolution = testCase.TestData.element_se23alg_column;
    verifyEqual(testCase, actSolution, expSolution);
end

% Wedge
function testWedge(testCase)   
    actSolution = se23alg.wedge(testCase.TestData.element_se23alg_column);
    expSolution = testCase.TestData.element_se23alg;
    verifyEqual(testCase, actSolution, expSolution);
end

