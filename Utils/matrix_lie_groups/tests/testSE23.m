function SE23tests = testSE23
%TESTSE23 Function-based testing for SE23.
% To run tests:
%     results = runtests('testSE23.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    SE23tests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to SE23 class
    addpath('../');
    
    % Set fixture values
    phi = [3 * pi / 8, 0.751, -pi / 3].';
    angle = sqrt(phi.' * phi);
    % Have verified behaviour for angle > pi, so restrict positive range.
    assert(angle > MLGUtils.tol_small_angle && angle <= pi);
    C = SO3.synthesize(phi);
    v = [-0.5, 7, 0.35].';
    r = [-4.6, 0, 7].';
    element_SE23 = [C, v, r             ;
                   zeros(2, 3), eye(2) ];
    crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
    element_SE23_adj = [C, zeros(3, 6)        ; 
                       crossop(v) * C, C, zeros(3)  ;
                       crossop(r) * C, zeros(3), C ];
    element_SE23_inv = [C.', -C.' * v, -C.' * r  ; 
                       zeros(2, 3), eye(2)      ];
    Jinv = SO3.computeJLeftInv(phi);
    element_se23alg = [ SO3.logMap(C), Jinv * v, Jinv * r ;
                       zeros(2, 5)                      ];
    abs_tol = 1e-14;
    
    % Assign fixture values
    testCase.TestData.phi = phi;
    testCase.TestData.C = C;
    testCase.TestData.v = v;
    testCase.TestData.r = r;
    testCase.TestData.element_SE23 = element_SE23;
    testCase.TestData.element_SE23_adj = element_SE23_adj;
    testCase.TestData.element_SE23_inv = element_SE23_inv;
    testCase.TestData.element_se23alg = element_se23alg;
    testCase.TestData.abs_tol = abs_tol;
end

% Adjoint
function testAdjoint(testCase)   
    actSolution = SE23.adjoint(testCase.TestData.element_SE23);
    expSolution = testCase.TestData.element_SE23_adj;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    [actSolution_1, actSolution_2, actSolution_3] = ...
        SE23.decompose(testCase.TestData.element_SE23);
    expSolution_1 = testCase.TestData.C;
    expSolution_2 = testCase.TestData.v;
    expSolution_3 = testCase.TestData.r;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
    verifyEqual(testCase, actSolution_3, expSolution_3);
end

% Inverse
function testInverse(testCase)   
    actSolution = SE23.inverse(testCase.TestData.element_SE23);
    expSolution = testCase.TestData.element_SE23_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Log map
function testLogmap(testCase)
    actSolution = SE23.logMap(testCase.TestData.element_SE23);
    expSolution = testCase.TestData.element_se23alg;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        MLGUtils.tol_small_angle);
end

% Synthesize
function testSynthesize(testCase)
    % Test SO3 input
    actSolution = SE23.synthesize(testCase.TestData.C, testCase.TestData.v, ...
        testCase.TestData.r);
    expSolution = testCase.TestData.element_SE23;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^3 input
    actSolution = SE23.synthesize(testCase.TestData.phi, testCase.TestData.v, ...
        testCase.TestData.r);
    verifyEqual(testCase, actSolution, expSolution);
end

