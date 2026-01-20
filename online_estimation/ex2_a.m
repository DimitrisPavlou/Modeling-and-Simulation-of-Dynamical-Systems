clc; clear; close all; 

% system parameters
a1 = 1.315; a2 = 0.725; a3 = 0.225; b = 1.175;
rd_bar = pi/10; 

beta = 1/8;
rd_func1 = @(t) rd_bar * exp(- beta * (t-10)^2);
rd_func2 = @(t) pi/20 * (1 - cos(pi*t/10));
d_func = @(t) 0; 


params.phi0 = 100; 
params.phi_inf = 0.01; 
params.rho = 100; 
params.k1 = 100; 
params.k2 = 100;
params.l = 1;

Tfinal = 20; 
dt = 1e-4; 
tspan = 0:dt:Tfinal;
[t, r1] = ode45(@(t,r) non_linear_model_ode(t, r, rd_func1, d_func, params), tspan, [0;0]);

[t, r2] = ode45(@(t,r) non_linear_model_ode(t, r, rd_func2, d_func, params), tspan, [0;0]);

rd_curve1 = rd_bar * exp(- beta * (tspan-10).^2);
error1 = rd_curve1' - r1(:,1);

rd_curve2 = pi/20 * (1 - cos(pi*tspan/10));
error2 = rd_curve2' - r2(:,1);
phi_curve = (params.phi0 - params.phi_inf) * exp(-params.l * tspan) + params.phi_inf;


figure(1); 
plot(tspan, rd_curve1, LineWidth=1.5); 
hold on;
plot(t, r1(:,1), LineStyle = '--', LineWidth=2, Color="#FF0000");
legend("Reference Curve rd", "System");
grid on;

figure(2); 
plot(tspan, error1, LineWidth=1.5);
title("Error using $r_d(t) = \bar{r_d} e^{-\beta(t-10)^2}$", 'Interpreter','latex');
grid on;

figure(3); 
plot(tspan, rd_curve2, LineWidth=1.5); 
hold on;
plot(t, r2(:,1),LineStyle = '--', LineWidth=2, Color="#FF0000");
legend("Reference Curve rd", "System");
grid on;

figure(4); 
plot(tspan, error2, LineWidth=1.5);
title("Error using $r_d(t) = \frac{\pi}{20} \left( 1 - \cos \left(\frac{\pi t}{10}\right) \right)$", 'Interpreter','latex');
grid on;


figure; 
plot(tspan, error1, LineWidth=1.5);
hold on;
plot(tspan, phi_curve, LineStyle="--", LineWidth=1.5, Color = "#FF0000");
hold on;
plot(tspan, -phi_curve, LineStyle="--", LineWidth=1.5, Color = "#FF0000");
title("Tracking error Bound using $r_d(t) = \bar{r_d} e^{-\beta(t-10)^2}$", 'interpreter', 'latex', "FontSize",12);
legend("$r(t) - r_d(t)$", "$\phi(t)$", "$-\phi(t)$", 'interpreter', 'latex', "FontSize",12);
grid on;



figure; 
plot(tspan, error2, LineWidth=1.5);
hold on;
plot(tspan, phi_curve, LineStyle="--", LineWidth=1.5, Color = "#FF0000");
hold on;
plot(tspan, -phi_curve, LineStyle="--", LineWidth=1.5, Color = "#FF0000");
legend("$r(t) - r_d(t)$", "$\phi(t)$", "$-\phi(t)$", 'interpreter', 'latex', "FontSize",12);
title("Tracking error Bound using $r_d(t) = \frac{\pi}{20} \left( 1 - \cos \left(\frac{\pi t}{10}\right) \right)$", 'interpreter', 'latex', "FontSize",12);
grid on;
