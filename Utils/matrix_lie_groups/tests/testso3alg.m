function so3algTests = testso3alg
%TESTSO3ALG Function-based testing for so3alg.
% To run tests:
%     results = runtests('testso3alg.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    so3algTests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to so3alg class.
    addpath('../');
    
    % Set fixture values.
    phi = [3 * pi / 4, 0.3, 5 * pi / 4].';
    angle = sqrt(phi.' * phi);
    assert(angle > MLGUtils.tol_small_angle);
    crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
    element_so3alg = crossop(phi);
    element_so3alg_adj = crossop(phi);
    % Equation (103) from Lie Groups for Computer Vision (Eade).
    A = sin(angle) / angle;
    B = (1 - cos(angle)) / angle.^2;
    element_SO3 = eye(3) + A * crossop(phi) + B * crossop(phi)^2;
    % Test small angle
    phi_small = [1e-7, 0, 3.5e-7].';
    angle_small = sqrt(phi_small.' * phi_small);
    assert(angle_small <= MLGUtils.tol_small_angle);
    % Equations (155), (157) from Eade.
    t2 = angle_small.^2;
    A_small = 1 - t2 / 6 * (1 - t2 / 20 * (1 - t2 / 42));
    B_small = 1 / 2 * (1 - t2 / 12 * (1 - t2 / 30 * (1 - t2 / 56)));
    element_SO3_small = eye(3) + A_small * crossop(phi_small) + ...
        B_small * crossop(phi_small)^2;
    abs_tol = 1e-14;

    % Assign fixture values.
    testCase.TestData.phi = phi;
    testCase.TestData.element_so3alg = element_so3alg;
    testCase.TestData.element_so3alg_adj = element_so3alg_adj;
    testCase.TestData.element_SO3 = element_SO3;
    testCase.TestData.phi_small = phi_small;
    testCase.TestData.element_SO3_small = element_SO3_small;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)
    % Test Lie algebra input
    actSolution = so3alg.adjoint(testCase.TestData.element_so3alg);
    expSolution = testCase.TestData.element_so3alg_adj;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^3 input
    actSolution = so3alg.adjoint(testCase.TestData.phi);
    verifyEqual(testCase, actSolution, expSolution);
end

% Cross
function testCross(testCase)   
    actSolution = so3alg.cross(testCase.TestData.phi);
    expSolution = testCase.TestData.element_so3alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    actSolution = so3alg.decompose(testCase.TestData.element_so3alg);
    expSolution = testCase.TestData.phi;
    verifyEqual(testCase, actSolution, expSolution);
end

% Exp map
function testExpMap(testCase)  
    % Test Lie algebra input
    actSolution = so3alg.expMap(testCase.TestData.element_so3alg);
    expSolution = testCase.TestData.element_SO3;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
    % Test R^3 input
    actSolution = so3alg.expMap(testCase.TestData.phi);
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
    % Test small phi
    actSolution = so3alg.expMap(testCase.TestData.phi_small);
    expSolution = testCase.TestData.element_SO3_small;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        testCase.TestData.abs_tol);
end

% Synthesize
function testSynthesize(testCase)   
    actSolution = so3alg.synthesize(testCase.TestData.phi);
    expSolution = testCase.TestData.element_so3alg;
    verifyEqual(testCase, actSolution, expSolution);
end

% Vee
function testVee(testCase)   
    actSolution = so3alg.vee(testCase.TestData.element_so3alg);
    expSolution = testCase.TestData.phi;
    verifyEqual(testCase, actSolution, expSolution);
end

% Wedge
function testWedge(testCase)   
    actSolution = so3alg.wedge(testCase.TestData.phi);
    expSolution = testCase.TestData.element_so3alg;
    verifyEqual(testCase, actSolution, expSolution);
end

