function Paul3Supercritical
% - By plotting the r-nullcline, we can explain if the limit cycle is either asymtotically stable or unstable.
%   When the slope at the fixed point is positive, the fixed point is unstable.
%   When the slope at the fixed point is negative, the fixed point is
%   asymtotically stable.
% - When c<0, we have only one fixed point, i.e. r=0, the fixed point is
%   asymtotically stable because r_dot<0, i.e. r always decreases to 0.
% - When c=0, we also have only one fixed point, i.e. r=0, the fixed point
%   is unstable because r_dot>0, i.e. r always increase.
% - When c>0, we have two fixed points, i.e. r=0 and r=sqrt(c). 
%   r=0 is an unstable fixed point because the slope is positive. 
%   r=sqrt(c) is an asymtotically stable fixed point because the slope is negative.
% - This differential equation is supercritical because when c increase by passing
%   through c=0, a new stable limit cycle is created.

clc
clear all
close all

%% Plot the radius of the steady-state solution.
c=linspace(0,10,1000);
r=sqrt(c);

figure(1)
plot(c,r);

%% Plot r-nullcline
clear all

rmin=0;
rmax=1.5;

c=0.5;
figure(2)
hold on
plotRNullCline(rmin,rmax,c);

grid on

end

function plotRNullCline(rmin,rmax,c)
    ezplot(@(r) r_dot(r,c), [rmin,rmax]);
end

function val=r_dot(r,c)
    val=c.*r-r.^3;
end
