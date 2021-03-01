function se3r3r3algTests = testse3r3r3alg
%TESTSE3R3R3ALG Function-based testing for se3r3r3alg.
% To run tests:
%     results = runtests('testse3r3r3alg.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    se3r3r3algTests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to se3r3r3alg class.
    addpath('../');
    
    % Set fixture values.
    xi_phi = [0.1, pi / 14, -0.54].';
    angle = sqrt(xi_phi.' * xi_phi);
    assert(angle > MLGUtils.tol_small_angle);
    xi_r = [0.05, -0.3, 0.276].';
    xi_b1 = [0.02, -0.007, 0.025].';
    xi_b2 = rand(3, 1);
    element_se3r3r3alg = [ so3alg.synthesize(xi_phi), xi_r, zeros(3, 5)  ;
                           zeros(1, 9)                                   ;
                           zeros(3, 7), xi_b1, xi_b2                     ;
                           zeros(2, 9)                                  ];  
    element_se3r3r3alg_column = [ xi_phi; xi_r; xi_b1; xi_b2 ];
    element_se3r3r3alg_adj = [ so3alg.cross(xi_phi), zeros(3, 9)                              ;
                               so3alg.cross(xi_r), so3alg.cross(xi_phi), zeros(3, 6)          ;
                               so3alg.cross(xi_b1), zeros(3), so3alg.cross(xi_phi), zeros(3)  ;
                               so3alg.cross(xi_b2), zeros(3, 6), so3alg.cross(xi_phi)        ]; 
    element_SE3R3R3 = [ so3alg.expMap(xi_phi), SO3.computeJLeft(xi_phi) * xi_r, zeros(3, 5)   ;
                        zeros(1, 3), 1, zeros(1, 5)                                          ;
                        zeros(3, 4), eye(3), xi_b1, xi_b2                                    ;
                        zeros(2, 7), eye(2)                                                 ];
    
    % Assign fixture values.
    testCase.TestData.xi_phi = xi_phi;
    testCase.TestData.xi_r = xi_r;
    testCase.TestData.xi_b1 = xi_b1;
    testCase.TestData.xi_b2 = xi_b2;
    testCase.TestData.element_se3r3r3alg = element_se3r3r3alg;
    testCase.TestData.element_se3r3r3alg_column = element_se3r3r3alg_column;
    testCase.TestData.element_se3r3r3alg_adj = element_se3r3r3alg_adj;
    testCase.TestData.element_SE3R3R3 = element_SE3R3R3;
end

% Adjoint
function testAdjoint(testCase)
    % Test Lie algebra input
    actSolution = se3r3r3alg.adjoint(testCase.TestData.element_se3r3r3alg);
    expSolution = testCase.TestData.element_se3r3r3alg_adj;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^6 input
    actSolution = se3r3r3alg.adjoint(testCase.TestData.element_se3r3r3alg_column);
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)
    [actSolution_1, actSolution_2, actSolution_3, actSolution_4] = ...
        se3r3r3alg.decompose(testCase.TestData.element_se3r3r3alg);
    expSolution_1 = testCase.TestData.xi_phi;
    expSolution_2 = testCase.TestData.xi_r;
    expSolution_3 = testCase.TestData.xi_b1;
    expSolution_4 = testCase.TestData.xi_b2;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
    verifyEqual(testCase, actSolution_3, expSolution_3);
    verifyEqual(testCase, actSolution_4, expSolution_4);
end

% Exp map
function testExpMap(testCase)   
    % Test Lie algebra input
    actSolution = se3r3r3alg.expMap(testCase.TestData.element_se3r3r3alg);
    expSolution = testCase.TestData.element_SE3R3R3;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^6 input
    actSolution = se3r3r3alg.expMap(testCase.TestData.element_se3r3r3alg_column);
    verifyEqual(testCase, actSolution, expSolution); 
end

% Synthesize
function testSynthesize(testCase)   
    actSolution = se3r3r3alg.synthesize(testCase.TestData.element_se3r3r3alg_column);
    expSolution = testCase.TestData.element_se3r3r3alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Vee
function testVee(testCase)   
    actSolution = se3r3r3alg.vee(testCase.TestData.element_se3r3r3alg);
    expSolution = testCase.TestData.element_se3r3r3alg_column;
    verifyEqual(testCase, actSolution, expSolution);
end

% Wedge
function testWedge(testCase)   
    actSolution = se3r3r3alg.wedge(testCase.TestData.element_se3r3r3alg_column);
    expSolution = testCase.TestData.element_se3r3r3alg;
    verifyEqual(testCase, actSolution, expSolution);
end

