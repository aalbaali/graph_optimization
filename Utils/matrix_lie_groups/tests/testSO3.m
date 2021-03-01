function SO3tests = testSO3
%TESTSO3 Function-based testing for SO3.
% To run tests:
%     results = runtests('testSO3.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    SO3tests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to SO3 class
    addpath('../');
    
    % Set fixture values
    phi = [6 * pi / 4, 0.751, 2 * pi / 3].';
    angle = sqrt(phi.' * phi);
    % Don't want the angle near multiples of pi, as these special cases are
    % explicitly handled in SO3.decompose.
    assert(mod(angle, pi) > MLGUtils.tol_small_angle && ...
        pi - mod(angle, pi) > MLGUtils.tol_small_angle)
    crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
    % Equation (103) from Lie Groups for Computer Vision (Eade).
    A = sin(angle) / angle;
    B = (1 - cos(angle)) / angle.^2;
    element_SO3 = eye(3) + A * crossop(phi) + B * crossop(phi)^2;
    element_SO3_adj = element_SO3;
    element_SO3_inv = element_SO3.';
    element_so3alg = crossop(phi);
    % Needed to test special cases of decompose
    dcm_is_identity = eye(3);
    expected_phi_identity = zeros(3, 1);
    dcm_rotation_by_pi = [-1, 0, 0; 0, -1, 0; 0, 0, 1];
    expected_phi_rotation_by_pi = [0, 0, pi].';
    abs_tol = 1e-14;
    % Left Jacobian
    % Equation (124) from Lie Groups for Computer Vision by Eade.
    A = (1 - cos(angle)) / angle.^2;
    B = (angle - sin(angle)) / angle.^3;
    J_left = eye(3) + A * crossop(phi) + B * crossop(phi)^2;
    % Test small angle
    phi_small = [1e-7, 0, 3.5e-7].';
    angle_small = sqrt(phi_small.' * phi_small);
    assert(angle_small <= MLGUtils.tol_small_angle);
    % Equations (157), (159) from Eade.
    t2 = angle_small.^2;
    A_small = 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * (1 - t2 / 56)));
    B_small = 1 / 6 * (1 - t2 / 20 * (1 - t2 / 42 * (1 - t2 / 72)));
    J_left_small = eye(3) + A_small * crossop(phi_small) + ...
        B_small * crossop(phi_small)^2;
    % Inverse of left Jacobian
    % Equation (125) from Lie Groups for Computer Vision by Eade.
    A = 1 / angle.^2 * (1 - angle * sin(angle) / (2 * (1 - cos(angle))));
    J_left_inv = eye(3) - 1 / 2 * crossop(phi) + A * crossop(phi)^2;
    % Equation (163)
    t2 = angle_small.^2;
    A_small = 1 / 12 * (1 + t2 / 60 * (1 + t2 / 42 * (1 + t2 / 40)));
    J_left_inv_small = eye(3) - 1 / 2 * crossop(phi_small) + A_small * ...
        crossop(phi_small)^2;
    
    % Assign fixture values
    testCase.TestData.phi = phi;
    testCase.TestData.element_SO3 = element_SO3;
    testCase.TestData.element_SO3_adj = element_SO3_adj;
    testCase.TestData.element_SO3_inv = element_SO3_inv;
    testCase.TestData.element_so3alg = element_so3alg;
    testCase.TestData.dcm_is_identity = dcm_is_identity;
    testCase.TestData.expected_phi_identity = expected_phi_identity;
    testCase.TestData.dcm_rotation_by_pi = dcm_rotation_by_pi;
    testCase.TestData.expected_phi_rotation_by_pi = expected_phi_rotation_by_pi;
    testCase.TestData.abs_tol = abs_tol;
    testCase.TestData.phi_small = phi_small;
    testCase.TestData.J_left = J_left;
    testCase.TestData.J_left_small = J_left_small;
    testCase.TestData.J_left_inv = J_left_inv;
    testCase.TestData.J_left_inv_small = J_left_inv_small;
end

% Adjoint
function testAdjoint(testCase)   
    actSolution = SO3.adjoint(testCase.TestData.element_SO3);
    expSolution = testCase.TestData.element_SO3_adj;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)
    actSolution = SO3.decompose(testCase.TestData.element_SO3);
    % The angle corresponding to the rotation vector returned by this
    % function is \in (-pi, pi].  If the angle corresponding to the expected
    % solution is >pi, then re-parameterize.  
    phi = testCase.TestData.phi;
    angle = sqrt(phi.' * phi);
    if angle > pi
        temp_angle = mod(angle, 2 * pi);
        axis = phi / angle;
        if temp_angle > pi
            temp_angle = -(2 * pi - temp_angle);
        end
        phi = temp_angle * axis;
    end
    expSolution = phi;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
    % Test no rotation (or rotation by 2*n*pi)
    actSolution = SO3.decompose(testCase.TestData.dcm_is_identity);
    expSolution = testCase.TestData.expected_phi_identity;
    verifyEqual(testCase, actSolution, expSolution);
    % Test rotation by pi.
    actSolution = SO3.decompose(testCase.TestData.dcm_rotation_by_pi);
    expSolution = testCase.TestData.expected_phi_rotation_by_pi;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse
function testInverse(testCase)   
    actSolution = SO3.inverse(testCase.TestData.element_SO3);
    expSolution = testCase.TestData.element_SO3_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Left Jacobian
function testJLeft(testCase)
    actSolution = SO3.computeJLeft(testCase.TestData.phi);
    expSolution = testCase.TestData.J_left;
    verifyEqual(testCase, actSolution, expSolution);
    % Test for small phi
    actSolution = SO3.computeJLeft(testCase.TestData.phi_small);
    expSolution = testCase.TestData.J_left_small;
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse of left Jacobian
function testJLeftInv(testCase)
    actSolution = SO3.computeJLeftInv(testCase.TestData.phi);
    expSolution = testCase.TestData.J_left_inv;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
    % Test for small angle
    actSolution = SO3.computeJLeftInv(testCase.TestData.phi_small);
    expSolution = testCase.TestData.J_left_inv_small;
    verifyEqual(testCase, actSolution, expSolution);
end

% Right Jacobian
function testJRight(testCase)
    actSolution = SO3.computeJRight(testCase.TestData.phi);
    expSolution = testCase.TestData.J_left.';
    verifyEqual(testCase, actSolution, expSolution);
end

% Inverse of right Jacobian
function testJRightInv(testCase)
    actSolution = SO3.computeJRightInv(testCase.TestData.phi);
    expSolution = testCase.TestData.J_left_inv.';
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
end

% Log map
function testLogmap(testCase)   
    actSolution = SO3.logMap(testCase.TestData.element_SO3);
    % The angle corresponding to the rotation vector returned by this
    % function is \in (-pi, pi].  If the angle corresponding to the expected
    % solution is >pi, then re-parameterize.  
    element_so3alg = testCase.TestData.element_so3alg;
    phi = testCase.TestData.phi;
    angle = sqrt(phi.' * phi);
    if angle > pi
        temp_angle = mod(angle, 2 * pi);
        axis = phi / angle;
        if temp_angle > pi
            temp_angle = -(2 * pi - temp_angle);
        end
        phi = temp_angle * axis;
        crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
        element_so3alg = crossop(phi);
    end
    expSolution = element_so3alg;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
end

% Synthesize
function testSynthesize(testCase)
    % Test synthesis from rotation vector
    actSolution = SO3.synthesize(testCase.TestData.phi);
    expSolution = testCase.TestData.element_SO3;
    verifyEqual(testCase, actSolution, expSolution);
    % Test synthesis from axis-angle parameterization
    angle = sqrt(testCase.TestData.phi.' * testCase.TestData.phi);
    axis = testCase.TestData.phi / angle;
    actSolution = SO3.synthesize(axis, angle);
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
    % Test that axis must have unit length
    not_unit_length = [1, 2, 3].';
    verifyError(testCase, @()SO3.synthesize(not_unit_length, angle), ...
        'synthesizeSO3:AxisUnitLength');
    % Test too many inputs
    verifyError(testCase, @()SO3.synthesize(1, 2, 3), ...
        'synthesizeSO3:TooManyInputs');
end

