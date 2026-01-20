function dz = projected_lyapunov(t, z, A_true, B_true, Ga, Gb, theta_m, u)
   
    % Unpack
    x    = z(1:2);
    xhat = z(3:4);
    a11_hat = z(5); 
    a12_hat = z(6);
    a21_hat = z(7); 
    a22_hat = z(8);
    b1_hat = z(9);
    b2_hat = z(10);

    Ahat = [a11_hat, a12_hat; a21_hat a22_hat];
    Bhat = [b1_hat; b2_hat];
    % Input signal
    u = u(t);

    % Estimation error
    e = x - xhat;
    % True system dynamics
    xdot = A_true*x + B_true*u;
    
    % Series-parallel estimator dynamics 
    xhat_dot = Ahat*x + Bhat*u + theta_m * e;
    % Parameter adaptation laws (element wise for speed)
    Ahat_dot = Ga .* (e * x'); 
    Bhat_dot = Gb .* (e * u); 

    %projection
    lb_A = [-3, -Inf; -Inf, -Inf];
    ub_A = [-1, Inf; Inf, Inf]; 
    Ahat_dot = projection(Ahat, Ahat_dot, lb_A, ub_A);

    lb_B = [-Inf; 1]; 
    ub_B = [Inf; Inf];
    Bhat_dot = projection(Bhat, Bhat_dot, lb_B, ub_B);
    
    %pack derivative
    dz = [xdot; xhat_dot; reshape(Ahat_dot.', [],1) ; Bhat_dot(:)];
    
end