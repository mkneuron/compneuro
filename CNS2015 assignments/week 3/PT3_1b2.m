function Paul1b2
clc
clear all

%% Specify parameter 
I=1;

vmin=-65;
vmax=35;
umin=-2*(vmax+60);
umax=-2*(vmin+60);

if (I<=(72^2/(4*0.7)-1800))
    %% We have two fixed point;
    v_fp=(-72+sqrt(72^2-4*0.7*(1800+I)))/(2*0.7);u_fp=-2*v_fp-120;
    A=[(0.7/100)*2*v_fp+70/100  -1/100;
        -0.06                   -0.03];
    eig(A)
    v_fp=(-72-sqrt(72^2-4*0.7*(1800+I)))/(2*0.7);u_fp=-2*v_fp-120;
    A=[(0.7/100)*2*v_fp+70/100  -1/100;
        -0.06                   -0.03];
    eig(A)    
end

figure(1)
hold on
%% Plot nullcline
plotVNullcline(vmin,vmax,I);
plotUNullcline(vmin,vmax);

%% Plot velocity field
[V,U] = meshgrid(linspace(vmin,vmax,10),linspace(umin,umax,10));
quiver(V,U,DV(V,U,I),DU(V,U),1);

ylim([umin umax]);

%% Plot trajectory
% figure(2)
[T,Y] = ode45(@(t,y) d_system(t,y,I),[0 2],[0 0]);
plot(Y(:,1),Y(:,2),'g');
plot(-50,0,'g*')

end

function dy=d_system(t,y,I)
    dy=zeros(2,1);
    
    dy(1)=DV(y(1),y(2),I);
    dy(2)=DU(y(1),y(2));
end


function val=DV(V,U,I)
    val=(1/100).*(0.7.*(V+60).*(V+40)-U+I);
end

function val=DU(V,U)
    val=0.03.*(-2.*(V+60)-U);
end

function plotVNullcline(vmin,vmax,I)
    v_lin=linspace(vmin,vmax,10000);
    u=0.7.*(v_lin+60).*(v_lin+40)+I;
    
    plot(v_lin,u,'b');
end

function plotUNullcline(vmin,vmax)
    v_lin=linspace(vmin,vmax,10000);
    u=-2.*(v_lin+60);
    
    plot(v_lin,u,'r');
end