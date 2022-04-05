clc,close all,clear all

Te = 0.1; %[s]
N = 1001; %[-] number of points

tt = (0:Te:(N-1)*Te)';

sat_up = 0.5;
u = rand(size(tt))*sat_up;
%no noise system as comparison

G = tf([-1 2],[1 1.85 4]);
y_nonoise = lsim(G,u,tt);

%simulate system with simulink
simin.time = tt;
simin.signals.values = u;
out_sim = sim('exo3.slx',tt(end));
y = out_sim.simout.Data;

%% deconvolution method [finite impulse response]
K = 70;

% create asymetric toeplitz matrix
r = zeros(1,K);
r(1) = u(1);
T = toeplitz(u,r);%U_k in the course

% solve least squares
g_fir = inv((T')*(T))*((T')*y);

%% ideal system (no noise, no saturation)
sys_d = c2d(G,Te);
[y_d,t_d] = impulse(sys_d*Te);

%% part 5 [Regularisation]
lambda = 2;

r = zeros(size(u));
r(1) = u(1);
T_full = toeplitz(u,r); % full N*N asymetric toeplitz matrix

g_reg = inv(T_full'*T_full+lambda*eye(size(T_full)))*(T_full')*y; % solve the least squares problem

%% plots
figure
hold on

plot(tt(1:K),g_fir)
plot(t_d,y_d)
plot(tt(1:K),g_reg(1:K))

err_fir = y_d-g_fir;
err_reg = y_d-g_reg(1:K);

norm_err_fir = norm(err_fir,2)
norm_err_reg = norm(err_reg,2)


title("Impulse response")
legend("Indentified response (FIR)","Ideal response (no saturation, no noise)","Identified response (Regularisation)")
xlabel("time [s]")
ylabel("impulse response [arbitrary units]")







