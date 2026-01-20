clear; clc; close all; 
%problem parameters 
g = 9.81; L = 1.25; m = 0.75; c = 0.15; A0 = 4; w = 2; 
%parameters for numerically solving the system ode
dt = 1e-4;  
t = 0:dt:20; 
x0 = [0; 0]; 
% filter params
l1 = 1 ; 
l2 = 1 ;

A = 1:1:10;
n = length(A);
Ts = 0.1;
step = round(Ts/dt);

%measurable x(t) and u(t)
L_param3 = zeros(n,1);
m_param3 = zeros(n,1);
c_param3 = zeros(n,1);
%measurable q(t) and u(t)
L_param4 = zeros(n,1);
m_param4 = zeros(n,1);
c_param4 = zeros(n,1);

for i = 1:n
    odeFun = @(t, x) [x(2); -g/L * x(1) - c/(m*L^2) * x(2) + 1/(m*L^2) * A(i)*sin(w*t)];
    [t , x] = ode45(odeFun, t, x0);
    u = A(i)*sin(w*t);
    usi = u(1:step:end);
    xsi = x(1:step:end, :);
    tsi = t(1:step:end);
    [L_param3(i), m_param3(i), c_param3(i)] = estimate_params(xsi, usi, tsi, [l1,l2], 1);
    [L_param4(i), m_param4(i), c_param4(i)] = estimate_params(xsi, usi, tsi, [l1,l2], 0);

end

L_error3 = 0.5*(L - L_param3).^2;
m_error3 = 0.5*(m - m_param3).^2; 
c_error3 = 0.5*(c - c_param3).^2;

L_error4 = 0.5*(L - L_param4).^2;
m_error4 = 0.5*(m - m_param4).^2; 
c_error4 = 0.5*(c - c_param4).^2;


figure; 
plot(A, L_error3,A,L_error4, LineWidth=0.5); 
hold on;
scatter(A, L_error3, 'filled', 'MarkerFaceColor', '#0072BD', 'LineWidth', 1);
scatter(A, L_error4, 'filled', 'MarkerFaceColor', '#D95319', 'LineWidth', 1);
grid on; 
title("Squared error $\frac{1}{2} (L - \hat{L})^2 $", "interpreter","latex");
legend(["$q(t), \dot{q}(t), u(t)$ measurable", "$q(t), u(t)$ measurable"], "Interpreter","latex");
xlabel("A");

figure; 
plot(A, m_error3,A,m_error4, LineWidth=0.5); 
hold on;
scatter(A, m_error3, 'filled', 'MarkerFaceColor', '#0072BD', 'LineWidth', 1);
scatter(A, m_error4, 'filled', 'MarkerFaceColor', '#D95319', 'LineWidth', 1);
grid on; 
title("Squared error $\frac{1}{2} (m - \hat{m})^2 $", "interpreter","latex");
legend(["$q(t), \dot{q}(t), u(t)$ measurable", "$q(t), u(t)$ measurable"], "Interpreter","latex");
xlabel("A");

figure; 
plot(A, c_error3,A,c_error4, LineWidth=0.5); 
hold on;
scatter(A, c_error3, 'filled', 'MarkerFaceColor', '#0072BD', 'LineWidth', 1);
scatter(A, c_error4, 'filled', 'MarkerFaceColor', '#D95319', 'LineWidth', 1);
grid on; 
title("Squared error $\frac{1}{2} (c - \hat{c})^2 $", "interpreter","latex");
legend(["$q(t), \dot{q}(t), u(t)$ measurable", "$q(t), u(t)$ measurable"], "Interpreter","latex");
xlabel("A");

