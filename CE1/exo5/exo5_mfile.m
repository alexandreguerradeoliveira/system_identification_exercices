clc,close all,clear all
%% 1

sat_up = 0.5; % must fix the maximum amplitude as to not saturate the input
p = 16;

N_wanted = 2000;
n_min = ceil(log2((N_wanted+1)/p)); %minimum shift register length

Uprbs = prbs(n_min,p)*sat_up;
Te = 0.1;
tt = (0:Te:(size(Uprbs,1)-1)*Te)';

% pass to simulink stuct
simin.time = tt;
simin.signals.values = Uprbs;

% call the simulation
out_step = sim('exo5.slx',tt(end));
tt_sim = out_step.simout.Time;
y_sim = out_step.simout.Data;

%% 2

N = size(Uprbs,1);

Uprbs_fft_avg = 0;%initialiation
y_fft_avg = 0;%initialiation
N_one_period = N/p;

number_periods_to_ignore = 1;

for i = (1+number_periods_to_ignore*N_one_period):N_one_period:N
    Uprbs_period = Uprbs(i:i+N_one_period-1);
    Uprbs_fft_avg = (fft(Uprbs_period) + Uprbs_fft_avg);

    y_period = y_sim(i:i+N_one_period-1);
    y_fft_avg = (fft(y_period) + y_fft_avg);
end
Uprbs_fft_avg = Uprbs_fft_avg/p;
y_fft_avg = y_fft_avg/p;


%% 3

f_s = 1/Te;
omega_s = 2*pi*f_s;

omega_vec = (omega_s./N_one_period).*(0:(N_one_period-1));

G = y_fft_avg./Uprbs_fft_avg;

%% 4
sys_f = frd(G(1:floor(end/2)),omega_vec(1:floor(end/2)),Te);

%%
G = tf([-1 2],[1 1.85 4]);
G = c2d(G,Te);

bode(sys_f,G)
