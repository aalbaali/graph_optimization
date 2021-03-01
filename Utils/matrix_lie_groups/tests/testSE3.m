function SE3tests = testSE3
%TESTSE3 Function-based testing for SE3.
% To run tests:
%     results = runtests('testSE3.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    SE3tests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to SE3 class
    addpath('../');
    
    % Set fixture values
    phi = [3 * pi / 8, 0.751, -pi / 3].';
    angle = sqrt(phi.' * phi);
    % Have verified behaviour for angle > pi, so restrict positive range.
    assert(angle > MLGUtils.tol_small_angle && angle <= pi);
    C = SO3.synthesize(phi);
    r = [-4.6, 0, 7].';
    element_SE3 = [C, r            ;
                   zeros(1, 3), 1 ];
    crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
    element_SE3_adj = [C, zeros(3)        ; 
                       crossop(r) * C, C ];
    element_SE3_inv = [C.', -C.' * r   ; 
                       zeros(1, 3), 1 ];
    Jinv = SO3.computeJLeftInv(phi);
    element_se3alg = [ SO3.logMap(C), Jinv * r ;
                       zeros(1, 4)              ];
    % Tolerance on equality
    abs_tol = 1e-14;
    % Q_left
    element_se3alg_R6 = se3alg.vee(element_se3alg);
    s = vecnorm(element_se3alg_R6(1:3));
    pw = SO3.wedge(element_se3alg_R6(1:3));
    rw = SO3.wedge(element_se3alg_R6(4:6));
    a1 = 1 / 2;
    a2 = (s - sin(s)) / s^3;
    a3 = (s^2 + 2 * cos(s) - 2) / (2 * s^4);
    a4 = (2 * s - 3 * sin(s) + s * cos(s)) / (2 * s^5);
    b1 = rw;
    b2 = pw * rw + rw * pw + pw * rw * pw;
    b3 = pw * pw * rw + rw * pw * pw - 3 * pw * rw * pw;
    b4 = pw * rw * pw * pw + pw * pw * rw * pw;
    Q_left = a1 * b1 + a2 * b2 + a3 * b3 + a4 * b4;
    % Edge case
    xi_edge = [ zeros(3, 1); rand(3, 1) ];
    Q_left_edge = zeros(3);
    % Left Jacobian
    J_left = [ SO3.computeJLeft(element_se3alg_R6(1:3)), zeros(3); ...
               Q_left,  SO3.computeJLeft(element_se3alg_R6(1:3))];
    % Inverse of left Jacobian
    J_3 = SO3.computeJLeftInv(element_se3alg_R6(1:3));
    J_left_inv = [ J_3, zeros(3); -J_3 * Q_left * J_3, J_3 ];
    % Right Jacobian
    s = vecnorm(-element_se3alg_R6(1:3));
    pw = SO3.wedge(-element_se3alg_R6(1:3));
    rw = SO3.wedge(-element_se3alg_R6(4:6));
    a1 = 1 / 2;
    a2 = (s - sin(s)) / s^3;
    a3 = (s^2 + 2 * cos(s) - 2) / (2 * s^4);
    a4 = (2 * s - 3 * sin(s) + s * cos(s)) / (2 * s^5);
    b1 = rw;
    b2 = pw * rw + rw * pw + pw * rw * pw;
    b3 = pw * pw * rw + rw * pw * pw - 3 * pw * rw * pw;
    b4 = pw * rw * pw * pw + pw * pw * rw * pw;
    Q_right = a1 * b1 + a2 * b2 + a3 * b3 + a4 * b4;
    J_right = [ SO3.computeJLeft(-element_se3alg_R6(1:3)), zeros(3); ...
                Q_right,  SO3.computeJLeft(-element_se3alg_R6(1:3))];
    % Inverse of right Jacobian
    J_3 = SO3.computeJLeftInv(-element_se3alg_R6(1:3));
    J_right_inv = [ J_3, zeros(3); -J_3 * Q_right * J_3, J_3 ];
    
    % Assign fixture values
    testCase.TestData.phi = phi;
    testCase.TestData.C = C;
    testCase.TestData.r = r;
    testCase.TestData.element_SE3 = element_SE3;
    testCase.TestData.element_SE3_adj = element_SE3_adj;
    testCase.TestData.element_SE3_inv = element_SE3_inv;
    testCase.TestData.element_se3alg = element_se3alg;
    testCase.TestData.element_se3alg_R6 = element_se3alg_R6;
    testCase.TestData.Q_left = Q_left;
    testCase.TestData.xi_edge = xi_edge;
    testCase.TestData.Q_left_edge = Q_left_edge;
    testCase.TestData.J_left = J_left;
    testCase.TestData.J_left_inv = J_left_inv;
    testCase.TestData.J_right = J_right;
    testCase.TestData.J_right_inv = J_right_inv;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)   
    actSolution = SE3.adjoint(testCase.TestData.element_SE3);
    expSolution = testCase.TestData.element_SE3_adj;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    [actSolution_1, actSolution_2] = ...
        SE3.decompose(testCase.TestData.element_SE3);
    expSolution_1 = testCase.TestData.C;
    expSolution_2 = testCase.TestData.r;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
end

% Inverse
function testInverse(testCase)   
    actSolution = SE3.inverse(testCase.TestData.element_SE3);
    expSolution = testCase.TestData.element_SE3_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Left Jacobian
function testJLeft(testCase)
    actSolution = SE3.computeJLeft(testCase.TestData.element_se3alg_R6);
    expSolution = testCase.TestData.J_left;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse of left Jacobian
function testJLeftInv(testCase)
    actSolution = SE3.computeJLeftInv(testCase.TestData.element_se3alg_R6);
    expSolution = testCase.TestData.J_left_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Right Jacobian
function testJRight(testCase)
    actSolution = SE3.computeJRight(testCase.TestData.element_se3alg_R6);
    expSolution = testCase.TestData.J_right;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse of right Jacobian
function testJRightInv(testCase)
    actSolution = SE3.computeJRightInv(testCase.TestData.element_se3alg_R6);
    expSolution = testCase.TestData.J_right_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Edge case for Q
function testQ(testCase)
    actSolution = SE3.computeQLeft(testCase.TestData.xi_edge);
    expSolution = testCase.TestData.Q_left_edge;
    verifyEqual(testCase, actSolution, expSolution);
end

% Log map
function testLogmap(testCase)
    actSolution = SE3.logMap(testCase.TestData.element_SE3);
    expSolution = testCase.TestData.element_se3alg;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        MLGUtils.tol_small_angle);
end

% Synthesize
function testSynthesize(testCase)
    % Test SO3 input
    actSolution = SE3.synthesize(testCase.TestData.C, testCase.TestData.r);
    expSolution = testCase.TestData.element_SE3;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^3 input
    actSolution = SE3.synthesize(testCase.TestData.phi, testCase.TestData.r);
    verifyEqual(testCase, actSolution, expSolution);
end

