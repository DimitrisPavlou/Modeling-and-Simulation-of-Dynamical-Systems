clear; clc; close all;

% True system parameters
m = 1.315;    b = 0.225;   k = 0.725;
A = [0, 1;
     -k/m, -b/m];
B = [0; 1/m];

% Simulation settings
T = 100;
dt = 5e-4;
tspan = 0:dt:T;

% Adaptation gains
gamma1 = [1 1 1];
gamma2 = [12 12 4];
theta_m = 5;

% Initial conditions
x0      = [0; 0];
xhat0   = [0; 0];
x2_hat_0 = 0;
a1_hat0_1 = -0.58; a2_hat0_1 = -0.15; b0_hat0_1 = 0.6;
a1_hat0_2 = -0.6; a2_hat0_2 = -0.3; b0_hat0_2= 0.6; 
z0_1 = [x0; x2_hat_0; a1_hat0_1; a2_hat0_1; b0_hat0_1];
z0_2 = [x0; xhat0; a1_hat0_2; a2_hat0_2; b0_hat0_2];
% noise
noise_func = @(t) 0.25 *sin(2*pi*20*t);

%solve the same problem with noise
[t, z1] = ode45(@(t,z) parallel(t, z, A, B, gamma1, noise_func), tspan, z0_1);
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


[t, z2] = ode45(@(t,z) seriesParallel(t, z, A, B, gamma2, theta_m, noise_func), tspan, z0_2);

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



% check the effect of the amplitude of the noise added

% Noise amplitudes to test
eta_vals = [0.25, 1, 2, 5, 10, 20];

% Storage
n = length(eta_vals);
errors_m_sp = zeros(1, n); errors_k_sp = zeros(1, n); errors_b_sp = zeros(1, n);
errors_m_p  = zeros(1, n); errors_k_p  = zeros(1, n); errors_b_p  = zeros(1, n);
mse_x1_sp = zeros(1, n);
mse_x2_sp = zeros(1,n);
mse_x2_p  = zeros(1, n);

% Loop through noise amplitudes
for i = 1:n
    eta_0 = eta_vals(i);
    f0 = 20;
    noise = @(t) eta_0 * sin(2*pi*f0*t);

    % ----- Series-Parallel -----
    [t, z_sp] = ode45(@(t,z) seriesParallel(t, z, A, B, gamma2, theta_m, noise), tspan, z0_2);
    x1_sp = z_sp(:,1); x1_hat_sp = z_sp(:,3); 
    x2_sp = z_sp(:,2); x2_hat_sp = z_sp(:,4); 
    mse_x1_sp(i) = mean((x1_sp - x1_hat_sp).^2);
    mse_x2_sp(i) = mean((x2_sp - x2_hat_sp).^2);
    a1_hat = z_sp(:, 5); a2_hat = z_sp(:, 6); b0_hat = z_sp(:, 7);
    m_hat = 1 ./ b0_hat;
    k_hat = -m_hat .* a1_hat;
    b_hat = -m_hat .* a2_hat;
    N = round(length(t)*0.5);
    errors_m_sp(i) = mean(abs(m_hat(N:end) - m));
    errors_k_sp(i) = mean(abs(k_hat(N:end) - k));
    errors_b_sp(i) = mean(abs(b_hat(N:end) - b));

    % ----- Parallel -----
    [t, z_p] = ode45(@(t,z) parallel(t, z, A, B, gamma1, noise), tspan, z0_1);
    x2_p     = z_p(:, 2); x2_hat_p = z_p(:, 3);
    mse_x2_p(i) = mean((x2_p - x2_hat_p).^2);
    
    a1_hat = z_p(:, 4); a2_hat = z_p(:, 5); b0_hat = z_p(:, 6);
    m_hat = 1 ./ b0_hat;
    k_hat = -m_hat .* a1_hat;
    b_hat = -m_hat .* a2_hat;
    errors_m_p(i) = mean(abs(m_hat(N:end) - m));
    errors_k_p(i) = mean(abs(k_hat(N:end) - k));
    errors_b_p(i) = mean(abs(b_hat(N:end) - b));
end

% ---- Plotting Results ----
figure;
subplot(3,1,1);
plot(eta_vals, errors_m_sp, '-o', 'LineWidth', 1.5); hold on;
plot(eta_vals, errors_m_p, '--s', 'LineWidth', 1.5);
ylabel('Error in $\hat{m}$', 'Interpreter', 'latex', 'FontSize', 12);
legend('Series-Parallel', 'Parallel', 'Interpreter', 'latex', 'FontSize', 10);
grid on;

subplot(3,1,2);
plot(eta_vals, errors_k_sp, '-o', 'LineWidth', 1.5); hold on;
plot(eta_vals, errors_k_p, '--s', 'LineWidth', 1.5);
ylabel('Error in $\hat{k}$', 'Interpreter', 'latex', 'FontSize', 12);
grid on;

subplot(3,1,3);
plot(eta_vals, errors_b_sp, '-o', 'LineWidth', 1.5); hold on;
plot(eta_vals, errors_b_p, '--s', 'LineWidth', 1.5);
xlabel('Noise Amplitude $\eta_0$', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('Error in $\hat{b}$', 'Interpreter', 'latex', 'FontSize', 12);
grid on;

figure;
plot(eta_vals, mse_x2_sp, '-o', 'LineWidth', 1.5); hold on;
plot(eta_vals, mse_x2_p, '--s', 'LineWidth', 1.5);
xlabel('Noise Amplitude $\eta_0$', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('MSE of $\hat{x}_2$', 'Interpreter', 'latex', 'FontSize', 12);
legend('Series-Parallel', 'Parallel', 'Interpreter', 'latex', 'FontSize', 12);
grid on;
title('MSE of State Estimation $\hat{x}_2$ vs Noise', 'Interpreter', 'latex');

    
figure;
plot(eta_vals, mse_x1_sp, '-o', 'LineWidth', 1.5); 
xlabel('Noise Amplitude $\eta_0$', 'Interpreter', 'latex');
ylabel('MSE of $\hat{x}_1$', 'Interpreter', 'latex');
legend('Series-Parallel', 'Interpreter', 'latex');
grid on;
title('MSE of State Estimation $\hat{x}_1$ vs Noise', 'Interpreter', 'latex');

    
