%%% Computational Neuroscience 2013 - 
%%% Reproduction of Figure 18 from Sutton & Barto, 1990

% Marije ter Wal - 2013


clear all; close all; clc

% settings
ISIs    = [-0.1, -0.05, 0, 0.05, 0.1, 0.15, 0.20, 0.25, 0.35, 0.5, 1, 2, 4]; % s, I tried to match the values in Fig. 18;
dt      = 50; %ms
Ntrials = 80;

% parameters taken from Sutton & Barto, 1990 appendix
alpha   = 0.1; 
beta    = 1; %s^-1
delta   = 0.2; %s^-1
gamma   = 0.95; %s^-1

CS_onset    = 00; %ms
CS_length   = 200; %ms
US_length   = 100; %ms

% initialization
Vfinal_fixed = zeros(length(ISIs),1);
Vfinal_delay = zeros(length(ISIs),1);


for i = 1:length(ISIs) % ISIs
    fprintf('Calculating RL for ISI = %f s\n', ISIs(i));
    
    % additional settings
    ISI      = ISIs(i)*1e3; %from s to ms
    US_onset = CS_onset + ISI;
    T        = US_onset + US_length + 100; % duration of a single trial (trial termination is 100 ms after US offset)
    Tnumb    = ceil(T / dt);
    
    % allocation and initialization
    V_fixed  = zeros(Tnumb+1,1); %index 1 is time=0
    V_delay  = zeros(Tnumb+1,1); 
    Xbar_fixed     = zeros(Tnumb+1,1);
    Xbar_delay     = zeros(Tnumb+1,1);
    
    % generate stimuli - look at Fig.6
    X_fixed = zeros(Tnumb+1,1); % CS trace
    X_fixed(round(CS_onset/dt) +1 : round((CS_onset+CS_length)/dt)) = ones(round(CS_length/dt), 1);
    
    X_delay = zeros(Tnumb+1,1); % CS trace
    if ISI <= 0; continue
    else X_delay(round(CS_onset/dt) +1 : round((CS_onset+ISI)/dt)) = ones(round(ISI/dt), 1);
    end
    
    lambda   = zeros(Tnumb+1,1); % here we use for lambda the US trace: if there is a US, their will be a reward
    lambda(round(US_onset/dt) +1 : round((US_onset+US_length)/dt)) = ones(round(US_length/dt), 1);
         
    % calculate CS prediction traces (those are identical for all trials
    % and for all ISIs in the fixed-CS condition, but not the delay condition)
    for t = 1:Tnumb
        Xbar_fixed(t+1) = Xbar_fixed(t) + delta*(X_fixed(t) - Xbar_fixed(t));
        Xbar_delay(t+1) = Xbar_delay(t) + delta*(X_delay(t) - Xbar_delay(t));
    end

    % run Reinforcement Learning for both the 'fixed-CS' protocol and the
    % 'delay' protocol
    for trial = 1:Ntrials % trials
        V_fixed(1) = V_fixed(end); %continue where the previous trial stopped
        V_delay(1) = V_delay(end);
        
        for t = 1:Tnumb; % time for a single trial
            
            % fixed-CS
            dV = beta*(lambda(t+1) + gamma*max(0, V_fixed(t)*X_fixed(t+1)) ...
                - max(0,V_fixed(t)*X_fixed(t)))*alpha*Xbar_fixed(t+1);
            V_fixed(t+1) = V_fixed(t) + dV;
            
            if ISI < 0; continue
            else
                % delay
                dV = beta*(lambda(t+1) + gamma*max(0, V_delay(t)*X_delay(t+1)) ...
                    - max(0,V_delay(t)*X_delay(t)))*alpha*Xbar_delay(t+1);
                V_delay(t+1) = V_delay(t) + dV;
            end

        end
    end
    Vfinal_fixed(i) = V_fixed(end);
    Vfinal_delay(i) = V_delay(end);
end

% Plot results
figure('Name', 'Figure 18 from Sutton & Barto, 1990','Position', [100, 100, 700, 400]); hold on
title('Associative strength of conditioned stimulus after 80 trials')
plot(ISIs, Vfinal_fixed, ':k', 'linewidth', 2);
plot(ISIs(ISIs>0), Vfinal_delay(ISIs>0), 'k', 'linewidth', 2);
xlim([-0.25, 4.1]); xlabel('CS-US ISI (s)')
ylim([-0.05, 1.75]); ylabel('V'); set(gca, 'ytick', linspace(0,2,round(2/0.25)+1))
legend('Fixed-CS', 'Delay')
legend boxoff

