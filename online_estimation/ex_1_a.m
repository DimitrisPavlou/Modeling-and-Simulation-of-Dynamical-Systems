% gradient_parametric_estimator.m
clear; close all; clc;

% true system parameters (unknown in practice)
m = 1.315;
b = 0.225;
k = 0.725;
% choose filter denominator Λ(s) = s^2 + l1 s + l2 (for linearly
% parametrized form)
l1 = 2;
l2 = 3;
% compute the true θ vector for x = θ^T φ:
theta_true = [ b/m - l1;
               k/m - l2;
               1/m];
% time span
Tfinal = 20;
dt = 1e-4;
tspan = 0:dt:Tfinal;
% gradient adaptation gain
Gamma1 = [335 0 0 ; 0 1800 0 ; 0 0 1.58];

% initial conditions:
% z = [ x(1); x(2);   f1(1);f1(2);  f2(1);f2(2);  f3(1);f3(2);   theta1;theta2;theta3 ]
x0       = [0; 0];                      % initial true state
phi1_0     = [0; 0];                      % filter φ1 states
phi2_0     = [0; 0];                      % filter φ2 states
phi3_0     = [0; 0];                      % filter φ3 states
theta0   = [1; 1; 0.7];                   % initial parameter estimates
z0 = [ x0; phi1_0; phi2_0; phi3_0; theta0 ]; 

%==========================================================================


% input signal u(t) = 2.5 as a function handle
u_func = @(t) 2.5;
% integrate using ode45
opts = odeset('RelTol',1e-6,'AbsTol',1e-7);
[t, z] = ode45(@(t,z) gradient_method(t,z,u_func,l1,l2,Gamma1,m,b,k), ...
               tspan, z0, opts);
% extract
x1   = z(:,1);           % true position
x2   = z(:,2);           % true velocity
f1   = z(:,3);           % φ1 = f1(1)
f2   = z(:,5);           % φ2 = f2(1)
f3   = z(:,7);           % φ3 = f3(1)
theta1_hat = z(:,9); 
theta2_hat = z(:,10); 
theta3_hat = z(:, 11); 
%parameter estimation
mhat = 1./theta3_hat; 
khat = (l2 + theta2_hat)./theta3_hat;
bhat = (l1 + theta1_hat)./theta3_hat;

% reconstruct output estimate: x̂(t) = θ̂' φ
xhat = theta1_hat.*f1 + theta2_hat.*f2 + theta3_hat.*f3;
% compute the error e_x(t) = x(t) - xhat(t)
error = x1 - xhat;

% Plot results
figure(1);
plot(t, x1, 'LineWidth',1.5); hold on;
plot(t, xhat,'LineStyle', '--', 'LineWidth',2, Color = "#FF0000");
set(gca, 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Position', 'FontSize', 12);
legend({'True $x_1$', 'Estimated $\hat{x}_1$'}, 'Interpreter', 'latex', 'FontSize', 14);
grid on;


figure(2); 
plot(t, error, LineWidth=1.5); 
grid on; 
set(gca, 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 12);
ylabel("Value")
title("Error $e_{x_1} = x_1 - \hat{x_1}$", 'Interpreter','latex');


figure(3);
subplot(3,1,1);
plot(t, mhat,'LineWidth',1.5); 
hold on;
yline(m,'r--','LineWidth', 2, Color ="#FF0000");
legend('m estimate','m true', 'FontSize', 10);
title("Parameter Estimation", 'FontSize',12);
grid on;

subplot(3,1,2);
plot(t, khat,'LineWidth',1.5); hold on;
yline(k,'r--','LineWidth',2, Color ="#FF0000");
legend('k estimate','k true', 'FontSize', 10);
grid on;

subplot(3,1,3);
plot(t, bhat,'LineWidth',1.5); hold on;
yline(b,'r--','LineWidth',2, Color ="#FF0000");
xlabel('Time (s)');
legend('b estimate','b true', 'FontSize', 10);
grid on;


%==========================================================================
Gamma2 = [310 0 0; 0 1300 0 ; 0 0 1.7];
% initial conditions:
% z = [ x(1); x(2);   f1(1);f1(2);  f2(1);f2(2);  f3(1);f3(2);   theta1;theta2;theta3 ]
x0       = [0; 0];                      % initial true state
phi1_0     = [0; 0];                      % filter φ1 states
phi2_0     = [0; 0];                      % filter φ2 states
phi3_0     = [0; 0];                      % filter φ3 states
theta0   = [1; 1; 0.7];                   % initial parameter estimates
z0 = [ x0; phi1_0; phi2_0; phi3_0; theta0 ]; 
% input signal u(t) = 2.5sin(t) as a function handle
u_func = @(t) 2.5 * sin(t);
% integrate using ode45
opts = odeset('RelTol',1e-6,'AbsTol',1e-7);
[t, z] = ode45(@(t,z) gradient_method(t,z,u_func,l1,l2,Gamma2,m,b,k), ...
               tspan, z0, opts);
% extract
x1   = z(:,1);           % true position
x2   = z(:,2);           % true velocity
f1   = z(:,3);           % φ1 = f1(1)
f2   = z(:,5);           % φ2 = f2(1)
f3   = z(:,7);           % φ3 = f3(1)
theta1_hat = z(:,9); 
theta2_hat = z(:,10); 
theta3_hat = z(:, 11);

% parameter estimation
mhat = 1./theta3_hat; 
khat = (l2 + theta2_hat)./theta3_hat;
bhat = (l1 + theta1_hat)./theta3_hat;
% reconstruct output estimate: x̂(t) = θ̂' φ
xhat = theta1_hat.*f1 + theta2_hat.*f2 + theta3_hat.*f3;
% compute the error e_x(t) = x(t) - xhat(t)
error2 = x1 - xhat;

% Plot results
figure(4);
plot(t, x1, 'LineWidth',1.5); hold on;
plot(t, xhat,'LineStyle', '--', 'LineWidth',2, Color = "#FF0000");
set(gca, 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Position', 'FontSize', 12);
legend({'True $x_1$', 'Estimated $\hat{x}_1$'}, 'Interpreter', 'latex', 'FontSize', 14);
grid on;


figure(5); 
plot(t, error, LineWidth=1.5); 
grid on; 
set(gca, 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 12);
ylabel("Value")
title("Error $e_{x_1} = x_1 - \hat{x_1}$", 'Interpreter','latex');

figure(6);
subplot(3,1,1);
plot(t, mhat,'LineWidth',1.5); hold on;
yline(m,'r--','LineWidth',2, Color ="#FF0000");
legend('m estimate','m true', 'FontSize', 10);
title("Parameter Estimation", 'FontSize',12);
grid on;

subplot(3,1,2);
plot(t, khat,'LineWidth',1.5); hold on;
yline(k,'r--','LineWidth',2, Color ="#FF0000");
legend('k estimate','k true', 'FontSize', 10);
grid on;

subplot(3,1,3);
plot(t, bhat,'LineWidth',1.5); hold on;
yline(b,'r--','LineWidth',2,Color ="#FF0000");
xlabel('Time (s)'); 
legend('b estimate','b true', 'FontSize', 10);
grid on;

