clc,close all,clear all

Te = 0.1; %[s]
N = 40; %[-] number of points

tt = (0:Te:(N-1)*Te)';
u = rand(size(tt));

%plot(tt,u)
r = zeros(size(u));
r(1) = u(1);
T = toeplitz(u,r);

%apply u to system, mesure y

G = tf([-1 2],[1 1.85 4]);

y = lsim(G,u,tt);

%simin.time = tt;
%simin.signals.values = u;

%out_sim = sim('exo3.slx');

%y = out_sim.simout.Data;

%plot(tt,y)
%figure
%hold on

g = inv(T)*(y);
hold on
plot(tt,g)
%figure

sys_d = c2d(G,Te);
[y_d,t_d] = impulse(sys_d*Te);
plot(t_d,y_d)

% part 5
lambda = .01;

g_reg = inv(T'*T+lambda*eye(size(T)))*(T')*y;

plot(tt,g_reg)

legend("indentified system","sampled system","regulirised indentification")






