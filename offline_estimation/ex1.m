clear; clc; close all;


%problem parameters 
g = 9.81; 
L = 1.25; 
m = 0.75; 
c = 0.15; 
A0 = 4; 
w = 2; 
Ts = 0.1;
% odeFun 
odeFun = @(t, x) [x(2); -g/L * x(1) - c/(m*L^2) * x(2) + 1/(m*L^2) * A0*sin(w*t)];
%solve numerically using ode45
dt = 1e-4;  
t = 0:dt:20; 
x0 = [0; 0]; 
%solve the ode to calculate the measurable state vector
[t , x] = ode45(odeFun, t, x0);


figure(1);

plot(t, x(:,1), LineWidth=1.5); 
hold on; 
plot(t, x(:, 2), LineWidth=1.5);
grid on;
title("System States");
legend(["q(t)", "$\dot{q}(t)$"], "Interpreter","latex");
xlabel("t");

