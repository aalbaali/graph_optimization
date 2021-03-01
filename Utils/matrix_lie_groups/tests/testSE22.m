function SE22tests = testSE22
%TESTSE22 Function-based testing for SE22.
% To run tests:
%     results = runtests('testSE22.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    SE22tests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to SE22 class
    addpath('../');
    
    % Set fixture values
    theta = 11 * pi() / 16;
    % Have verified behaviour for abs(theta) > pi, so restrict positive range.
    assert(abs(theta) > MLGUtils.tol_small_angle && abs(theta) <= pi);
    C = SO2.synthesize(theta);
    v = [-0.07, 2.3].';
    r = [7, -3.4].';
    element_SE22 = [C, v, r          ;
                   zeros(2), eye(2) ];
    omega = [0, -1; 1, 0];
    element_SE22_adj = [1, zeros(1, 4)          ;
                       -omega * v, C, zeros(2)  ;
                       -omega * r, zeros(2), C ]; 
    element_SE22_inv = [C.', -C.' * v, -C.' * r  ; 
                       zeros(2), eye(2)         ];
    Jinv = SO2.computeJLeftInv(theta);
    element_se22alg = [ SO2.logMap(C), Jinv * v, Jinv * r ;
                       zeros(2, 4)                      ];
    abs_tol = 1e-14;
    
    % Assign fixture values
    testCase.TestData.theta = theta;
    testCase.TestData.C = C;
    testCase.TestData.v = v;
    testCase.TestData.r = r;
    testCase.TestData.element_SE22 = element_SE22;
    testCase.TestData.element_SE22_adj = element_SE22_adj;
    testCase.TestData.element_SE22_inv = element_SE22_inv;
    testCase.TestData.element_se22alg = element_se22alg;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)   
    actSolution = SE22.adjoint(testCase.TestData.element_SE22);
    expSolution = testCase.TestData.element_SE22_adj;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    [actSolution_1, actSolution_2, actSolution_3] = ...
        SE22.decompose(testCase.TestData.element_SE22);
    expSolution_1 = testCase.TestData.C;
    expSolution_2 = testCase.TestData.v;
    expSolution_3 = testCase.TestData.r;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
    verifyEqual(testCase, actSolution_3, expSolution_3);
end

% Inverse
function testInverse(testCase)   
    actSolution = SE22.inverse(testCase.TestData.element_SE22);
    expSolution = testCase.TestData.element_SE22_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Log map
function testLogmap(testCase)
    actSolution = SE22.logMap(testCase.TestData.element_SE22);
    expSolution = testCase.TestData.element_se22alg;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        MLGUtils.tol_small_angle);
end

% Synthesize
function testSynthesize(testCase)
    % Test SO2 input
    actSolution = SE22.synthesize(testCase.TestData.C, testCase.TestData.v, ...
        testCase.TestData.r);
    expSolution = testCase.TestData.element_SE22;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^3 input
    actSolution = SE22.synthesize(testCase.TestData.theta, testCase.TestData.v, ...
        testCase.TestData.r);
    verifyEqual(testCase, actSolution, expSolution);
end

