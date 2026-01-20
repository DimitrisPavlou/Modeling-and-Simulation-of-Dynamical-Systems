clc; clear; close all; 


% system parameters
a1 = 1.315; a2 = 0.725; a3 = 0.225; b = 1.175;
rd_bar = pi/10; 

gamma = 1/8;
rd_func = @(t) rd_bar * exp(- gamma * (t-10)^2);
d_func = @(t) 0.15 * sin(0.5 * t);


params.phi0 = 100; 
params.phi_inf = 0.001; 
params.rho = 2; 
params.k1 = 10; 
params.k2 = 10;
params.l = 1;

model_params.am = 4; 
model_params.gamma1 = [545 0 0; 0 18 0; 0 0 1800]; 
model_params.gamma2 = 64;

Tfinal = 20; 
dt = 1e-4; 
tspan = 0:dt:Tfinal;


z0 = [0; 0; -0.5; 0; 2; 1 ; 0 ;0.5];
[t, R] = ode45(@(t,z) series_parallel_non_linear(t,z, rd_func, params, model_params, d_func), tspan, z0);

r1 = R(:,1); 
rhat1 = R(:,3); 
theta_hat = R(:, 5:7);
bhat = R(:, 8);


figure(1); 
plot(t, r1, LineWidth=1.5); 
hold on; 
plot(t, rhat1, LineStyle = '--', LineWidth=2, Color="#FF0000");
legend("$r(t)$", "$\hat{r}(t)$", 'interpreter', 'latex', 'FontSize',12);
title("Estimation of $r(t)$", 'interpreter', 'latex', 'FontSize',12);
grid on;

error = r1 - rhat1; 
figure; 
plot(t, error, LineWidth=1.5);
title("Error $e_{r}(t) = r(t) - \hat{r}(t)$", 'interpreter', 'latex', "FontSize",12);
grid on;


figure;
plot(t, theta_hat(:,1),'LineWidth',1.5); hold on;
yline(a1,'r--','LineWidth',1, 'Color', "#0072BD");

hold on;
plot(t, theta_hat(:,2),'LineWidth',1.5); hold on;
yline(a2,'r--','LineWidth',1, 'Color', "#D95319");

hold on;
plot(t, theta_hat(:,3),'LineWidth',1.5); hold on;
yline(a3,'r--','LineWidth',1, 'Color', "#EDB120");

hold on;
plot(t, bhat,'LineWidth',1.5); hold on;
yline(b,'r--','LineWidth',1, 'Color', "#7E2F8E");

title("Parameter Estimation");
xlabel('Time (s)');
legend("$\hat{a_1}$", "$a_1$", "$\hat{a_2}$", "$a_2$", "$\hat{a_3}$", "$a_3$", "$\hat{b}$", "$b$", 'interpreter', 'latex', 'Location','north');
grid on;



% Study the effect of disturbance amplitude on parameter estimation accuracy

d0_vals = linspace(0.2 , 2, 10); % disturbance amplitudes
errors = zeros(length(d0_vals), 4); % [a1, a2, a3, b]
mse_r = zeros(length(d0_vals), 1);

for i = 1:length(d0_vals)
    d0 = d0_vals(i);
    d_func_test = @(t) d0 * sin(0.5 * t);

    z0 = [0; 0; -0.5; 0; 2; 1 ; 0 ;0.5];
    [t_test, R_test] = ode45(@(t,z) series_parallel_non_linear(t,z, rd_func, params, model_params, d_func_test), tspan, z0);

    r1_test = R_test(:,1);
    rhat1_test = R_test(:,3);
    theta_hat_test = R_test(:, 5:7);
    bhat_test = R_test(:, 8);

    % Use the last 20% of time for steady-state error estimation
    idx_last = round(length(t_test)*0.8):length(t_test);
    errors(i,1) = abs(mean(theta_hat_test(idx_last,1)) - a1);
    errors(i,2) = abs(mean(theta_hat_test(idx_last,2)) - a2);
    errors(i,3) = abs(mean(theta_hat_test(idx_last,3)) - a3);
    errors(i,4) = abs(mean(bhat_test(idx_last)) - b);

    % MSE for r1 estimation
    mse_r(i) = mean((r1_test - rhat1_test).^2);
end

% Plot absolute parameter errors
figure;
plot(d0_vals, errors(:,1), '-o', 'DisplayName', '$|\hat{a}_1 - a_1|$', 'LineWidth',1.5); hold on;
plot(d0_vals, errors(:,2), '-s', 'DisplayName', '$|\hat{a}_2 - a_2|$', 'LineWidth',1.5);
plot(d0_vals, errors(:,3), '-^', 'DisplayName', '$|\hat{a}_3 - a_3|$', 'LineWidth',1.5);
plot(d0_vals, errors(:,4), '-d', 'DisplayName', '$|\hat{b} - b|$', 'LineWidth',1.5);
xlabel('Disturbance Amplitude $d_0$', 'Interpreter','latex');
ylabel('Absolute Estimation Error', 'Interpreter','latex');
legend('Interpreter','latex', 'Location', 'northwest');
title('Effect of Disturbance Amplitude on Parameter Estimation', 'Interpreter','latex');
grid on;

% Plot MSE of r(t)
figure;
plot(d0_vals, mse_r, '-o', 'LineWidth', 1.5, 'Color', '#0072BD');
xlabel('Disturbance Amplitude $d_0$', 'Interpreter','latex');
ylabel('MSE of $r(t) - \hat{r}(t)$', 'Interpreter','latex');
title('MSE of Estimation vs Disturbance Amplitude', 'Interpreter','latex');
grid on;




