clc,close all,clear
%%
sat_up = 0.5; % must fix the maximum amplitude as to not saturate the input
Uprbs = prbs(8,8)*sat_up;
Te = 0.1;
tt = (0:Te:(size(Uprbs,1)-1)*Te)';

% pass to simulink stuct
simin.time = tt;
simin.signals.values = Uprbs;

% call the simulation
out_step = sim('exo4.slx',tt(end));
tt_sim = out_step.simout.Time;
y_sim = out_step.simout.Data;

% pick only the first period of the signal
M = 2^(8)-1; 
Uprbs = Uprbs(7*M + 1:8*M); %demander si il faut vraiment prendre la derniere periode (so no ss)
y_sim = y_sim(7*M + 1:8*M);
tt_sim = tt_sim(1:M);

R_uu_intcor = intcor(Uprbs,Uprbs);
R_yu_intcor = intcor(y_sim,Uprbs);

U_toeplitz_intcor = toeplitz(R_uu_intcor);

g_k_intcor = inv(U_toeplitz_intcor)*(R_yu_intcor');

%% now with matlab

R_uu_matlab = xcorr(Uprbs,Uprbs);
R_yu_matlab = xcorr(y_sim,Uprbs);

%keep only the positive part of the correlations functions
R_yu_matlab = R_yu_matlab((end+1)/2:end);
R_uu_matlab = R_uu_matlab((end+1)/2:end);

U_toeplitz_matlab =  toeplitz(R_uu_matlab);
g_k_matlab =  inv(U_toeplitz_matlab)*R_yu_matlab;


%% exact reponse of the system
G = tf([-1 2],[1 1.85 4]);
G = c2d(G,Te);
g_theory = impulse(G,tt_sim)*Te;

%% plots
hold on 
plot(tt_sim,g_k_intcor)
plot(tt_sim,g_k_matlab)
plot(tt_sim,g_theory)
title("Impulse response g(t)")
xlabel("discrete time k")
legend("Impulse reponse with intcor()","Impulse reponse with xcorr()","Theoretical impulse (no noise, no saturation)")


