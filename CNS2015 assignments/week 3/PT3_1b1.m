function Paul1b1
clc
clear all

%% Specify parameter 
I_lin=linspace(50,55,100);
h=0.1;
% tEnd=300;
tEnd=2000;

%% Specify initial values
v_0=-50;
u_0=0;

FR_i=1;
FR=nan(size(I_lin,2),1);
for I=I_lin
    I
    FR(FR_i,1)=getFiringRateAtI(v_0,u_0,I,h,tEnd);
    FR_i=FR_i+1;
end

figure(2)
hold on
plot(I_lin,FR,'r*');



end

function val=getFiringRateAtI(v_0,u_0,I,h,tEnd)
    t=0;
    v=v_0;
    u=u_0;
    no_spike=0;
    while t<tEnd
        tmp=calNextValues(v,u,I,h);

        v=tmp(1,1);
        u=tmp(2,1);

        if (0<tmp(3,1))
            no_spike=no_spike+1;
        end

        t=t+h;
    end
    val=no_spike/tEnd;
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
        val(3,1)=1; % To tell that the oscillator spikes
    else
        val(3,1)=0;
    end
end

function val=f(z,I)
    val=(1/100).*(0.7.*(z(1,1)+60).*(z(1,1)+40)-z(2,1)+I);
end

function val=g(z)
    val=0.03.*(-2.*(z(1,1)+60)-z(2,1));
end