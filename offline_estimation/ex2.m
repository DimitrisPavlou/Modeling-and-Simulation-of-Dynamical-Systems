clear; clc; close all; 
%problem parameters 
g = 9.81; L = 1.25; m = 0.75; c = 0.15; A0 = 4 ; w = 2; Ts = 0.1;
% odeFun 
odeFun = @(t, x) [x(2); -g/L * x(1) - c/(m*L^2) * x(2) + 1/(m*L^2) * A0*sin(w*t)];
%solve numerically using ode45
dt = 1e-4;  
t = 0:dt:20; 
x0 = [0; 0]; 
%solve the ode to calculate the measurable state vector
[t , x] = ode45(odeFun, t, x0);
u = A0*sin(w*t);

%we consider x and u our known data

%sample with Ts 
%step value
step = round(Ts/dt);
%sampled time steps
ts = t(1:step:end);
%sampled state vector at sampled timesteps
xs = x(1:step:end, :); 
%sampled input vector at sampled timesteps
us = u(1:step:end);


%filter parameters  Λ(s) = s + l1*s + l2 

l2 = 1;
l1 = 1; 

%2.a: The whole state vector is known so we know both X1(s) and X2(s)
[L_hat, m_hat, c_hat] = estimate_params(xs, us, ts, [l1, l2], 1);

fprintf("state vector x(t) known: \n"); 
fprintf("Lhat = %f, L = %f, error = %f\n", L_hat, L, L-L_hat); 
fprintf("mhat = %f, m = %f, error = %f\n", m_hat, m, m - m_hat); 
fprintf("chat = %f, L = %f, error = %f\n\n\n", c_hat, c, c - c_hat); 

%find qhat by solving the differential equation with the estimated
%parameters
odefun_estimate = @(t,x) [x(2); -g/L_hat * x(1) - c_hat/(m_hat*L_hat^2) * x(2) + 1/(m_hat*L_hat^2) * A0*sin(w*t)];
[t, xhat1] = ode45(odefun_estimate, ts, x0); 

%find error
e1 = xs(:,1) - xhat1(:, 1);
% plot
figure(1); 
plot(t, xs(:,1), LineWidth=1.3);
hold on; 
plot(t, xhat1(:,1), LineWidth=1.3);
grid on; 
title("$q(t)$ and $\hat{q(t)}$ with measurable state vector x(t) and input u(t)", "Interpreter","latex");
legend(["q", "q estimate"]);
figure(2); 
plot(t, e1,  LineWidth=1.3); 
grid on; 
title("$e = q(t)-\hat{q(t)}$ with measurable state vector x(t) and input u(t)", "Interpreter","latex");

%================================================================================


% %2.b: in this case the whole state vector is not measurable, just the state 
% % x1 = q. We change the ζ1 filter accordingly. 


l1 = 1; 
l2 = 1; 
[L_hat, m_hat, c_hat] = estimate_params(xs, us, ts, [l1, l2], 0);
fprintf("only x1(t) measurable : \n"); 
fprintf("Lhat = %f, L = %f, error = %f\n", L_hat, L, L-L_hat); 
fprintf("mhat = %f, m = %f, error = %f\n", m_hat, m, m - m_hat); 
fprintf("chat = %f, L = %f, error = %f\n\n\n", c_hat, c, c - c_hat); 

%find qhat 
odefun_estimate = @(t, x) [x(2); -g/L_hat * x(1) - c_hat/(m_hat*L_hat^2) * x(2) + 1/(m_hat*L_hat^2) * A0*sin(w*t)];
[t, xhat2] = ode45(odefun_estimate, ts, x0); 

%find error
e2 = xs(:,1) - xhat2(:, 1);
%plot 
figure(3); 
plot(t, xs(:,1), LineWidth=1.3);
hold on;
plot(t, xhat2(:,1), LineWidth=1.3);
grid on; 
title("$q(t)$ and $\hat{q(t)}$ with measurable q(t) and input u(t)", "Interpreter","latex");
legend(["q", "q estimate"]);
figure(4); 
plot(t, e2, LineWidth=1.3); 
grid on; 
title("$e = q(t)-\hat{q(t)}$ with measurable state vector q(t) and input u(t)", "Interpreter","latex");





