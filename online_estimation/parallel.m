function dz = parallel(t, z, A_true, B_true, gamma, noise_func)
    
    if nargin < 6
        noise = 0; 
    else 
        noise = noise_func(t);
    end
    % Unpack
    x    = z(1:2);
    x = x + [noise; 0];
    x2_hat = z(3);
    a1_hat = z(4); 
    a2_hat = z(5);
    b0_hat = z(6);
    
    % Input signal
    u = 2.5*sin(t);   
    % Estimation error
    e = x(2) - x2_hat;
    % True-system dynamics
    xdot = A_true*x + B_true*u;
    % Estimator dynamics
    x2_hat_dot = a1_hat * x(1) + a2_hat * x2_hat + b0_hat * u;
    % Parameter adaptation lawσ
    a1_hat_dot = gamma(1) * x(1) * e; 
    a2_hat_dot = gamma(2) * x2_hat * e; 
    b0_hat_dot = gamma(3) * u * e;
    
    dz = [xdot; x2_hat_dot; a1_hat_dot; a2_hat_dot; b0_hat_dot];
end