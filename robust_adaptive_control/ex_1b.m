clear; clc; close all;

% True system parameters
A_true = [-2.15, 0.25;
          -0.75, -2];
B_true = [0; 1.5];

% Simulation settings
T  = 40;       % total simulation time (s)
dt = 1e-4;
tspan = 0:dt:T;

% Initial conditions for [x; xhat; Ahat(:); Bhat(:)]
x0 = [0;0];
xhat0 = [0;0];
a11_0 = -2;  a12_0 = 1;
a21_0 = 0;  a22_0 = -1;
b1_0  =  0;  b2_0  =  2;
z0 = [x0; xhat0; a11_0; a12_0; a21_0; a22_0; b1_0; b2_0];

% Adaptation gains
GA_eps = [110.4 100; 278 50]; 
GB_eps = [110; 100];

GA_sigma= [500 100; 274.5 50]; 
GB_sigma = [110; 100];

% Input signal and bias
u = @(t) (2.5*sin(t) + 2*sin(2*t));

%pick bias term (by default set to sinusodial) and omega_0 (by default set
%to 0.0125 according to the report).


%constant omega(t)
% omega0 = 0.0125;
% omega = @(t) omega0 * ones(2,1)/sqrt(2);

% % sinusodial omega(t)
omega0 = 0.0125;
omega = @(t) omega0 * [sin(0.1*t); cos(0.1*t)]/sqrt(2);

% epsilon‑modification parameter
v0 = 1e-4;

% sigma‑modification parameters
sigmaA = 1e-4;    
sigmaB = 1e-4;    

% theta_m parameter of the series parallel model
theta_m_eps = 50;
theta_m_sigma = 100;

% %Run epsilon‑modification
[te, z_eps] = ode45(@(t,z) projected_lyapunov_eps_mod(...
                      t, z, A_true, B_true, GA_eps, GB_eps, theta_m_eps, u, omega, v0),...
                     tspan, z0);

%Run sigma‑modification
[ts, z_sig] = ode45(@(t,z) projected_lyapunov_sigma_mod(...
                      t, z, A_true, B_true, GA_sigma, GB_sigma, theta_m_sigma, u, omega, sigmaA, sigmaB),...
                     tspan, z0);


plots(te, z_eps, "Epsilon Modification");
plots(ts, z_sig, "Sigma Modification");