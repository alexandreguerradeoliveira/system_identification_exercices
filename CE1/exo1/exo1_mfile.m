% First exercice of CE1 for System Identification class
clc,close all,clear all;
%
sat_up = 0.5; % upper saturation value
Te = 0.1; % sampling frequency

% time vector
tt = (0:Te:10)'; % is a collumn vector as the exercice demands

% create values vector
values = zeros(size(tt));
t_start = 1; % sec (when the step should start)
n_start = t_start/Te; % calculate in which sample of the discrete signal to start the step
values(n_start+1:end) = ones(1,size(tt,1)-n_start)*sat_up;

% pass to simulink stuct
simin.time = tt;
simin.signals.values = values;

% call the simulation
out_step = sim('exo1.slx',tt(end));
out_step_wn = sim('exo1_without_noise.slx'); %without noise


%% do the same for the impulse response

%create input vector
values_impulse = zeros(size(tt));
values_impulse(1) = sat_up;
simin.signals.values = values_impulse;

% simulate in simulink
out_impulse = sim('exo1.slx');
out_impulse_wn = sim('exo1_without_noise.slx'); 


%% is Te enough ?
G = tf([-1 2],[1 1.85 4]);
%poles = pole(G);
%natural_frequency = abs(poles)/(2*pi) % [Hz]

fb = bandwidth(G) ; %rad/s
fb = fb/(2*pi); % Hz

f_N = 10*fb; % heuristic: nyquist frequency is 10 times the bandwidth

fe = 2*f_N; % nyquist theorem

Te_max = 1/fe; % maximum sampling time
disp('Te maximum = ');
disp(Te_max);

% we can see that the natural frequency of the system is way smaller than
% than half of the sampling frequency, so Nyquists/Shannon theorem is
% verified thus the sampling time is reasonable.


%% Comparison plots

figure
plot(out_step.simout.Time,out_step.simout.Data, out_step_wn.simout.Time,out_step_wn.simout.Data);
title("step response of G(s) with and without noise");
xlabel("time [sec]")
ylabel("y(t)")
legend('Step response with noise','Step response without noise')


figure
plot(out_impulse.simout.Time,out_impulse.simout.Data, out_impulse_wn.simout.Time,out_impulse_wn.simout.Data);
title("Impulse response of G(s)");
xlabel("time [sec]")
ylabel("y(t)")
legend('Impulse response with noise','Impulse response without noise')

