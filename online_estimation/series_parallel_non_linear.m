function dz = series_parallel_non_linear(t, z, rd_func, system_params, model_params, d)
    
    if nargin < 6 
        noise = @(t) 0 ; 
    else 
        noise = d;
    end

    % system params
    phi0 = system_params.phi0;
    phi_inf = system_params.phi_inf; 
    rho = system_params.rho;
    k1 = system_params.k1;
    k2 = system_params.k2; 
    l = system_params.l;
    am = model_params.am; 

    Gamma1 = model_params.gamma1; 
    gamma2 = model_params.gamma2;
    % Unpack
    r    = z(1:2);
    rhat = z(3:4);
    theta_hat = z(5:7);
    bhat = z(8);

    % controller signal
    u = controller(t, r, rd_func, phi0, phi_inf, l, rho, k1, k2);
    % Estimation error
    e2 = r(2) - rhat(2);
    % True system dynamics
    rdot =  non_linear_model_ode(t, r, rd_func, noise, system_params);
    
    % Series-parallel estimator dynamics 
    rhat_dot = [
            r(2) + am * (r(1) - rhat(1))  ;
            theta_hat' * [-r(2); -sin(r(1)) ; r(2)^2 * sin(2 * r(1))] + bhat * u + am * (r(2) - rhat(2))
        ];

    % Parameter adaptation laws
    theta_hat_dot = Gamma1 * (e2 * [-r(2), -sin(r(1)), r(2)^2 * sin(2 * r(1))]');
    bhat_dot = gamma2 * (e2 * u');

    % Pack derivative
    dz = [rdot; rhat_dot; theta_hat_dot; bhat_dot];
    
end
