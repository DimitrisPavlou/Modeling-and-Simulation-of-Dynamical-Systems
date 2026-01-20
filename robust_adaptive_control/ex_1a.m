clear; clc; close all;
% True system parameters
A = [-2.15, 0.25;
     -0.75, -2];
B = [0; 1.5];


% %Adaptation gains
GA = [110.4 100; 278 50]; 
GB = [110; 100];


% Simulation settings
T = 40; % total simulation time (s)
dt = 1e-4;
tspan = 0:dt:T;
% Initial conditionsD
x0 = [0; 0];    % true state initial
xhat_0 = [0;0]; 
a11_hat0 = -2; a12_hat0 = 1; 
a21_hat0 = 0; a22_hat0 = -1; 
b1_hat0 = 0; b2_hat0 = 2 ;

%initial condition vector for ode45
z0 = [x0; xhat_0; a11_hat0; a12_hat0; a21_hat0; a22_hat0; b1_hat0; b2_hat0];
% Integrate with ode45
u = @(t)(2.5*sin(t) + 2*sin(2*t));
    
theta_m = 50;
[t, z1] = ode45(@(t,z) projected_lyapunov(t, z, A, B, GA, GB, theta_m, u), tspan, z0);

% Plotting
plots(t,z1);


