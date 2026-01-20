clear; clc; close all; 
%problem parameters 
g = 9.81; L = 1.25; m = 0.75; c = 0.15; A0 = 4; w = 2; 
% odeFun 
odeFun = @(t, x) [x(2); -g/L * x(1) - c/(m*L^2) * x(2) + 1/(m*L^2) * A0*sin(w*t)];
%solve numerically using ode45
dt = 1e-4;  
t = 0:dt:20; 
x0 = [0; 0]; 
%solve the ode to calculate the measurable state vector
[t , x] = ode45(odeFun, t, x0);
u = A0*sin(w*t);

Ts = 0.05:0.05:1;
k = length(Ts);
% filter params
l1 = 1 ; 
l2 = 1 ;
%measurable x(t) and u(t)
L_param1 = zeros(k,1);
m_param1 = zeros(k,1);
c_param1 = zeros(k,1);
%measurable q(t) and u(t)
L_param2 = zeros(k,1);
m_param2 = zeros(k,1);
c_param2 = zeros(k,1);

for i = 1:k
    step = round(Ts(i)/dt);
    ts = t(1:step:end);
    xs = x(1:step:end, :);
    us = u(1:step:end);
    [L_param1(i), m_param1(i), c_param1(i)] = estimate_params(xs, us, ts, [l1,l2], 1);
    [L_param2(i), m_param2(i), c_param2(i)] = estimate_params(xs, us, ts, [l1,l2], 0);
end

L_error1 = 0.5*(L - L_param1).^2;
m_error1 = 0.5 *(m - m_param1).^2; 
c_error1 = 0.5*(c - c_param1).^2;


L_error2 = 0.5*(L - L_param2).^2;
m_error2 = 0.5 *(m - m_param2).^2; 
c_error2 = 0.5*(c - c_param2).^2;


figure; 
plot(Ts, L_error1,Ts, L_error2, LineWidth=0.5); 
hold on;
scatter(Ts, L_error1, "filled", 'MarkerFaceColor', '#0072BD', 'LineWidth', 1);
scatter(Ts, L_error2, 'filled', 'MarkerFaceColor', '#D95319', 'LineWidth', 1);
grid on; 
title("Squared error $\frac{1}{2} (L - \hat{L})^2 $", "interpreter","latex");
legend(["$q(t), \dot{q}(t), u(t)$ measurable", "$q(t), u(t)$ measurable"], "location", "northwest", "Interpreter","latex");
xlabel("Ts");



figure; 
plot(Ts, m_error1,Ts,m_error2, LineWidth=0.5); 
hold on;
scatter(Ts, m_error1, 'filled', 'MarkerFaceColor', '#0072BD', 'LineWidth', 1);
scatter(Ts, m_error2, 'filled', 'MarkerFaceColor', '#D95319', 'LineWidth', 1);
grid on; 
title("Squared error $\frac{1}{2} (m - \hat{m})^2 $", "interpreter","latex");
legend(["$q(t), \dot{q}(t), u(t)$ measurable", "$q(t), u(t)$ measurable"], "location", "northwest","Interpreter","latex");
xlabel("Ts");

figure; 
plot(Ts, c_error1,Ts,c_error2, LineWidth=0.5); 
hold on;
scatter(Ts, c_error1, 'filled', 'MarkerFaceColor', '#0072BD', 'LineWidth', 1);
scatter(Ts, c_error2, 'filled', 'MarkerFaceColor', '#D95319', 'LineWidth', 1);
grid on; 
title("Squared error $\frac{1}{2} (c - \hat{c})^2 $", "interpreter","latex");
legend(["$q(t), \dot{q}(t), u(t)$ measurable", "$q(t), u(t)$ measurable"], "Interpreter","latex", "location","northwest");
xlabel("Ts");
