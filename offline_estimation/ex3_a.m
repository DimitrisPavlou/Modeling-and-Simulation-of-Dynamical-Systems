clear; clc; close all; 
%problem parameters 
g = 9.81; L = 1.25; m = 0.75; c = 0.15; A0 = 4; w = 2; Ts = 0.1;
% odeFun 
odeFun = @(t, x) [x(2); -g/L * x(1) - c/(m*L^2) * x(2) + 1/(m*L^2) * A0*sin(w*t)];
%solve numerically using ode45
dt = 1e-4;  
t = 0:dt:20; 
x0 = [0; 0]; 
%solve the ode to calculate the measurable state vector
[t , x] = ode45(odeFun, t, x0);
u = A0*sin(w*t);

%sample with Ts 
%step value
step = round(Ts/dt);
%sampled time steps
ts = t(1:step:end);
%sampled state vector at sampled timesteps
xs = x(1:step:end, :); 
%sampled input vector at sampled timesteps
us = u(1:step:end);

%add white gaussian noise to the sampled data 

a = 1; 
sigma_u = max(abs(us))*a/100; 
sigma_x1 = max(abs(xs(:,1)))*a/100;  
sigma_x2 = max(abs(xs(:,2)))*a/100; 

x1_noisy = xs(:,1) + sigma_x1*randn(size(xs(:,1))); 
x2_noisy = xs(:,2) + sigma_x2*randn(size(xs(:,2)));
xs_noisy = [x1_noisy, x2_noisy];
us_noisy = us + sigma_u*randn(size(us));

%filter parameters  Λ(s) = s^2 + l1 * s + l2
l2 = 1; 
l1 = 1; 

[L_hat, m_hat, c_hat] = estimate_params(xs_noisy, us_noisy, ts, [l1, l2], 1);

odefun_estimate = @(t,x) [x(2); -g/L_hat * x(1) - c_hat/(m_hat*L_hat^2) * x(2) + 1/(m_hat*L_hat^2) * A0*sin(w*t)];
[t, xhat1] = ode45(odefun_estimate, ts, x0); 

%find error
e1 = xs(:,1) - xhat1(:, 1);
% plot
figure(1); 
plot(t, xs(:, 1), LineWidth=1.3);
hold on;
plot(t, xhat1(:,1), LineWidth=1.3);
grid on; 
title("$q(t)$ and $\hat{q(t)}$ with measurable state vector x(t) and input u(t)", "Interpreter","latex");
legend(["q", "q estimate"]);

figure(2); 
plot(t, e1, LineWidth=1.3); 
grid on; 
title("$e = q(t)-\hat{q(t)}$ with measurable state vector x(t) and input u(t)", "Interpreter","latex");




[L_hat, m_hat, c_hat] = estimate_params(xs_noisy, us_noisy, ts, [l1, l2], 0);

odefun_estimate = @(t,x) [x(2); -g/L_hat * x(1) - c_hat/(m_hat*L_hat^2) * x(2) + 1/(m_hat*L_hat^2) * A0*sin(w*t)];
[t, xhat2] = ode45(odefun_estimate, ts, x0); 

%find error
e2 = xs(:,1) - xhat2(:, 1);
% plot
figure(3); 
plot(t, xs(:, 1), LineWidth=1.3);
hold on;
plot(t, xhat2(:,1), LineWidth=1.3);
grid on; 
title("$q(t)$ and $\hat{q(t)}$ with measurable q(t) and input u(t)", "Interpreter","latex");
legend(["q", "q estimate"]);


figure(4); 
plot(t, e2, LineWidth=1.3); 
grid on; 
title("$e = q(t)-\hat{q(t)}$ with measurable q(t) and input u(t)", "Interpreter","latex");



