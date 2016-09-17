function Paul1c
clc
clear all
% close all
format long

%% Choose a value of 'a'.
a=0.5;

%% Choose a fixed point that you want to investigate.
% x1_fp=0;                  x2_fp=0;
x1_fp=-1;                 x2_fp=0;

% apart from those two fixed points, you can find situations with one more 
% fixed point at positive x1, and situation with one fp at positive x1 and 
% two more for negative x1. 
%% plot nullclines
x1_start = -5;
x1_end = 5;
x2_start = -5;
x2_end = 5;

figure(1); hold on
fplot(@(x1) sqrt(x1+x1^2), [x1_start, x1_end], 'g');
fplot(@(x1) -1*sqrt(x1+x1^2), [x1_start, x1_end], 'g');
fplot(@(x1) 0, [x1_start, x1_end], 'r');
fplot(@(x1) -1*(1+x1)/(a*x1), [x1_start, x1_end], 'r');
xlim([x1_start x1_end]);
ylim([x2_start x2_end]);

delta=4*a^6-27*a^8; % To determine how many fixed point we will have more.
if (delta>0)
    %% We have three more fixed points
    x1_fp=real(calFirstX1_fp(a));
    x2_fp=-(1+x1_fp)/(a*x1_fp);
    
%     x1_fp=real(calSecondX1_fp(a));
%     x2_fp=-(1+x1_fp)/(a*x1_fp);
    
%     x1_fp=real(calThirdX1_fp(a)); 
%     x2_fp=-(1+x1_fp)/(a*x1_fp);
elseif (delta<0)
    %% We have one more fixed point
    x1_fp=calFirstX1_fp(a);
    x2_fp=-(1+x1_fp)/(a*x1_fp);
else    
    %% You will get multiple roots, i.e. the same values of fixed point.
    x1_fp=real(calFirstX1_fp(a));
    x2_fp=-(1+x1_fp)/(a*x1_fp);
    
%     x1_fp=real(calSecondX1_fp(a));
%     x2_fp=-(1+x1_fp)/(a*x1_fp);
%     
%     x1_fp=real(calThirdX1_fp(a));
%     x2_fp=-(1+x1_fp)/(a*x1_fp);    
end


%% Eigenvalues
A=[x2_fp+a*x2_fp^2  1+x1_fp+2*a*x1_fp*x2_fp;
   -1-2*x1_fp       2*x2_fp];
lambda = eig(A)

%% Specify range around the fixed point
x1min=x1_fp-1;
x1max=x1_fp+1;
x2min=x2_fp-1;
x2max=x2_fp+1;


figure(1)
hold on
%% Plot velocity field
[X1,X2] = meshgrid(linspace(x1min,x1max,10),linspace(x2min,x2max,10));
quiver(X1,X2,DX1(X1,X2,a),DX2(X1,X2),'b')

%% Plot trajectory
% [T,Y] = ode45(@(t,y) d_system(t,y,a),[0 100],[-0.5 0.7]);
% plot(Y(:,1),Y(:,2),'r');

end

function x1_fp=calThirdX1_fp(a)
    tmp=(9*a^2+sqrt(3)*sqrt(-4*a^3+27*a^4))^(1/3);
    x1_fp=-((1-1i*sqrt(3))/(2^(2/3)*3^(1/3)*tmp))-(((1+1i*sqrt(3))*tmp)/(2*2^(1/3)*3^(2/3)*a));
end

function x1_fp=calSecondX1_fp(a)
    tmp=(9*a^2+sqrt(3)*sqrt(-4*a^3+27*a^4))^(1/3);
    x1_fp=-((1+1i*sqrt(3))/(2^(2/3)*3^(1/3)*tmp))-(((1-1i*sqrt(3))*tmp)/(2*2^(1/3)*3^(2/3)*a));
end

function x1_fp=calFirstX1_fp(a)
    x1_fp=(((2/3)^(1/3))/((9*a^2+sqrt(3)*sqrt(-4*a^3+27*a^4))^(1/3)))+(((9*a^2+sqrt(3)*sqrt(-4*a^3+27*a^4))^(1/3))/((2^(1/3))*(3^(2/3))*a));
end

function val=DX1(X1,X2,a)
    val=X2+X1.*X2+a.*X1.*X2.^2;
end

function val=DX2(X1,X2)
    val=-X1-X1.^2+X2.^2;
end

function dy=d_system(t,y,a)
    dy=zeros(2,1);
    
    dy(1)=DX1(y(1),y(2),a);
    dy(2)=DX2(y(1),y(2));
end