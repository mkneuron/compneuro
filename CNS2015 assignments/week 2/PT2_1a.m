function Paul1a
clc
clear all
% close all

%% Fixed points

% saddles
% x1_fp=0;x2_fp=0;
% x1_fp=1;x2_fp=-1;
% x1_fp=1;x2_fp=1;
% x1_fp=-1;x2_fp=-1;
% x1_fp=-1;x2_fp=1;

% centers
x1_fp=0;x2_fp=-1; 
% x1_fp=0;x2_fp=1;
% x1_fp=-1;x2_fp=0;
% x1_fp=1;x2_fp=0;


%% Eigenvalues
A=[0 -1+3*x2_fp^2;
   -1+3*x1_fp^2 0];
lambda = eig(A)

%% Specify range around the fixed point
x1min=x1_fp-0.5;
x1max=x1_fp+0.5;
x2min=x2_fp-0.5;
x2max=x2_fp+0.5;

figure(1)
hold on

%% Plot velocity field
[X1,X2] = meshgrid(linspace(x1min,x1max,50),linspace(x2min,x2max,50));
quiver(X1,X2,DX1(X2),DX2(X1),'b')

%% Plot trajectory
x1_start = x1_fp + 0.5; % x1_fp+rand()*2e-1;
x2_start = x2_fp + 0; %x2_fp+rand()*2e-1;

[T,Y] = ode45(@(t,y) d_system(t,y),[0 1000],[x1_start x2_start]);
plot(Y(:,1),Y(:,2),'r');
plot(x1_start, x2_start, '*g')
plot(Y(end,1),Y(end,2),'ob')
xlabel('x_{1}'); ylabel('x_{2}')
end

function val=DX1(X2)
    val=-X2+X2.^3;
end

function val=DX2(X1)
    val=-X1+X1.^3;
end

function dy=d_system(t,y)
    dy=zeros(2,1);
            
    dy(1)=DX1(y(2));
    dy(2)=DX2(y(1));
end