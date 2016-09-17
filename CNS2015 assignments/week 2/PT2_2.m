function Paul2
% - When C equals 0, the amplitude of the oscillator depends on where you start.
% - C determine the duration of the transient towards the stabile limit cycle, i.e. higher C, quicker the state goes to the limit cycle.
% - C and w determine the frequency of the oscillation.

clc
clear all
% close all

%% Specify 'c' and 'w' values.
c=1;
w=1;

%% Specify a fixed point
x1_fp=0;x2_fp=0;

%% Specify a range of x and x_dot in the phase plane that you want to investigate.
xmin=x1_fp-5.0; % minimum x
xmax=x1_fp+5.0; % maximum x
ymin=x2_fp-10;  % minimum x_dot
ymax=x2_fp+10;  % maximum x_dot

figure(1)
hold on

%% Plot null-cline
% plotXNullCline(xmin,xmax);
plotYNullCline(xmin,xmax,ymin,ymax,c,w);

%% Plot velocity field
[X,Y] = meshgrid(linspace(xmin,xmax,10),linspace(ymin,ymax,10));
quiver(X,Y,DX(Y),DY(X,Y,c,w),'b')

%% Plot trajectory
[T,Y] = ode45(@(t,y) d_system(t,y,c,w),[0 50],[0 5]);
figure(1);hold on
plot(Y(:,1),Y(:,2),'r');

figure(2);hold on
plot(T,Y(:,2),'r');

end

function dy=d_system(t,y,c,w)
    dy=zeros(2,1);
    dy(1)=y(2);
    dy(2)=-c.*(y(1).^2-1).*y(2)-w.^2.*y(1);
end

function val=DX(Y)
    val=Y;
end
function val=DY(X,Y,c,w)
    val=-c.*(X.*X-1).*Y-w.*w.*X;
end

function plotXNullCline(xmin,xmax)
    plot(linspace(xmin,xmax,100),linspace(xmin,xmax,100).*0);
end

function plotYNullCline(xmin,xmax,ymin,ymax,c,w)
    ezplot(@(x,y) fct(x,y,c,w),[xmin,xmax,ymin,ymax]);
end

function val=fct(x,y,c,w)
    val=-c.*(x.*x-1).*y-w.*w.*x;
end

