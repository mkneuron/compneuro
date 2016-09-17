%%% Solutions to CNS exercises PT1 from October 3th 2013 %%%

% Use Ctrl+Enter to execute one cell at a time


%% Exercise 1b

clear; close; clc

f_x = @(x) x*exp(-x)+1;

root = fzero(f_x, 0); %find root starting from x0 = 0

fprintf('Root at x = %0.5f\n', root);

figure; hold on
fplot(f_x, [-1 10], 'k'); %plot function
fplot('0', [-1 10], 'k:'); %plot f(x) = 0
fplot('1', [-1 10], 'k:'); %plot a=1
scatter(root, f_x(root),40,'k','filled'); %plot root
xlabel('x');
ylabel('f(x)')


%% Exercise 1c

clear; close; clc

% from the plot in 1b we can deduce that there are two roots when 
% lim (x>Inf) f(x) < 0. This limit is equal to a.
% For two roots it is also required that the maximum of the function is
% larger than zero: fmax = 0. Fmax is found where df/dx = 0:
% df/dx = (1-x)exp(-x) = 0 gives xmax = 1 and fmax = f(1) = exp(-1)+a.
% From fmax > 0 we find a > -1/e. So, between a = -1/e and a = 0, we find
% two roots. For higher values of a we'll find one root.

% Matlab has an implementation of the set of functions our f(x) belongs to,
% namely the Lambert W functions:

amin = -1/exp(1); %e is not defined, but exp(1) is
aVal_low = linspace(amin,2,100);      % Define values of a
x_i = 1;
for a = aVal_low
    x_low_branch(1,x_i) = -lambertw(0,a); % Analytic solution
    x_i = x_i+1;
end

aVal_high = linspace(amin,0,100);         % Define values of a
x_i = 1;
for a = aVal_high
    x_up_branch(1,x_i) = -lambertw(-1,a); % Analytic solution
    x_i = x_i+1;
end

figure; hold on
plot(aVal_low, x_low_branch, 'k');
plot(aVal_high, x_up_branch, 'k');
xlabel('a'); ylabel('root');

%% Exercise 1d

clear; close; clc

amin = -1/exp(1); %e is not defined, but exp(1) is
f_xa = @(x,a) x*exp(-x)+a;

% lower root
aVal_low = linspace(amin,2,100);
roots_low = zeros(numel(aVal_low),1)';

for Ia = 1:length(aVal_low)
    a = aVal_low(Ia); %set value for a
    f_x = @(x) f_xa(x,a); %redefine function with new a
    roots_low(Ia) = fzero(f_x, 0); %find root starting from x0 = 0
end

% upper root
aVal_high = linspace(amin,0,100);
roots_high = zeros(numel(aVal_high),1)';
for Ia = 1:length(aVal_high)
    a = aVal_high(Ia); %set value for a
    f_x = @(x) f_xa(x,a); %redefine function with new a
    roots_high(Ia) = fzero(f_x, 10); %find root starting from x0 = 0
end

figure; hold on
scatter(aVal_low, roots_low, 20, 'k', 'filled');
scatter(aVal_high, roots_high, 20, 'k', 'filled');
xlabel('a');
ylabel('root')
