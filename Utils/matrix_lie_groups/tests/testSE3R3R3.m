function SE3R3R3tests = testSE3R3R3
%TESTSE3R3R3 Function-based testing for SE3 x R3 x R3.
% To run tests:
%     results = runtests('testSE3R3R3.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    SE3R3R3tests = functiontests(localfunctions);
end

% File fixture
function setupOnce(testCase)
    % Add path to SE3R3R3 class
    addpath('../');
    
    % Set fixture values
    phi = [3 * pi / 8, 0.751, -pi / 3].';
    angle = sqrt(phi.' * phi);
    % Have verified behaviour for angle > pi, so restrict positive range.
    assert(angle > MLGUtils.tol_small_angle && angle <= pi);
    C = SO3.synthesize(phi);
    r = [-4.6, 0, 7].';
    b1 = [0.01, -0.05, 0].';
    b2 = rand(3, 1);
    element_SE3R3R3 = [C, r, zeros(3, 5)                  ;
                       zeros(1, 3), 1, zeros(1, 5)        ;
                       zeros(3, 4), eye(3), b1, b2        ;
                       zeros(2, 7), eye(2)               ];
    crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
    element_SE3R3R3_adj = [C, zeros(3, 9)                  ; 
                           crossop(r) * C, C, zeros(3, 6)  ;
                           zeros(6), eye(6)               ];
    element_SE3R3R3_inv = [C.', -C.' * r, zeros(3, 5)           ; 
                           zeros(1, 3), 1, zeros(1, 5)          ;
                           zeros(3, 4), eye(3), -b1, -b2        ;
                           zeros(2, 7), eye(2)                 ];
    element_se3R3R3alg = [ SO3.logMap(C), SO3.computeJLeftInv(phi) * r, zeros(3, 5)  ;
                           zeros(1, 9)                                           ;
                           zeros(3, 7), b1, b2                                   ;
                           zeros(2, 9)                                          ];     
    % Assign fixture values
    testCase.TestData.phi = phi;
    testCase.TestData.C = C;
    testCase.TestData.r = r;
    testCase.TestData.b1 = b1;
    testCase.TestData.b2 = b2;
    testCase.TestData.element_SE3R3R3 = element_SE3R3R3;
    testCase.TestData.element_SE3R3R3_adj = element_SE3R3R3_adj;
    testCase.TestData.element_SE3R3R3_inv = element_SE3R3R3_inv;
    testCase.TestData.element_se3r3r3alg = element_se3R3R3alg;
end

% Adjoint
function testAdjoint(testCase)   
    actSolution = SE3R3R3.adjoint(testCase.TestData.element_SE3R3R3);
    expSolution = testCase.TestData.element_SE3R3R3_adj;
    verifyEqual(testCase, actSolution, expSolution);
end

% Decompose
function testDecompose(testCase)   
    [actSolution_1, actSolution_2, actSolution_3, actSolution_4] = ...
        SE3R3R3.decompose(testCase.TestData.element_SE3R3R3);
    expSolution_1 = testCase.TestData.C;
    expSolution_2 = testCase.TestData.r;
    expSolution_3 = testCase.TestData.b1;
    expSolution_4 = testCase.TestData.b2;
    verifyEqual(testCase, actSolution_1, expSolution_1);
    verifyEqual(testCase, actSolution_2, expSolution_2);
    verifyEqual(testCase, actSolution_3, expSolution_3);
    verifyEqual(testCase, actSolution_4, expSolution_4);
end

% Inverse
function testInverse(testCase)   
    actSolution = SE3R3R3.inverse(testCase.TestData.element_SE3R3R3);
    expSolution = testCase.TestData.element_SE3R3R3_inv;
    verifyEqual(testCase, actSolution, expSolution);
end

% Log map
function testLogmap(testCase)
    actSolution = SE3R3R3.logMap(testCase.TestData.element_SE3R3R3);
    expSolution = testCase.TestData.element_se3r3r3alg;
    verifyEqual(testCase, actSolution, expSolution, 'AbsTol', ...
        MLGUtils.tol_small_angle);
end

% Synthesize
function testSynthesize(testCase)
    % Test SO3 input
    actSolution = SE3R3R3.synthesize(testCase.TestData.C, ...
        testCase.TestData.r, testCase.TestData.b1, testCase.TestData.b2);
    expSolution = testCase.TestData.element_SE3R3R3;
    verifyEqual(testCase, actSolution, expSolution);
    % Test R^3 inputs
    actSolution = SE3R3R3.synthesize(testCase.TestData.phi, ...
        testCase.TestData.r, testCase.TestData.b1, testCase.TestData.b2);
    verifyEqual(testCase, actSolution, expSolution);
end

