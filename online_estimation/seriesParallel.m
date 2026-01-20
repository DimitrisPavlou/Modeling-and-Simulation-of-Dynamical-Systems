function dz = seriesParallel(t, z, A_true, B_true, gamma, theta_m, noise_func)
    
    if nargin < 7 
        noise = 0 ; 
    else 
        noise = noise_func(t);
    end
    
    % Unpack
    x    = z(1:2);
    xhat = z(3:4);
    a1_hat = z(5); 
    a2_hat = z(6);
    b0_hat = z(7);
    

    % Input signal
    u = 2.5*sin(t);
    
    % Estimation error
    e = x + [noise; 0] - xhat;

    % True system dynamics
    xdot = A_true*x + B_true*u;

    % Series-parallel estimator dynamics (with estimated Ahat and injection term)
    xhat_dot = [0 1 ; a1_hat a2_hat]*x + [0; b0_hat]*u + theta_m * e;

    % Parameter adaptation laws
    a1_hat_dot = gamma(1) * e(2) * x(1); 
    a2_hat_dot = gamma(2) * e(2) * x(2);
    b0_hat_dot = gamma(3) * e(2) * u;
    % Pack derivative
    dz = [xdot; xhat_dot; a1_hat_dot; a2_hat_dot; b0_hat_dot];
end
