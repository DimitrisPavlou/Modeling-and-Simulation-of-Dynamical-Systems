clear; clc; close all;
% True system parameters
m = 1.315;    b = 0.225;   k = 0.725;
A = [0, 1;
     -k/m, -b/m];
B = [0; 1/m];


% Adaptation gains
gamma = [1 1 1];

% Simulation settings
T = 100; % total simulation time (s)
dt = 1e-4;
tspan = 0:dt:T;
% Initial conditions
x0      = [0; 0];    % true state initial
x2_hat0 = 0;      % estimator state initial
a1_hat0 = -0.58; a2_hat0 = -0.15; b0_hat0 = 0.6;
z0 = [x0; x2_hat0; a1_hat0; a2_hat0; b0_hat0];
% Integrate with ode45
[t, z1] = ode45(@(t,z) parallel(t, z, A, B, gamma), tspan, z0);
% Unpack results
x1     = z1(:, 1:2);
x2_hat_1  = z1(:, 3);
a1_hat = z1(:, 4); 
a2_hat = z1(:,5); 
b0_hat = z1(:,6);
mhat1 = 1./b0_hat;
khat1 = - mhat1 .* a1_hat;
bhat1 = - mhat1 .* a2_hat;
%error_pos1 = x1(:,1) - xhat1(:,1);
error_vel1 = x1(:, 2) - x2_hat_1;
% Plotting

figure(1); 
plot(t, x1(:,2),LineWidth=1.5);
hold on;
plot(t, x2_hat_1, 'LineStyle', '--', 'LineWidth',2, Color = "#FF0000");
legend('$x_2$','$\hat{x_2}$', 'interpreter', 'latex', 'FontSize', 12); 
ylabel('Value', 'FontSize',12);
xlabel("Time (s)");
title("Estimation of $\dot{x}(t)$ ( Parallel topoloygy )", 'Interpreter','latex', 'FontSize',12); 
grid on;

figure(2);
plot(t, error_vel1, LineWidth = 1.5);
xlabel("Time (s)");
ylabel('Value');
legend("$e_2 = x_2(t) - \hat{x_2}(t)$", 'Interpreter','latex', 'FontSize',12);
title("Error (Parallel Topology)")
grid on;


figure(3);
plot(t, mhat1,'LineWidth',1.5); hold on;
yline(m,'r--','LineWidth',1, 'Color', "#0072BD");

hold on;
plot(t, khat1,'LineWidth',1.5); hold on;
yline(k,'r--','LineWidth',1, 'Color', "#D95319");

hold on;
plot(t, bhat1,'LineWidth',1.5); hold on;
yline(b,'r--','LineWidth',1, 'Color', "#EDB120");
xlabel('Time (s)');
legend("$\hat{m}$", "$m$", "$\hat{k}$", "$k$", "$\hat{b}$", "$b$", 'interpreter', 'latex');
title("Parameter Estimation");
grid on;

%==========================================================================

% Integrate with ode45
theta_m = 5;
% Adaptation gains
gamma = [12 12 4];
% Simulation settings
T = 40; % total simulation time (s)
dt = 1e-4;
tspan = 0:dt:T;
% Initial conditions
x0      = [0; 0];    % true state initial
xhat0   = [0.1; 0];      % estimator state initial
a1_hat0 = -0.6; 
a2_hat0 = -0.3; 
b0_hat0 = 0.6;
z0 = [x0; xhat0; a1_hat0; a2_hat0; b0_hat0];
[t, z2] = ode45(@(t,z) seriesParallel(t, z, A, B, gamma, theta_m), tspan, z0);

% Unpack results
x1     = z2(:, 1:2);
xhat1  = z2(:, 3:4);
a1_hat = z2(:, 5); 
a2_hat = z2(:,6); 
b0_hat = z2(:,7);
mhat1 = 1./b0_hat;
khat1 = - mhat1 .* a1_hat;
bhat1 = - mhat1 .* a2_hat;
error_pos1 = x1(:,1) - xhat1(:,1);
error_vel1 = x1(:, 2) - xhat1(:, 2);

% Plotting
figure(4);
plot(t, x1(:,1),LineWidth=1.5);
hold on; 
plot(t, xhat1(:,1), LineStyle = '--', LineWidth=2, Color="#FF0000")
legend('$x_1$','$\hat{x_1}$', 'interpreter', 'latex', 'FontSize', 12); 
ylabel('Value');
xlabel("Time (s)");
title("Estimation of $x(t)$ (Series-Parallel topology)", 'Interpreter','latex'); 
grid on;

figure(5); 
plot(t, x1(:,2),LineWidth=1.5);
hold on; 
plot(t, xhat1(:,2), LineStyle = '--', LineWidth=2, Color="#FF0000")
legend('$x_2$','$\hat{x_2}$', 'interpreter', 'latex', 'FontSize', 12); 
ylabel('Value');
title("Estimation of $\dot{x}(t)$ (Series-Parallel topology)", 'Interpreter','latex', 'FontSize', 12); 
grid on;

figure(6);
plot(t, error_pos1, LineWidth=1.5);
hold on ; 
plot(t, error_vel1, LineWidth = 1.5);
xlabel("Time (s)");
ylabel('Value');
title("Errors $e_{x_1} = x_1 - \hat{x_1}$, $e_{x_2} = x_2 - \hat{x_2}$ (Series-Parallel topology)", 'interpreter', 'latex','FontSize',12);
legend("$e_{x_1}$", "$e_{x_2}$", 'interpreter', 'latex', 'FontSize', 12);
grid on;


figure(7);
plot(t, mhat1,'LineWidth',1.5); hold on;
yline(m,'r--','LineWidth',1, 'Color', "#0072BD");

hold on;
plot(t, khat1,'LineWidth',1.5); hold on;
yline(k,'r--','LineWidth',1, 'Color', "#D95319");

hold on;
plot(t, bhat1,'LineWidth',1.5); hold on;
yline(b,'r--','LineWidth',1, 'Color', "#EDB120");
xlabel('Time (s)');
legend("$\hat{m}$", "$m$", "$\hat{k}$", "$k$", "$\hat{b}$", "$b$", 'interpreter', 'latex');
title("Parameter Estimation");
grid on;