%%% Computational Neuroscience 2013
%%% Dayan & Abbott, Theoretical Neuroscience, exercise 9.9
%%% Actor-Critic implementation for maze of figure 9.7, with state vector

% Marije ter Wal - 2013

%-------------------------------------------------------------------------%
% Q: How the speed of learning depends on 'a' and why:
% A: Using an 'a' of 0.5 decreases the speed of learning at A whereas using an a
% of -0.5 increases the speed of learning at A. To see why, we consider Eq.
% (9.27). From Eq. (9.27), m_Left(A)=M_(Left,1)+M_(Left,2)*a+M_(Left,3)*a,
% m_Left(B)=M_(Left,2), and m_Left(C)=M_(Left,3). Let assume that a>0. We 
% see that when a>0, m_Left(A) changes in the same direction as m_Left of B
% and C. The optimal solutions at B and C are to turn right and left, 
% respectively. This means than you're dragged by B to turn right and by C 
% to turn left at A. Which one is the winner? Because B has bigger reward, 
% A will be dragged by B to turn right more often. So, it will take more 
% time in case of a>0 to learn to go left. You can play around with the 
% location of reward to see this.
%-------------------------------------------------------------------------%

clear; clc

% parameters & settings
epsilon = 0.5; %both for actor and critic
beta    = 1;
rewards = [[0,0];[0,5];[2,0]]; % reward matrix, rows indicate location (A,B,C)
% column indicates choice (Left or Right)
Nlocs    = size(rewards, 1);
Nactions = size(rewards, 2);

Ntrials  = 50; %as in figure 9.9
m        = zeros(Nactions,Nlocs, Ntrials); %initialization of actor
w        = zeros(Nlocs,Ntrials); %initialization of critic
choice   = zeros(Nlocs,1);

% state vector
aVal     = [0.5,0,-0.5];

figure;
x = 0:Ntrials;
PL = @(mscal, mvect) exp(beta*mscal) ./ sum(exp(beta*mvect),1);
colors = gray(numel(aVal)+2);
c = 1;

for a = aVal
    
    rand('seed', 1);  
    state    = [[1,a,a];[0,1,0],;[0,0,1]];
    
    % Actor-critic learning (state vector impementation)
    for t = 2:Ntrials+1 %trials should run between 0 and 30
        
        % don't forget inbetween trials;
        w(:,t) = w(:,t-1);
        m(:,:,t) = m(:,:,t-1);
        
        % A
        % determine action
        Pk        = exp(beta*m(:,:,t)*state(1,:)') / sum(exp(beta*m(:,:,t)*state(1,:)')); % probability distributions
        choice = find(cumsum(Pk)-rand(1) >= 0, 1); % determines which action is chosen: 1 = left, 2 = right
        
        % update actor and critic
        v        = w(:,t)'*state(1,:)';
        u_next   = 1 + choice; %this only works for three locations
        v_next   = w(:,t)'*state(u_next,:)';
        
        delta    = rewards(1,choice) + v_next - v;
        w(:,t)   = w(:,t) + epsilon * delta * state(1,:)';
        m(:,:,t) = m(:,:,t) + (state(1,:)' * epsilon*( (1:Nactions == choice)' - Pk)' * delta)';
        
        % B or C
        % determine action
        u = u_next;
        Pk        = exp(beta*m(:,:,t)*state(u,:)') / sum(exp(beta*m(:,:,t)*state(u,:)')); % probability distributions
        choice = find(cumsum(Pk)-rand(1) >= 0, 1); % determines which action is chosen: 1 = left, 2 = right
        
        % update actor and critic
        v        = w(:,t)'*state(u,:)';
        v_next   = 0;
        delta    = rewards(u,choice) + v_next - v;
        w(:,t)   = w(:,t) + epsilon * delta * state(u,:)';
        m(:,:,t) = m(:,:,t) + (state(u,:)' * epsilon*( (1:Nactions == choice)' - Pk)' * delta)';
    end
    
    subplot(131); hold on
    plot(x, squeeze(PL(m(1,1,:),m(:,1,:))), 'color', colors(c+1,:), 'linewidth', 2);
    title('u = A'); xlabel('Trials'); ylabel('P(L;u)');
    xlim([0,Ntrials]); ylim([0,1]);
    
    subplot(132); hold on
    plot(x, squeeze(PL(m(1,2,:),m(:,2,:))), 'color', colors(c+1,:), 'linewidth', 2);
    title('u = B'); xlabel('Trials');
    xlim([0,Ntrials]); ylim([0,1]);
    
    subplot(133); hold on
    plot(x, squeeze(PL(m(1,3,:),m(:,3,:))), 'color', colors(c+1,:), 'linewidth', 2);
    title('u = C'); xlabel('Trials');
    xlim([0,Ntrials]); ylim([0,1]);
    
    c = c+1;
end

subplot(131)
legend({'a = 0.5', 'a = 0', 'a = -0.5'}, 'Location', 'South')
legend boxoff