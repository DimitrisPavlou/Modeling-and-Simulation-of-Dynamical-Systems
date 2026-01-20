function u = controller(t, r, rd, phi_0, phi_inf, l, rho, k1, k2)
    
    
    z1 = (r(1) - rd(t)) / ((phi_0 - phi_inf)*exp(-l * t) + phi_inf); 
    a = - k1 * log((1 + z1) / (1 - z1)); 
    z2 = (r(2) - a)/rho; 
    u = - k2 * log((1 + z2) / (1 - z2));
    
end