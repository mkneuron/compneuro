%%% Computational Neuroscience 2013 - 
%%% Dayan & Abbott exercise 9.6 - 

% Marije ter Wal - 2013


clear all; close all; clc

% settings
k       = 3; % number of arms
p       = [1/4, 1/2, 3/4]; 
assert(length(p) == k, 'Length of p vector does not match number of arms')

% show m-traces for single pair of epsilon and beta  

% settings
Ntrials = 1000;
Nswap   = 250; % # trials after which a policy change occurs
epsilon = 0.01; % learning rate; 0.01, 0.1 or 0.5
beta    = 100; % balance between exploration and exploitation; 1, 10, 100

% allocation & initialization
m       = zeros(Ntrials+1,k); 
reward  = zeros(Ntrials,k);
choice  = zeros(Ntrials,1);
Nvisits = zeros(Ntrials,k);
Ptrace  = zeros(Ntrials,k);

for n = 1:Ntrials
    % swap reward probabilities after Nswap trials
    Ptrace(n,:) = p;
    if mod(n,Nswap) == 0; 
        [~,Id] = sort(rand(3,1));
        p = p(Id);
        Ptrace(n,:) = NaN;
    end

    
    % make a choice
    Pk        = cumsum(exp(beta*m(n,:)) / sum(exp(beta*m(n,:)))); % probability distributions
    choice(n) = find(Pk-rand(1) >= 0, 1); % determines which arm is chosen
    C = choice(n);
    reward(n,C) = (sign(p(C) - rand(1)) + 1)/2; % win (1) or lose (0)?
    Nvisits(n:end,C) = Nvisits(n,C) + 1;

    fprintf('Arm %i was chosen and the reward was %i\n', choice(n), reward(n,choice(n)));
    
    % learn
    m(n+1:end,C) = m(n,C) + epsilon*(reward(n,C) - m(n,C));
end  

% plot results
figure('Position', [50, 50, 900, 500]);
subplot(121); hold on
plot(1:Ntrials, m(1:Ntrials,:)', 'linewidth', 1);
plot(1:Ntrials, Ptrace);
plot([0:Nswap:Ntrials;0:Nswap:Ntrials], [-0.05, 1.05],':k')
ylim([-0.05, 1.05]); ylabel('m');
xlabel('Trial')
legend({'m_{1}', 'm_{2}', 'm_{3}'});
subplot(122);
plot(1:Ntrials, Nvisits);
ylabel('# visits');
xlabel('Trial');

%% compare epsilon and beta

clear all; 

% settings
k       = 3; % number of arms
p       = [1/4, 1/2, 3/4];
        assert(length(p) == k, 'Length of p vector does not match number of arms')

% show m-traces for single pair of epsilon and beta

% settings
Ntrials = 20000;
Nswap   = 250;
epsilon = [0.01,0.1,0.5]; % learning rate; 0.01, 0.1 or 0.5
beta    = [5,10,100]; % balance between exploration and exploitation; 1, 10, 100

% allocation
data    = zeros(length(epsilon), length(beta));

for e = 1:length(epsilon);
    for b = 1:length(beta);
        
        % reset random number generator
        s = RandStream('mcg16807','Seed',1);
        RandStream.setGlobalStream(s);

        % initialization
        m         = zeros(1,k);
        rewardTot = 0;
        
        for n = 1:Ntrials
            % swap reward probabilities after Nswap trials
            if mod(n,Nswap) == 0;
                [~,Id] = sort(rand(3,1));
                p      = p(Id);
            end
            
            % make a choice
            Pk     = cumsum(exp(beta(b)*m) / sum(exp(beta(b)*m))); % probability distributions
            choice = find(Pk-rand(1) >= 0, 1); % determines which arm is chosen
            reward = (sign(p(choice) - rand(1)) + 1)/2; % win or lose?
            rewardTot = rewardTot + reward;
            
            % learn
            m(choice) = m(choice) + epsilon(e)*(reward - m(choice));
        end
    data(e,b) = rewardTot;
    end
end

figure;
bar3(data);
colormap(flipud(autumn))
set(gca, 'xticklabel', beta);
set(gca, 'yticklabel', epsilon);
view([-55,35])
xlabel('\beta')
ylabel('\epsilon')
zlabel('Total reward')

%% Reproducing Figure 9.4 - not part of the exercise

% clear all
% 
% % settings
% k       = 2; % number of choices. Here, yellow and blue flowers
% p       = [0.5, 0.5]; 
% ra      = [1, 2]./p;  % reward per flower. In the book it was given that
                        % <ra> = [1,2];
% 
% % settings
% Ntrials = 200;
% Nswap   = 100;
% epsilon = 0.1; 
% beta    = 1; 
% 
% % allocation & initialization
% m       = zeros(Ntrials+1,k); 
% reward  = zeros(Ntrials,k);
% choice  = zeros(Ntrials,1);
% Nvisits = zeros(Ntrials, k);
% 
% for n = 1:Ntrials
% %     swap reward probabilities after Nswap trials
%     if mod(n,Nswap) == 0; 
%         ra = fliplr(ra);
%     end
%     
%     % make a choice
%     Pk        = cumsum(exp(beta*m(n,:)) / sum(exp(beta*m(n,:)))); % probability distributions
%     choice(n) = find(Pk-rand(1) >= 0, 1); % determines which arm is chosen
%     C = choice(n);
%     reward(n,C) = ((sign(p(C) - rand(1)) + 1)/2) * ra(C);
%     Nvisits(n:end,C) = Nvisits(n,C) + 1;
%     
%     % learn
%     m(n+1:end,C) = m(n,C) + epsilon*(reward(n,C) - m(n,C));
% end  
% 
% figure('Position', [50, 50, 700, 400]);
% subplot(121); hold on
% plot(1:Ntrials, m(1:Ntrials,:)', 'linewidth', 2);
% plot(1:Ntrials, repmat(p.*ra,[Ntrials,1]), ':k');
% ylim([-0.05, 3.05]); ylabel('m');
% xlabel('Trial')
% legend({'m_{b}', 'm_{y}'}, 'Location', 'SouthEast'); 
% subplot(122);
% plot(1:Ntrials, Nvisits);
% ylim([-2,120]); ylabel('# visits');
% xlabel('Trial');