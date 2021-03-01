function SE2tests = testSE2
%TESTSE2 Function-based testing for SE2.
% To run tests:
%     results = runtests('testSE2.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    SE2tests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to SE2 class
    addpath('../');
    
    % Set fixture values
    theta = 5 * pi / 16;
    % Have verified behaviour for abs(theta) > pi, so restrict positive range.
    assert(abs(theta) > MLGUtils.tol_small_angle && abs(theta) <= pi);
    r = [-11, 7.6].';
    C = SO2.synthesize(theta);
    element_SE2 = [ C, r     ; 
                    0, 0, 1 ];
    omega = [0, -1; 1, 0];
    element_SE2_adj = [1, 0, 0        ;
                       -omega * r, C ];
    element_SE2_inv = [C.', - C.' * r ;
                       0, 0, 1       ];
    Jinv = SO2.computeJLeftInv(theta);
    element_se2alg = [SO2.logMap(C), Jinv * r ;
                      zeros(1, 3)            ];
    element_se2alg_R3 = se2alg.vee(element_se2alg);
    a = element_se2alg_R3(1);
    v1 = element_se2alg_R3(2);
    v2 = element_se2alg_R3(3);
    % Left Jacobian
    J21 = (a * v1 + v2 - v2 * cos(a) - v1 * sin(a)) / a^2;
    J22 = sin(a) / a;
    J23 = (cos(a) - 1) / a;
    J31 = (-v1 + a * v2 + v1 * cos(a) - v2 * sin(a)) / a^2;
    J32 = (1 - cos(a)) / a;
    J33 = sin(a) / a;
    J_left = [ 1, 0, 0        ;
               J21, J22, J23  ;
               J31, J32, J33 ];
    J_left_inv = inv(J_left);
    J21 = (a * v1 - v2 + v2 * cos(a) - v1 * sin(a)) / a^2;
    J22 = sin(a) / a;
    J23 = (1 - cos(a)) / a;
    J31 = (v1 + a * v2 - v1 * cos(a) - v2 * sin(a)) / a^2;
    J32 = (cos(a) - 1) / a;
    J33 = sin(a) / a;
    J_right = [ 1, 0, 0        ;
                J21, J22, J23  ;
                J31, J32, J33 ];
    J_right_inv = inv(J_right);
    % Test edge case
    xi_edge = [ 0; rand(2, 1) ];
    J_left_edge = eye(3);
    abs_tol = 1e-14;

    % Assign fixture values
    testCase.TestData.theta = theta;
    testCase.TestData.r = r;
    testCase.TestData.C = C;
    testCase.TestData.element_SE2 = element_SE2;
    testCase.TestData.element_SE2_adj = element_SE2_adj;
    testCase.TestData.element_SE2_inv = element_SE2_inv;
    testCase.TestData.element_se2alg = element_se2alg;
    testCase.TestData.element_se2alg_R3 = element_se2alg_R3;
    testCase.TestData.J_left = J_left;
    testCase.TestData.J_left_inv = J_left_inv;
    testCase.TestData.J_right = J_right;
    testCase.TestData.J_right_inv = J_right_inv;
    testCase.TestData.xi_edge = xi_edge;
    testCase.TestData.J_left_edge = J_left_edge;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)   
    actSolution = SE2.adjoint(testCase.TestData.element_SE2);
    expSolution = testCase.TestData.element_SE2_adj;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    [actSolution_1, actSolution_2] = ...
        SE2.decompose(testCase.TestData.element_SE2);
    expSolution_1 = testCase.TestData.C;
    expSolution_2 = testCase.TestData.r;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
end

% Inverse
function testInverse(testCase)   
    actSolution = SE2.inverse(testCase.TestData.element_SE2);
    expSolution = testCase.TestData.element_SE2_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Left Jacobian
function testJLeft(testCase)
    actSolution = SE2.computeJLeft(testCase.TestData.element_se2alg_R3);
    expSolution = testCase.TestData.J_left;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse of left Jacobian
function testJLeftInv(testCase)
    actSolution = SE2.computeJLeftInv(testCase.TestData.element_se2alg_R3);
    expSolution = testCase.TestData.J_left_inv;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
end

% Right Jacobian
function testJRight(testCase)
    actSolution = SE2.computeJRight(testCase.TestData.element_se2alg_R3);
    expSolution = testCase.TestData.J_right;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse of right Jacobian
function testJRightInv(testCase)
    actSolution = SE2.computeJRightInv(testCase.TestData.element_se2alg_R3);
    expSolution = testCase.TestData.J_right_inv;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
end

% Test edge case
function testJLeftEdge(testCase)
    actSolution = SE2.computeJLeft(testCase.TestData.xi_edge);
    expSolution = testCase.TestData.J_left_edge;
    verifyEqual(testCase, actSolution, expSolution);
end

% Log map
function testLogmap(testCase)   
    actSolution = SE2.logMap(testCase.TestData.element_SE2);
    expSolution = testCase.TestData.element_se2alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Synthesize
function testSynthesize(testCase)
    % Test SO2 input for rotation
    actSolution = SE2.synthesize(testCase.TestData.C, testCase.TestData.r);
    expSolution = testCase.TestData.element_SE2;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^1 input for rotation
    actSolution = SE2.synthesize(testCase.TestData.theta, testCase.TestData.r);
    verifyEqual(testCase, actSolution, expSolution);
end

