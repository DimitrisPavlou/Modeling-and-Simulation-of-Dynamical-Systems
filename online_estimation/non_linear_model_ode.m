function dr = non_linear_model_ode(t, r, rd_func, d, params) 
    
    
    phi0 = params.phi0;
    phi_inf = params.phi_inf; 
    rho = params.rho;
    k1 = params.k1;
    k2 = params.k2; 
    l = params.l;
    a1 = 1.315; a2 = 0.725; a3 = 0.225; b = 1.175;

    dr = [
            r(2); 
            -a1*r(2) - a2*sin(r(1)) + a3 * r(2)^2*sin(2*r(1)) + b*controller(t, r, rd_func, phi0, phi_inf, l, rho, k1, k2) + d(t)      
    ];

end