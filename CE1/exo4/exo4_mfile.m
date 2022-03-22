clc,close all,clear
%%

sat_up = 0.5; % must fix the maximum amplitude to not saturate the input
Uprbs = prbs(8,8)*sat_up;
Te = 0.1;

tt = (0:Te:(size(Uprbs,1)-1)*Te)';

% pass to simulink stuct
simin.time = tt;
simin.signals.values = Uprbs;

% call the simulation
out_step = sim('exo4.slx');

tt_sim = out_step.simout.Time;
y_sim = out_step.simout.Data;

% R_uu = intcor(Uprbs(1:255),Uprbs(1:255));
% R_yu = intcor(y_sim(1:255),Uprbs(1:255));
% 
% U_toeplitz = toeplitz(R_uu);
% 
% g_k = inv(U_toeplitz)*(R_yu')
% 
% 
% plot(tt_sim(1:255),g_k)

K = 255;

Uprbs = Uprbs(1:K);
y_sim = y_sim(1:K);
tt_sim = tt_sim(1:K);

R_uu = intcor(Uprbs,Uprbs);
R_yu = intcor(y_sim,Uprbs);

U_toeplitz = toeplitz(R_uu);

g_k = inv(U_toeplitz)*(R_yu');



%% now with matlab


R_uu_matlab = xcorr(Uprbs,Uprbs);
R_yu_matlab = xcorr(y_sim,Uprbs);


R_yu_matlab = R_yu_matlab((end+1)/2:end);
R_uu_matlab = R_uu_matlab((end+1)/2:end);

U_toep_matlab =  toeplitz(R_uu_matlab);


g_k_matlab = inv(U_toep_matlab)*R_yu_matlab;

%% exact reponse of the system
G = tf([-1 2],[1 1.85 4]);
G = c2d(G,Te);
g_theory = impulse(G,tt_sim)*Te;


%% plots
hold on 
plot(tt_sim,g_k)
plot(tt_sim,g_k_matlab)
plot(tt_sim,g_theory)
title("Impulse response g(t)")
xlabel("discrete time k")
legend("Impulse reponse with intcor()","Impulse reponse with xcorr()","Theoretical impulse response without noise")


