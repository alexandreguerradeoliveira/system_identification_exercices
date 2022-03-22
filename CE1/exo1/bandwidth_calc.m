G = tf([-1 2],[1 1.85 4]);
%poles = pole(G);
%natural_frequency = abs(poles)/(2*pi) % [Hz]

fb = bandwidth(G) ; %rad/s
fb = fb/(2*pi); % Hz


f_N = 10*fb;

fe = 2*f_N;

Te = 1/fe