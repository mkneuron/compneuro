%%% Computational Neuroscience 2013 - 
%%% Dayan & Abbott exercise 9.5 - 

% Marije ter Wal - 2013


clear all; close all; clc

% settings & parameters
randR_onset = 0; % set to 0 for fixed stimulus-reward interval, set to 1 for random interval

Ttot      = 300; % all times are in 'units'
dt        = 5;
Tnumb     = Ttot/dt + 1; % +1 to allow for t=0
Ntrials   = 300;
learnRate = 0.4; % per time step

% stimulus trace - see Fig 9.2
u_onset      = 100;
u            = zeros(Tnumb,1);
u(u_onset/dt +1) = 1;

% allocation
v       = zeros(Tnumb,1);
delta   = zeros(Tnumb,Ntrials);
w       = zeros(Tnumb,1);

figure('Name', 'Figure 9.2B', 'Position', [50, 50, 500, 600]);
for n = 1:Ntrials % loop over trials
    
    % reward trace - allows for random reward delivery
    if randR_onset == 1;
        r_onset = u_onset+50+100*rand(1); % uniform distr. between 50 and 150
    else
        r_onset = 200;
    end
    r = zeros(Tnumb,1);
    r(round(r_onset/dt) +1:round((r_onset+10)/dt) +1) = 1/5;
    
    for t = 1:Tnumb-1 % time after trial onset
        v(t+1)     = w(1:t+1)'*flipud(u(1:t+1));
        delta(t,n) = r(t) + v(t+1) - v(t);
        w(1:t)     = w(1:t) + learnRate*delta(t,n)*flipud(u(1:t));
    end
    
    % plot instantaneous values (Figure 9.2B)
    subplot(511); plot(0:dt:Ttot, u, 'k'); ylabel('u'); ylim([-0.2,1.2])
    title(['Trial # ', num2str(n)]);
    subplot(512); plot(0:dt:Ttot, r, 'k'); ylabel('r'); ylim([-0.05,0.25])
    subplot(513); plot(0:dt:Ttot, v, 'k'); ylabel('v'); ylim([-0.02,1])
    subplot(514); plot(0:dt:Ttot, [0;diff(v)], 'k'); ylabel('\Deltav'); ylim([-0.5,1])
    subplot(515); plot(0:dt:Ttot, delta(:,n), 'k'); ylabel('\delta'); ylim([-0.3,1])
    xlabel('Time')
    drawnow
end

% surface plot (Figure 9.2A)
figure('Name', 'Figure 9.2A'); hold on;
mesh(0:dt:Ttot, 1:5:Ntrials, delta(:,1:5:end)')
colormap([0,0,0])
view(15,30)
xlabel('Time')
ylabel('Trials')
zlabel('\delta')