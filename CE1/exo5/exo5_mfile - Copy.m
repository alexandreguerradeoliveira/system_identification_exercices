clc,close all,clear all
%% 1

sat_up = 0.5; % must fix the maximum amplitude as to not saturate the input
Uprbs = prbs(9,4)*sat_up;
Te = 0.1;
tt = (0:Te:(size(Uprbs,1)-1)*Te)';

% pass to simulink stuct
simin.time = tt;
simin.signals.values = Uprbs;

% call the simulation
out_step = sim('exo5.slx');
tt_sim = out_step.simout.Time;
y_sim = out_step.simout.Data;

%% 2

N = size(Uprbs,1);



% Uprbs1 = Uprbs(1:N/2);
% Uprbs2 = Uprbs(N/2+1:end);
% 
% U_fft1 = fft(Uprbs1);
% U_fft2 = fft(Uprbs2);
% 
% y_sim1 = y_sim(1:N/2);
% y_sim2 = y_sim(N/2+1:end);
% 
% Y_fft1 = fft(y_sim1);
% Y_fft2 = fft(y_sim1);
% 
% U_fft = (U_fft1+U_fft2)/2;
% Y_fft = (Y_fft1 + Y_fft2)/2;

%N = Vector's size
%n = nb period

n =2;
Uprbs_fft_avg = 0;%initialiation
y_fft_avg = 0;%initialiation
one_period = N/n;

for i = 1:one_period:N
    Uprbs_period = Uprbs(i:i+one_period-1);
    Uprbs_fft_avg = (fft(Uprbs_period) + Uprbs_fft_avg);

    y_period = y_sim(i:i+one_period-1);
    y_fft_avg = (fft(y_period) + y_fft_avg);
end
Uprbs_fft_avg = Uprbs_fft_avg/n;
y_fft_avg = y_fft_avg/n;


%% 3

f_s = 1/Te;
omega_s = 2*pi*f_s;

N_fft = N/n;
omega_vec = (omega_s./N_fft).*(0:(N_fft-1));

G = y_fft_avg./Uprbs_fft_avg;

%% 4
sys_f = frd(G(1:end/2),omega_vec(1:end/2),Te);

%%
G = tf([-1 2],[1 1.85 4]);
G = c2d(G,Te);

bode(sys_f,G)
