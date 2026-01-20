function dz = gradient_method_ode(t, z, u_func, l1, l2, Gamma, m, b, k)
    % z is the stacked vector of
    %   z(1:2)   = x      = [x1; x2]           (true position & velocity)
    %   z(3:4)   = [phi1; \dot{phi1}]          (filter states for φ₁)
    %   z(5:6)   = [phi2; \dot{phi2}]          (filter states for φ₂)
    %   z(7:8)   = [phi3; \dot{dphi3}]          (filter states for φ₃)
    %   z(9:11)  = \hat{theta}  (parameter estimates)
    
    % Unpack true system state
    x   = z(1:2);      
    % Unpack each 2‐state filter
    f1  = z(3:4);     
    f2  = z(5:6);     
    f3  = z(7:8);      
    % 3) Unpack parameter vector
    theta_hat = z(9:11);
    
    % 4) Evaluate the input at time t
    u = u_func(t);
    
    %True mass‐spring‐damper dynamics 
    dx = [ 
        x(2);
       -(k/m)*x(1) - (b/m)*x(2) + (1/m)*u
    ];
    
    f1_dot = [
        f1(2);
       -l1*f1(2) - l2*f1(1) - dx(1)
    ];
   
    f2_dot = [
        f2(2);
       -l1*f2(2) - l2*f2(1) - x(1)
    ];
    
    f3_dot = [
        f3(2);
       -l1*f3(2) - l2*f3(1) + u
    ];
    
    % Assemble the regressor vector φ(t)
   
    phi = [ f1(1); f2(1); f3(1) ];
    
    % Compute the prediction of the measured output x₁
    x_hat = theta_hat' * phi;
    
    % Compute the output error
    e = x(1) - x_hat;
    
    % Gradient adaptation law
    dtheta = Gamma * e * phi;
    
    % Pack all derivatives into the single vector dz
    dz = [
        dx;        % true system
        f1_dot;    % filter 1 dynamics
        f2_dot;    % filter 2 dynamics
        f3_dot;    % filter 3 dynamics
        dtheta     % parameter update
    ];
end



