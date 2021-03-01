% This minimum working example shows some simple workflows to follow when
% using the matrix Lie group API.
%
% Thomas Hitchcox
% Feb. 2020
% -------------------------------------------------------------------------
%% Basics
% Let's take an example in SE3.  An element of SE3 can be synthesized using
% either a rotation vector and a displacement, or a DCM and a displacement.
my_rotation_vector = rand(3, 1);
my_dcm = SO3.synthesize(my_rotation_vector);
my_displacement = pi() + rand(3, 1);

element_SE3 = SE3.synthesize(my_rotation_vector, my_displacement);
another_element_SE3 = SE3.synthesize(my_dcm, my_displacement);

% If you try to form an element of SE3 using an invalid input, the API will
% throw an error.  Uncomment the following line to try. 
% bad_element_SE3 = SE3.synthesize(rand(3, 3), my_displacement);

% Its often convenient to split up an element of SE3, e.g. for plotting
% errors.  This can be accomplished using the decompose() method.
[ my_dcm, my_displacement ] = SE3.decompose(element_SE3);

% Use the decompose() method for SO3 to extract the rotation vector.  Be
% aware that the mapping from rotation vectors to DCMs is not unique!
my_rotation_vector = SO3.decompose(my_dcm);

% Getting inverse and adjoint representations of the SE3 element is easy.
inv_element_SE3 = SE3.inverse(element_SE3);
adj_element_SE3 = SE3.adjoint(element_SE3);

% It's simple to take the logmap too.  
element_se3alg = SE3.logMap(element_SE3);

% We can apply any operation we'd expect to elements of the Lie algebra.
% Map to R^6 using the vee operator. 
xi = se3alg.vee(element_se3alg);
% Map back to the Lie algebra using the wedge operator.
element_se3alg = se3alg.wedge(xi);
% Get the adjoint representation.
adj_se3alg = se3alg.adjoint(element_se3alg);
% Decompose into xi_phi and xi_rho directly, e.g. for plotting. 
[ xi_phi, xi_rho ] = se3alg.decompose(element_se3alg);

% Synthesize an element of se3alg directly from a column vector.
another_element_se3alg = se3alg.synthesize(rand(6, 1));
% Again, if you need to provide inputs of the correct form. 
% bad_element_se3alg = se3alg.synthesize(rand(5, 2));

% Finally, can easily map an element of the Lie algebra back down to the
% group. 
element_SE3 = se3alg.expMap(another_element_se3alg);


%% Use case
% Consider the prediction step in an IEKF in SE2.  From Section 6 of the
% IEKF doc, this may look like the following:
dt = 0.01;       % timestep [s]
u_g_km1 = -0.05; % gyro measurement [rad / s]
u_w_km1 = 0.06;  % wheel odometry measurement [m / s]
X_hat_km1 = SE2.synthesize(SO2.synthesize(rand(1)), rand(2, 1));

% Propogate mean estimate forward.
psi_km1 = so2alg.expMap(so2alg.wedge(dt * u_g_km1));
xi_km1 = [ psi_km1, dt * [u_w_km1; 0]; 0, 0, 1 ];
X_check_k = X_hat_km1 * xi_km1;

% Need A_km1 to propogate the covariance.
A_km1 = SE2.adjoint(inv(xi_km1));

% The correction step may look like the following.
% Compute the innovation.  Augment with an extra zero to get correct
% dimension. 
y_k = rand(2, 1);
[ ~, y_check_k ] = SE2.decompose(X_check_k);
z_k = X_check_k \ [ (y_k - y_check_k); 0 ];

% State correction
K_k = rand(3, 2);
X_hat_k = X_check_k * se2alg.expMap(-se2alg.wedge(K_k * z_k(1:2)));

% Plotting errors is easy using the decompose function. 
[ C_tbk, r_bkt_t ] = SE2.decompose(X_hat_k);
theta_bt = SO2.decompose(C_tbk);

