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

M = 300;
window = hann(2*M);
window = window((end)/2 + 1:end);

phi_uu_windowed = fft(Ruu(1:M).*window);
phi_yu_windowed = fft(Ryu(1:M).*window);
G_windowed = phi_yu_windowed./phi_uu_windowed;

omega_vec_windowed = (omega_s./M).*(0:(M-1));

sys_id_windowed = frd(G_windowed(1:floor(end/2)),omega_vec_windowed(1:floor(end/2)),Te);

%% 4

m = 10;
samples_per_group = N/m;

window = hann(2*samples_per_group);
window = window((end)/2 + 1:end);

phi_uu_avg = zeros(samples_per_group,1);%initialiation
phi_yu_avg = zeros(samples_per_group,1);%initialiation

for i = 1:samples_per_group:N
    U_period = U(i:i+samples_per_group-1);
    y_period = y_sim(i:i+samples_per_group-1);

    
    Ruu = xcorr(U_period,U_period,'unbiased');
    Ryu = xcorr(y_period,U_period,'unbiased');
    
    Ruu =  Ruu((end+1)/2:end);
    Ryu =  Ryu((end+1)/2:end);
    
    phi_uu_avg = fft(Ruu.*window) + phi_uu_avg;
    phi_yu_avg = fft(Ryu.*window) + phi_yu_avg;
end

phi_uu_avg = phi_uu_avg/m;
phi_yu_avg = phi_yu_avg/m;

G_windowed_avg = phi_yu_avg./phi_uu_avg;
omega_vec_windowed_avg = (omega_s./samples_per_group).*(0:(samples_per_group-1));

sys_id_windowed_avg = frd(G_windowed_avg(1:floor(end/2)),omega_vec_windowed_avg(1:floor(end/2)),Te);


%% 5

figure
bode(sys_id,G,sys_id_windowed,sys_id_windowed_avg);
legend("id no window","theoretical","id windowed","id windowed avg")
xlim([10^-1 inf])
