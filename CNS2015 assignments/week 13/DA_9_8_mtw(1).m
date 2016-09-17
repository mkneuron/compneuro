%%% Computational Neuroscience 2013
%%% Dayan & Abbott, Theoretical Neuroscience, exercise 9.8
%%% Actor-Critic implementation for maze of figure 9.7

% Marije ter Wal - 2013

clear; close; clc

% parameters & settings
epsilon = 0.5; %both for actor and critic
beta    = 1;
rewards = [[0,0];[0,5];[2,0]]; % reward matrix, rows indicate location (A,B,C)
                               % column indicates choice (Left or Right)
Nlocs    = size(rewards, 1);
Nactions = size(rewards, 2);

P_left = 0.5; %0.5 (normal) or 0.99

%% Policy evaluation (Figure 9.8)

Ntrials  = 30; %as in figure 9.8
m        = [[0,0]; [(1/beta)*log(P_left/(1-P_left)),0]; [(1/beta)*log(P_left/(1-P_left)),0]];
w        = zeros(Nlocs+1,Ntrials); %initialization of critic

for t = 2:Ntrials+1 %trials should run between 0 and 30
    
    % don't forget previous trials;
    w(:,t) = w(:,t-1);
      
    % A
    % determine action
    Pk     = exp(beta*m(1,:)) / sum(exp(beta*m(1,:))); % probability distributions
    choice = find(cumsum(Pk)-rand(1) >= 0, 1); % determines which action is chosen: 1 = left, 2 = right
    % update critic
    u_next   = 1 + choice;
    delta    = rewards(1,choice) + w(u_next,t) - w(1,t);
    w(1,t)   = w(1,t) + epsilon*delta;
    
    % B or C
    % determine action
    u = u_next;
    Pk     = exp(beta*m(u,:)) / sum(exp(beta*m(u,:))); % probability distributions
    choice = find(cumsum(Pk)-rand(1) >= 0, 1); % determines which action is chosen: 1 = left, 2 = right
    % update critic
    u_next   = 4; % for every possible state, expected future reward is zero
    delta    = rewards(u,choice) + w(u_next,t) - w(u,t);
    w(u,t)   = w(u,t) + epsilon*delta;
end

figure; 
x = 0:Ntrials;

subplot(131); hold on
plot(x, w(1,:), 'k', 'linewidth', 2);
fplot('1.75', [0 Ntrials], 'k:');
title('u = A'); xlabel('Trials'); ylabel('Weights');
xlim([0,Ntrials]); ylim([0,5]);

subplot(132); hold on
plot(x, w(2,:), 'k', 'linewidth', 2);
fplot('2.5', [0 Ntrials], 'k:');
title('u = B'); xlabel('Trials');
xlim([0,Ntrials]); ylim([0,5]);

subplot(133); hold on
plot(x, w(3,:), 'k', 'linewidth', 2);
fplot('1', [0 Ntrials], 'k:');
title('u = C'); xlabel('Trials');
xlim([0,Ntrials]); ylim([0,5]);

%% Actor-critic learning (Figure 9.9)

Ntrials  = 100; %as in figure 9.9
m        = zeros(Nlocs,Nactions,Ntrials); %initialization of actor
m(:,:,1) = [[0,0]; [(1/beta)*log(P_left/(1-P_left)),0]; [(1/beta)*log(P_left/(1-P_left)),0]];
w        = zeros(Nlocs+1,Ntrials); %initialization of critic
choice   = zeros(Nlocs,1);

for t = 2:Ntrials+1 %trials should run between 0 and 30
    
    % don't forget previous trials;
    w(:,t) = w(:,t-1);
    m(:,:,t) = m(:,:,t-1);
    
    % A
    % determine action
    Pk        = exp(beta*m(1,:,t)) / sum(exp(beta*m(1,:,t))); % probability distributions
    choice = find(cumsum(Pk)-rand(1) >= 0, 1); % determines which action is chosen: 1 = left, 2 = right
    % update actor and critic
    u_next   = 1 + choice; %this only works for three locations
    delta    = rewards(1,choice) + w(u_next,t) - w(1,t);
    w(1,t)   = w(1,t) + epsilon*delta;
    m(1,:,t) = m(1,:,t) + epsilon*( (1:Nactions == choice) - Pk) * delta;
    
    % B or C
    % determine action
    u = u_next;
    Pk        = exp(beta*m(u,:,t)) / sum(exp(beta*m(u,:,t))); % probability distributions
    choice = find(cumsum(Pk)-rand(1) >= 0, 1); % determines which action is chosen: 1 = left, 2 = right
    % update actor and critic
    u_next   = 4; % for every possible state, expected future reward is zero
    delta    = rewards(u,choice) + w(u_next,t) - w(u,t);
    w(u,t)   = w(u,t) + epsilon*delta;
    m(u,:,t) = m(u,:,t) + epsilon*( (1:Nactions == choice) - Pk) * delta;
end

figure;
x = 0:Ntrials;
PL = @(mscal, mvect) exp(beta*mscal) ./ sum(exp(beta*mvect),2);

subplot(131); hold on
plot(x, squeeze(PL(m(1,1,:),m(1,:,:))), 'k', 'linewidth', 2);
title('u = A'); xlabel('Trials'); ylabel('P(L;u)');
xlim([0,Ntrials]); ylim([0,1]);

subplot(132); hold on
plot(x, squeeze(PL(m(2,1,:),m(2,:,:))), 'k', 'linewidth', 2);
title('u = B'); xlabel('Trials');
xlim([0,Ntrials]); ylim([0,1]);

subplot(133); hold on
plot(x, squeeze(PL(m(3,1,:),m(3,:,:))), 'k', 'linewidth', 2);
title('u = C'); xlabel('Trials');
xlim([0,Ntrials]); ylim([0,1]);
