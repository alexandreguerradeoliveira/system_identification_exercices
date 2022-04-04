clc,close all,clear all
%% exo 6
%% 1
N = 2000;
sat_up = 0.5;
Te = 0.1;


U = rand(2000,1)-0.5;
U(U<0)=-sat_up;
U(U>0)=sat_up;
%U = [U;zeros(50,1)]; padding

tt = (0:Te:(size(U,1)-1)*Te)';

% call simulink
simin.time = tt;
simin.signals.values = U;
out_step = sim('exo6.slx',tt(end));
tt_sim = out_step.simout.Time;
y_sim = out_step.simout.Data;


%% 2

Ruu = xcorr(U,U,'biased');
Ryu = xcorr(y_sim,U,'biased');

%keep only the positive part of the correlations functions
Ruu =  Ruu((end+1)/2:end);
Ryu =  Ryu((end+1)/2:end);

phi_uu = fft(Ruu);
phi_yu = fft(Ryu);

f_s = 1/Te;
omega_s = 2*pi*f_s;
omega_vec = (omega_s./N).*(0:(N-1));


G_id = phi_yu./phi_uu;

sys_id = frd(G_id(1:floor(end/2)),omega_vec(1:floor(end/2)),Te);

% real system (no noise, no saturation)
G = tf([-1 2],[1 1.85 4]);
G = c2d(G,Te);
%% 3

window = hann(2*N);
window = window(size(window,1)/2 + 1:end);

%figure
%plot(window)

phi_uu_windowed = fft(Ruu.*window);
phi_yu_windowed = fft(Ryu.*window);

G_windowed = phi_yu_windowed./phi_uu_windowed;

sys_id_windowed = frd(G_windowed(1:floor(end/2)),omega_vec(1:floor(end/2)),Te);

%

figure
bode(sys_id,G,sys_id_windowed);
xlim([10^-1 inf])
%
