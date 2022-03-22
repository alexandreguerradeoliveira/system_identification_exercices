clc,close all,clear all

u=prbs(6,4);
y=u;


[R,h] = intcor(u,y);

plot(h,R,'*')
title("Autocorrelation function for PRBS(n=6,p=4)")
xlabel("h")
ylabel("R_{uu}(h)")