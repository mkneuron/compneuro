function Paul2d2e
clc
clear all
format long

h=0.01;         % Step size
I=-0.5;         % Constant input
tEnd=10;        % End time of simulation
y10=0.0;        % Initial value of y1
y20=0.5;        % Initial value of y2

%% Euler scheme
ret=solveByEuler(h,I,[y10;y20],0,tEnd);
y1=ret(2,:);
y2=ret(3,:);

figure(1)
hold on
plot(y1,y2,'r')

%% RK2
ret=solveByRK2(h,I,[y10;y20],0,tEnd);
y1=ret(2,:);
y2=ret(3,:);

figure(1)
hold on
plot(y1,y2,'g')

%% RK4
ret=solveByRK4(h,I,[y10;y20],0,tEnd);
y1=ret(2,:);
y2=ret(3,:);

figure(1)
hold on
plot(y1,y2,'b')

%% ODE45
[T,Y] = ode45(@(x,y) d_system(x,y,I),[0 tEnd],[y10 y20]);

figure(1)
hold on
plot(Y(:,1),Y(:,2),'k*')

end

function dy=d_system(x,y,I)
    dy(1,1)=y(2);
    dy(2,1)=I-sin(y(1));
end

function val=solveByEuler(h,I,y0,x0,xEnd)
    i=1;
    x(1,i)=x0;
    y(:,i)=y0;
    while (x(1,i)<xEnd)
        y(:,i+1)=y(:,i)+h.*f(y(:,i),I);
        x(1,i+1)=x(1,i)+h;
        
        i=i+1;
    end
    
    val=[x;y];
end

function val=solveByRK2(h,I,y0,x0,xEnd)
    i=1;
    x(1,i)=x0;
    y(:,i)=y0;
    while (x(1,i)<xEnd)
        y_w=y(:,i)+h.*f(y(:,i),I);
        f_xn_h_yw=f(y_w,I);
        y(:,i+1)=y(:,i)+1/2.*h.*(f(y(:,i),I)+f_xn_h_yw);
        
        x(1,i+1)=x(1,i)+h;
        
        i=i+1;
    end
    
    val=[x;y];
end

function val=solveByRK4(h,I,y0,x0,xEnd)
    i=1;
    x(1,i)=x0;
    y(:,i)=y0;
    while (x(1,i)<xEnd)
        k1=h.*f(y(:,i),I);
        k2=h.*f(y(:,i)+1/2.*k1,I);
        k3=h.*f(y(:,i)+1/2.*k2,I);
        k4=h.*f(y(:,i)+k3,I);

        y(:,i+1)=y(:,i)+1/6.*(k1+2.*k2+2.*k3+k4);
        
        x(1,i+1)=x(1,i)+h;
        
        i=i+1;
    end
    
    val=[x;y];
end

function val=f(y,I)
    val=[y(2,1);I-sin(y(1,1))];
end
