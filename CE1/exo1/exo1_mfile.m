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

% plot data
plot(out_step.simout.Time,out_step.simout.Data);
title("Step response of the system");
xlabel("time [sec]")
ylabel("y(t)")



%% do the same for the impulse response

%create input vector
values_impulse = zeros(size(tt));
values_impulse(1) = sat_up;
simin.signals.values = values_impulse;

% simulate in simulink
out_impulse = sim('exo1.slx');

% plot data
figure
plot(out_impulse.simout.Time,out_impulse.simout.Data);
title("Impulse response of the system");
xlabel("time [sec]")
ylabel("y(t)")


%% is Te enough ?
G = tf([-1 2],[1 1.85 4]);
%poles = pole(G);
%natural_frequency = abs(poles)/(2*pi) % [Hz]

fb = bandwidth(G) ; %rad/s
fb = fb/(2*pi); % Hz

f_N = 10*fb; % heuristic: nyquist frequency is 10 times the bandwidth

fe = 2*f_N; % nyquist theorem

Te_max = 1/fe % maximum sampling time

%figure
%bode(G)

% we can see that the natural frequency of the system is way smaller than
% than half of the sampling frequency, so Nyquists/Shannon theorem is
% verified thus the sampling time is reasonable.


