function SO2tests = testSO2
%TESTSO2 Function-based testing for SO2.
% To run tests:
%     results = runtests('testSO2.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    SO2tests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to SO2 class
    addpath('../');
    
    % Set fixture values
    theta = pi / 16;
    assert(mod(theta, pi) > MLGUtils.tol_small_angle && ...
        pi - mod(theta, pi) > MLGUtils.tol_small_angle)
    element_SO2 = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    element_SO2_adj = eye(2);
    element_SO2_inv = element_SO2.';
    element_so2alg = [0, -theta; theta, 0];
    % Need to test special cases
    theta_near_zero = -1e-7;
    assert(mod(theta_near_zero, 2 * pi) <= MLGUtils.tol_small_angle || ...
        2 * pi - mod(theta_near_zero, 2 * pi) <= MLGUtils.tol_small_angle);
    element_SO2_near_zero = [cos(theta_near_zero), -sin(theta_near_zero); ...
        sin(theta_near_zero), cos(theta_near_zero)];
    expected_theta_near_zero = 0;
    theta_near_pi = pi + 3e-7;
    assert(mod(theta_near_pi, pi) <= MLGUtils.tol_small_angle || ...
        pi - mod(theta_near_pi, pi) <= MLGUtils.tol_small_angle);
    element_SO2_near_pi = [cos(theta_near_pi), -sin(theta_near_pi); ...
        sin(theta_near_pi), cos(theta_near_pi)];
    expected_theta_near_pi = pi;    
    % Left Jacobian
    J11 = sin(theta) / theta;
    J12 = -(1 - cos(theta)) / theta;
    J_left = [J11, J12; -J12, J11];
    % Test small angle
    theta_small = 1e-7;
    assert(abs(theta_small) <= MLGUtils.tol_small_angle)
    % Equations (155), (157) from Lie Groups for Computer Vision (Eade).
    t2 = theta_small.^2;
    J11_small = 1 - t2 / 6 * (1 - t2 / 20 * (1 - t2 / 42));
    J12_small = -theta_small * 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * ...
        (1 - t2 / 56)));
    J_left_small = [J11_small, J12_small; -J12_small, J11_small];
    % Inverse of left Jacobian. Equations (133 - 135) from Lie Groups for
    % 2D and 3D Transformations by Eade.
    A = sin(theta) / theta;
    B = (1 - cos(theta)) / theta;
    J_left_inv = 1 / (A.^2 + B.^2) * [A, B; -B, A];
    % Test small angle
    % Equations (155), (157) from Lie Groups for Computer Vision (Eade).
    t2 = theta_small.^2;
    A_small = 1 - t2 / 6 * (1 - t2 / 20 * (1 - t2 / 42));
    B_small = theta_small * 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * ...
        (1 - t2 / 56)));
    J_left_inv_small = 1 / (A_small.^2 + B_small.^2) * [A_small, B_small; ...
        -B_small, A_small];
    abs_tol = 1e-14;
    
    % Assign fixture values
    testCase.TestData.theta = theta;
    testCase.TestData.element_SO2 = element_SO2;
    testCase.TestData.element_SO2_adj = element_SO2_adj;
    testCase.TestData.element_SO2_inv = element_SO2_inv;
    testCase.TestData.element_so2alg = element_so2alg;
    testCase.TestData.element_SO2_near_zero = element_SO2_near_zero;
    testCase.TestData.expected_theta_near_zero = expected_theta_near_zero;
    testCase.TestData.element_SO2_near_pi = element_SO2_near_pi;
    testCase.TestData.expected_theta_near_pi = expected_theta_near_pi;
    testCase.TestData.theta_small = theta_small;
    testCase.TestData.J_left = J_left;
    testCase.TestData.J_left_small = J_left_small;
    testCase.TestData.J_left_inv = J_left_inv;
    testCase.TestData.J_left_inv_small = J_left_inv_small;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)   
    actSolution = SO2.adjoint(testCase.TestData.element_SO2);
    expSolution = testCase.TestData.element_SO2_adj;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    actSolution = SO2.decompose(testCase.TestData.element_SO2);
    % The angle returned by this function is \in (-pi, pi].  If the angle
    % corresponding to the expected solution is >pi, then re-parameterize.
    theta = testCase.TestData.theta;
    if abs(theta) > pi
        theta = mod(theta, 2 * pi);
        if theta > pi
            theta = -(2 * pi - theta);
        end
    end
    expSolution = theta;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
    % Test special cases: theta close to zero, and close to pi
    actSolution = SO2.decompose(testCase.TestData.element_SO2_near_zero);
    expSolution = testCase.TestData.expected_theta_near_zero;
    verifyEqual(testCase, actSolution, expSolution);
    actSolution = SO2.decompose(testCase.TestData.element_SO2_near_pi);
    expSolution = testCase.TestData.expected_theta_near_pi;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse
function testInverse(testCase)   
    actSolution = SO2.inverse(testCase.TestData.element_SO2);
    expSolution = testCase.TestData.element_SO2_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Left Jacobian
function testJ(testCase)
    actSolution = SO2.computeJLeft(testCase.TestData.theta);
    expSolution = testCase.TestData.J_left;
    verifyEqual(testCase, actSolution, expSolution);
    % Test for small theta
    actSolution = SO2.computeJLeft(testCase.TestData.theta_small);
    expSolution = testCase.TestData.J_left_small;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse of left Jacobian
function testJinv(testCase)
    actSolution = SO2.computeJLeftInv(testCase.TestData.theta);
    expSolution = testCase.TestData.J_left_inv;
    verifyEqual(testCase, actSolution, expSolution);
    % Test for small theta
    actSolution = SO2.computeJLeftInv(testCase.TestData.theta_small);
    expSolution = testCase.TestData.J_left_inv_small;
    verifyEqual(testCase, actSolution, expSolution);
end

% Log map
function testLogmap(testCase)   
    actSolution = SO2.logMap(testCase.TestData.element_SO2);
    % The angle returned by this function is \in (-pi, pi].  If the angle
    % corresponding to the expected solution is >pi, then re-parameterize.
    element_so2alg = testCase.TestData.element_so2alg;
    theta = testCase.TestData.theta;
    if abs(theta) > pi
        theta = mod(theta, 2 * pi);
        if theta > pi
            theta = -(2 * pi - theta);
        end
        element_so2alg = [0, -theta; theta, 0];
    end
    expSolution = element_so2alg;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
end

% Synthesize
function testSynthesize(testCase)   
    actSolution = SO2.synthesize(testCase.TestData.theta);
    expSolution = testCase.TestData.element_SO2;
    verifyEqual(testCase, actSolution, expSolution);
end

