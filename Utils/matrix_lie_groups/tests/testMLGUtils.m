function mlgUtilsTests = testMLGUtils
%TESTMLGUTILS Function-based testing for MLGUtils.
% To run tests:
%     results = runtests('testMLGUtils.m')
% To view results:
%     rt = table(results)
% -------------------------------------------------------------------------
    mlgUtilsTests = functiontests(localfunctions);
end

function setupOnce(testCase)
    % Add path to MLGUtils class
    addpath('../');
    
    % Set fixture values
    phi = [4.6, -pi/2, 0.1].';
    dcm = SO3.synthesize(phi);
    not_dcm = dcm + 4;
    not_numeric = 'dog';
    abs_tol = 1e-14;

    % Assign fixture values
    testCase.TestData.phi = phi;
    testCase.TestData.dcm = dcm;
    testCase.TestData.not_dcm = not_dcm;
    testCase.TestData.not_numeric = not_numeric;
    testCase.TestData.abs_tol = abs_tol;
end

% Inverse is transpose
function testInverseIsTranspose(testCase)
    % Test DCM
    verifyReturnsTrue(testCase, @()MLGUtils.isInverseEqualTranspose(...
        testCase.TestData.dcm));
    % Verify error throw
    verifyError(testCase, @()MLGUtils.isInverseEqualTranspose(...
        testCase.TestData.not_dcm, 'SO3'), 'isInverseEqualTranspose:notOrthogonal');
end

% Determinant is +1
function testDeterminantOne(testCase)
    % Test DCM
    verifyReturnsTrue(testCase, @()MLGUtils.isDeterminantOne(...
        testCase.TestData.dcm));
    % Verify error throw
    verifyError(testCase, @()MLGUtils.isDeterminantOne(...
        testCase.TestData.not_dcm, 'SO3'), 'isDeterminantOne:notOne');
end

% Matrix skew-symmetric
function testSkewSymmetrix(testCase)
    % Test element of so3
    crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
    verifyReturnsTrue(testCase, @()MLGUtils.isSkewSymmetric(...
        crossop(testCase.TestData.phi)));
    % Verify error throw
    not_skew_symmetrix = crossop(testCase.TestData.phi) + ...
        [0, 0, 1; zeros(2, 3)];
    verifyError(testCase, @()MLGUtils.isSkewSymmetric(not_skew_symmetrix, ...
        'so3alg'), 'isSkewSymmetric:notSkewSymmetric');
end

% Diagonal all zeros
function testDiagonalZeros(testCase)
    % Test element of so3
    crossop = @(x) [0, -x(3), x(2); x(3), 0 -x(1); -x(2), x(1), 0];
    verifyReturnsTrue(testCase, @()MLGUtils.isDiagonalZeros(...
        crossop(testCase.TestData.phi)));
    % Verify error throw
    not_diagonal_zeros = crossop(testCase.TestData.phi) + eye(3);
    verifyError(testCase, @()MLGUtils.isDiagonalZeros(not_diagonal_zeros, ...
        'so3alg'), 'isDiagonalZeros:notDiagonalZeros');
end

% Real numeric matrix of given size
function testRealNumericRightSize(testCase)
    verifyReturnsTrue(testCase, @()MLGUtils.isValidRealMat(...
        testCase.TestData.dcm, 3, 3, 'SO3'));
    % Verify error throws
    verifyError(testCase, @()MLGUtils.isValidRealMat(testCase.TestData.not_numeric, ...
        1, 1, 'string'), 'isValidRealMat:notNumeric');
    not_real_mat = testCase.TestData.dcm + 1j * eye(3);
    verifyError(testCase, @()MLGUtils.isValidRealMat(not_real_mat, ...
        3, 3, 'complex'), 'isValidRealMat:notReal');
    verifyError(testCase, @()MLGUtils.isValidRealMat(...
        testCase.TestData.dcm, 3, 4, 'SO3'), 'isValidRealMat:notCorrectSize');
end

% Real numeric column of given length
function testRealNumericRightLength(testCase)
    verifyReturnsTrue(testCase, @()MLGUtils.isValidRealCol(...
        testCase.TestData.phi, 3));
    % Verify false cases
    verifyFalse(testCase, MLGUtils.isValidRealCol(...
        testCase.TestData.not_numeric, 1));
    not_real_col = testCase.TestData.phi + 1j * ones(3, 1);
    verifyFalse(testCase, MLGUtils.isValidRealCol(...
        not_real_col, 3));
    verifyFalse(testCase, MLGUtils.isValidRealCol(...
        testCase.TestData.phi, 4));
end

