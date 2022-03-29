Te = 0.1; %[s]
N = 5; %[-] number of points

tt = (0:Te:(N-1)*Te)';

sat_up = 0.5;
u = rand(size(tt))*sat_up;

K = 3;


r = zeros(1,K);
r(1) = u(1);
T = toeplitz(u,r);