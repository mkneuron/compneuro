function Paul1b
clc
clear all
% close all

%% Fixed point

% centers
x1_fp=1/2;x2_fp=0;
% x1_fp=-1/2;x2_fp=0;

%% Eigenvalues
A=[2*x2_fp 2*x1_fp;
   -2*x1_fp 2*x2_fp];
lambda = eig(A)

%% Specify range around the fixed point
x1min=x1_fp-0.5;
x1max=x1_fp+0.5;
x2min=x2_fp-0.5;
x2max=x2_fp+0.5;


figure(1)
hold on

%% Plot velocity field
[X1,X2] = meshgrid(linspace(x1min,x1max,10),linspace(x2min,x2max,10));
quiver(X1,X2,DX1(X1,X2),DX2(X1,X2),'b')
%% Plot trajectory
x1_start = x1_fp + 0.65; % x1_fp+rand()*2e-1;
x2_start = x2_fp+rand()*2e-1;
[T,Y] = ode45(@(t,y) d_system(t,y),[0 10000],[x1_start x2_start]);
plot(Y(:,1),Y(:,2),'r');
plot(x1_start, x2_start, '*g')
plot(Y(end,1),Y(end,2),'ob')
xlabel('x_{1}'); ylabel('x_{2}')
end

function val=DX1(X1,X2)
    val=2.*X1.*X2;
end

function val=DX2(X1,X2)
    val=1/4-X1.^2+X2.^2;
end

function dy=d_system(t,y)
    dy=zeros(2,1);
    
    dy(1)=DX1(y(1),y(2));
    dy(2)=DX2(y(1),y(2));
end