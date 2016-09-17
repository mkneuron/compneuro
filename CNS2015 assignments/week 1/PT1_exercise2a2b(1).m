function Paul2a2b
clc
clear all
format long

N_h=100;
h_lin=linspace(0.01,0.5,N_h);
max_err_Euler=NaN(1,N_h);
max_err_RK2=NaN(1,N_h);
max_err_RK4=NaN(1,N_h);
max_err_ODE45=NaN(1,N_h);

i=1;
for h=h_lin
    %% Euler scheme
    ret=solveByEuler(h,-1,0,1);
    x=ret(1,:);
    y=ret(2,:);
    
    y_analytic=solveAnalytically(x);
    
    max_err_Euler(1,i)=max(abs(y-y_analytic));    
    %% RK2
    ret=solveByRK2(h,-1,0,1);
    x=ret(1,:);
    y=ret(2,:);
    
    y_analytic=solveAnalytically(x);
    
    max_err_RK2(1,i)=max(abs(y-y_analytic));    
    
    %% RK4
    ret=solveByRK4(h,-1,0,1);
    x=ret(1,:);
    y=ret(2,:);
    
    y_analytic=solveAnalytically(x);
    
    max_err_RK4(1,i)=max(abs(y-y_analytic));    
    
    %% ODE45
    [T,Y] = ode45(@d_system,linspace(0,1,100),-1);
    
    y_analytic=solveAnalytically(T);
    
    max_err_ODE45(1,i)=max(abs(Y-y_analytic));    

    i=i+1;
end

figure(1)
subplot(2,1,1)
title('Errors')
plot(h_lin,max_err_Euler,'r',h_lin,max_err_RK2,'g',h_lin,max_err_RK4,'b',h_lin,max_err_ODE45,'k')
xlabel('h');
ylabel('maximum error');
legend({'Euler', 'RK2', 'RK4', 'ode45'})
subplot(2,1,2)
title('Powers of h')
plot(h_lin,h_lin,'r',h_lin,h_lin.^2,'g',h_lin,h_lin.^4,'b')
legend({'1', '2','4'})
xlabel('h');

end

function val=solveAnalytically(x)
    val=-3.*exp(-x)-2.*x+2;
end

function dy=d_system(x,y)
    dy=-2.*x-y;
end

function val=solveByEuler(h,y0,x0,xEnd)
    i=1;
    x(1,i)=x0;
    y(1,i)=y0;
    while (x(1,i)<xEnd)
        y(1,i+1)=y(1,i)+h*f(x(1,i),y(1,i));
        x(1,i+1)=x(1,i)+h;
        
        i=i+1;
    end
    
    val=[x;y];
end

function val=solveByRK2(h,y0,x0,xEnd)
    i=1;
    x(1,i)=x0;
    y(1,i)=y0;
    while (x(1,i)<xEnd)
        y_w=y(1,i)+h*f(x(1,i),y(1,i));
        f_xn_h_yw=f(x(1,i)+h,y_w);
        y(1,i+1)=y(1,i)+1/2*h*(f(x(1,i),y(1,i))+f_xn_h_yw);
        
        x(1,i+1)=x(1,i)+h;
        
        i=i+1;
    end
    
    val=[x;y];
end

function val=solveByRK4(h,y0,x0,xEnd)
    i=1;
    x(1,i)=x0;
    y(1,i)=y0;
    while (x(1,i)<xEnd)
        k1=h*f(x(1,i),y(1,i));
        k2=h*f(x(1,i)+1/2*h,y(1,i)+1/2*k1);
        k3=h*f(x(1,i)+1/2*h,y(1,i)+1/2*k2);
        k4=h*f(x(1,i)+h,y(1,i)+k3);

        y(1,i+1)=y(1,i)+1/6*(k1+2*k2+2*k3+k4);
        
        x(1,i+1)=x(1,i)+h;
        
        i=i+1;
    end
    
    val=[x;y];
end

function val=f(x,y)
    val=-2*x-y;
end
