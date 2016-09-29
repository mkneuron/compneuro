%% Exercise 2a

f = @(x,y) -2*x-y;  % function to be analysed
y_0 = -1;           % starting point of y
interval = [0 1];   % x in [0,1]
h_vals = [0.01,0.05,0.1,0.25,0.5];

% Euler, RK2 and the analytical solution
euler = @(x_i,y_i,h) y_i + h*f(x_i,y_i);
rungekutta = @(x_i,y_i,h) y_i + 1/2*h*(f(x_i,y_i)+f(x_i+h,y_i+h*f(x_i,y_i)));
analytical = @(x) -3*exp(-x)-2*x+2;

euler_error = length(h_vals);
rungekutta_error = length(h_vals);
for num_run = 1:length(h_vals)
    h = h_vals(num_run);

x = interval(1):h:interval(2);
num_x = length(x);

% allocate memory
y_euler = zeros(1,num_x);
y_rk = zeros(1,num_x);
y_analytical = zeros(1,num_x);

% solve analytically
for i = 1:num_x  % calculate the function inside [0,1]
    y_analytical(i) = analytical(x(i));
end

% solve using Euler and RK2
y_euler(1) = y_0;
y_rk(1) = y_0;

e_err = zeros(1,num_x-1);
rk_err = zeros(1,num_x-1);
for i = 2:num_x  % calculate the function inside [0,1]
    y_euler(i) = euler(x(i-1),y_euler(i-1),h);
    y_rk(i) = rungekutta(x(i-1),y_rk(i-1),h);
    
    e_err(i-1) = (y_analytical(i)-y_euler(i))^2;
    rk_err(i-1) = (y_analytical(i)-y_rk(i))^2;
end
euler_error(num_run) = mean(e_err);
rungekutta_error(num_run) = mean(rk_err);

figure;
plot(x,y_euler,'b-.',x,y_rk,'m--',x,y_analytical,'g-');
xlabel('x');ylabel('f(x,y)=-2x-y');
title(sprintf('h=%f',h));
legend('Euler','Runge-Kutta','Analytical');
end

% print error
for i = 1:length(h_vals)
disp(sprintf('When h=%.2f Euler error=%f and RK2 error=%f.',h_vals(i),euler_error(i),rungekutta_error(i)));
end

%% Exercise 2b

analytical = @(x) -3*exp(-x)-2*x+2;

f = @(x,y) -2*x-y;  % function to be analysed
y_0 = -1;           % starting point of y
interval = [0 1];   % x in [0,1]
x_vals = linspace(interval(1),interval(2),100);
[t,y_ode45] = ode45(f,x_vals,y_0);

% solve analytically
y_analytical = zeros(1,length(x_vals));
for i = 1:length(x_vals)  % calculate the function inside [0,1]
    y_analytical(i) = analytical(x_vals(i));
end

figure;
plot(x_vals,y_analytical,'g-',t,y_ode45,'b:');
xlabel('x');ylabel('f(x,y)=-2x-y');
title('Function ode45');
legend('Analytical','ode45');

