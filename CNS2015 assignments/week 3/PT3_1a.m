function Paul1a
clc
clear all

%% Specify parameter 
I=52; % I=51 is a critical current to make the neuron fires.
h=0.1;
tEnd=2000;
% tEnd=300;

%% Specify initial values
v_0=-50;
u_0=0;

t_lin=[0:h:tEnd];
v=nan(size(t_lin,2),1);
u=nan(size(t_lin,2),1);

t_i=1;
v(1,1)=v_0;
u(1,1)=u_0;
for t=t_lin
    tmp=calNextValues(v(t_i,1),u(t_i,1),I,h);
    
    v(t_i+1,1)=tmp(1,1);
    u(t_i+1,1)=tmp(2,1);
    
    t_i=t_i+1;
end

% figure(1)
% plot(v,u);

figure(2)
hold on
plot(t_lin(1,:),v([1:1:size(t_lin,2)],1),'r');

% figure(3)
% plot(t,u);


end

function val=calNextValues(v_n,u_n,I,h)
        z=[v_n;u_n];
        k1=h.*[f(z,I);g(z)];
        k2=h.*[f(z+(1/2).*k1,I);g(z+(1/2).*k1)];
        k3=h.*[f(z+(1/2).*k2,I);g(z+(1/2).*k2)];
        k4=h.*[f(z+k3,I);g(z+k3)];
        
        val=z+1/6.*(k1+2.*k2+2.*k3+k4);
        
        %% Reset condition
        if val(1,1)>35
            val(1,1)=-50;
            val(2,1)=val(2,1)+100;
        end
end

function val=f(z,I)
    val=(1/100).*(0.7.*(z(1,1)+60).*(z(1,1)+40)-z(2,1)+I);
end

function val=g(z)
    val=0.03.*(-2.*(z(1,1)+60)-z(2,1));
end