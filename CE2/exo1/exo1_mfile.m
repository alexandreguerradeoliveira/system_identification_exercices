clc,close all,clear
load("laserbeamdataN2.mat");
%% exo1

%1
m = 50;
N = size(u,1);

Te = 1/1000;

tt = 0:Te:Te*(N-1);

Phi = toeplitz(u);
Phi = Phi(m:end,1:m)

theta_hat = pinv((Phi')*Phi)*(Phi')*y(m:end);
theta_hat_2 = pinv((Phi')*Phi)*(Phi')*y(m:end);

%2

y_est = Phi*theta_hat

plot(y_est)
hold on

plot(y(m:end))
hold off
