function Paul3Subcritical
% - By plotting the r-nullcline, we can explain if the limit cycle is either asymtotically stable or unstable.
%   When the slope at the fixed point is positive, the fixed point is unstable.
%   When the slope at the fixed point is negative, the fixed point is
%   asymtotically stable.
% - When c<-1, we have only one fixed point, i.e. r=0, the fixed point is
%   asymtotically stable because r_dot<0, i.e. r always decreases to 0.
% - When -1<c<0, we have three fixed points, i.e. r=0, r=sqrt(1-sqrt(1+c)), r=sqrt(1+sqrt(1+c)).
%   r=0 is asymtotically stable. r=sqrt(1-sqrt(1+c)) is unstable. and r=sqrt(1+sqrt(1+c)) is asymtotically stable.
% - When c>0, we have two fixed points, i.e. r=0 and r=sqrt(1+sqrt(1+c)). 
%   r=0 is an unstable fixed point because the slope is positive. 
%   r=sqrt(1+sqrt(1+c)) is an asymtotically stable fixed point because the slope is negative.
% - This differential equation is subcritical because when c decreases by passing
%   through c=0, a new unstable limit cycle, i.e. r=sqrt(1-sqrt(1+c)), is created.
% - Subcritical is more "dangerous" compared to supercritical because the
%   system jump from one fixed point to another fixed point as c
%   increasing.

clc
clear all
close all

%% Plot the radius of the steady-state solution.
c_lin=linspace(-10,10,1000);

r_i=1;
for c=c_lin
    if (c<=-1)
        %% When c<-1, we have only one fixed point.
        r1(1,r_i)=0;
        r2(1,r_i)=NaN;
        r3(1,r_i)=NaN;
    elseif ((-1<c) && (c<=0))
        %% When -1<c<0, we have three fixed points.
        r1(1,r_i)=0;
        r2(1,r_i)=sqrt(1-sqrt(1+c));
        r3(1,r_i)=sqrt(1+sqrt(1+c));        
    else 
        %% When 0<c, we have two fixed points.
        r1(1,r_i)=0;
        r2(1,r_i)=NaN;
        r3(1,r_i)=sqrt(1+sqrt(1+c));                
    end
    r_i=r_i+1;
end

figure(1)
hold on
plot(c_lin,r1,'r*');
plot(c_lin,r2,'g*');
plot(c_lin,r3,'b*');
xlabel('c');
grid on

%% Plot r-nullcline
clear all

rmin=0;
rmax=1.5;

% c=-0.57;
c=-10;
figure(2)
hold on
plotRNullCline(rmin,rmax,c);

grid on

end

function plotRNullCline(rmin,rmax,c)
    ezplot(@(r) r_dot(r,c), [rmin,rmax]);
end

function val=r_dot(r,c)
    val=r.*(c+2.*r.^2-r.^4);
end
