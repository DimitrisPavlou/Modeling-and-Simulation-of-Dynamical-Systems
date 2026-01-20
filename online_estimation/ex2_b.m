clc; clear; close all; 


% system parameters
a1 = 1.315; a2 = 0.725; a3 = 0.225; b = 1.175;
rd_bar = pi/10; 

gamma = 1/8;
rd_func = @(t) rd_bar * exp(- gamma * (t-10)^2);
d_func = @(t) 0;


params.phi0 = 100; 
params.phi_inf = 0.001; 
params.rho = 100; 
params.k1 = 100; 
params.k2 = 100;
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
legend("$\hat{a_1}$", "$a_1$", "$\hat{a_2}$", "$a_2$", "$\hat{a_3}$", "$a_3$", "$\hat{b}$", "$b$", 'interpreter', 'latex');
grid on;



