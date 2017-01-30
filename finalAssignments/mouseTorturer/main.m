%function [  ] = actor_critic_assignment(  )
% Main function
%% TODOS
%{
Environment TODO:
--------
Make sure that all values make sense.
e.g. map_radius

Actor-Critic loop TODO:
--------
* implement learning rate

Plotting TODO:
--------
* Basically everything

%}
%% init vars
clc;clear all;close all;
act_Cells = 8;          % equivalent to the number of possible actions
P_Cels = 493;           % number of place cells
pool_radius = 41;       % radius in cm (aka pixels ?)
platform_R = 6;         % platform radius in cm (aka pixels ?)
p_std = 16;             % place cell std, aka sigma
strict_place = 1;       % forbid place cell centers outside maze
totalTrials = 22;       % number of total trials
plat_posit = 1:4;       % number of platform positions
timeline = 0:0.1:120;   % time as described in paper
random_start = 0;       % toggle random start (see voluntary_jump.m) 
eta_a = 0.7;            % actor learning rate
eta_c = 0.7;            % critic learning rate
plot_trials = 1:7:22;   % trials for which to plot
pope = 'not me';        % a part of the code will run when I'm the pope
% plot_trials = 1:22;
%% Get environment map and coordinates of place cells
% e.g. [map, cell_coord, platform_mask] = ...
%       RL_env(Pcel, pool_radius, platform_R, p_std, strict_place)
[map, cell_coord, platform] = RL_env(P_Cels,pool_radius, ...
                                     platform_R,p_std,strict_place); 
map_dims=size(map,2); % map dimensions


%% Actor-Critic loop

% Initialize weights.
% actor weights as named in the paper
z_ij          = ones(P_Cels, act_Cells); % weights place cell to actor
w_critic      = ones(P_Cels,1);  % weights of critic

% % init loggers
p_log = zeros(size(map,1),size(map,2),totalTrials); % logs mouse path
C_log = zeros(size(map,1),size(map,2),totalTrials); % logs C-value function
% ac_log = nan(
% wc_log = nan(totalTrials,); % at least it's not a green log

% % init loop variables
daily_trial = 0;

for trialN0=1:totalTrials

    % reset every day
    if mod(trialN0-1,4) == 0 % every fourth trial 
        % get a mouse to do 4 voluntary jumps into the pool
        v_rat_position = voluntary_jump(map_dims,pool_radius);
        daily_trial = 0; % reset platform iterator
    end
    
    % iterators
    daily_trial = daily_trial +1; % iterates through the platform positions
    
    % reset every trial
    Cprev = 0; % Critic'opinion of the value function at t-1
    pred_err = 1; % Critic's error
    momentum = [0,0]; % momentum of swimming rat
    Reward = 0;
    t = 0;
    rat_position = v_rat_position(daily_trial,:); % get starting point
    
    sprintf(['Trial' num2str(trialN0)])
    while t<=length(timeline) && ~Reward % single trial loop
        
        % iterators
        t = t+1; % where t is timestep equal to 0.1s
        
        % get spike rates for place cells
        spikeCounts = placeCells_spikeRate(rat_position,cell_coord,p_std);
        % feed place cell activity, prediction error and weights to actor
        [direction, z_ij_dx] = actor(act_Cells, spikeCounts, pred_err, z_ij);
        % move the mouse 
        [rat_position, momentumm,trajectory] = ...
            move_rat(rat_position,direction,map,momentum);
        % check for reward
        if platform(rat_position(1),rat_position(2))
            Reward = 1;
            fprintf('Mouse ready for ascension')
        end
        
        % log mouse movement
        p_log(rat_position(1),rat_position(2),trialN0)= ...
             p_log(rat_position(1),rat_position(2),trialN0) +1;
        imagesc(p_log(:,:,trialN0)+platform)
        drawnow;
        % [C-value fuction, prediction error, change in weights]
        [C,pred_err,dw]= Critic(spikeCounts,w_critic,Reward,Cprev);
        Cprev=C;
        
        % Update Weights
        z_ij = z_ij + eta_a*z_ij_dx'; % actor
        w_critic= w_critic + eta_c*dw;  % critic
    end
    
    
    % log critic's take of the value function for all positions
    if any(trialN0==plot_trials) && strcmp(pope,'me')
        for i = 1:size(map,1)
            for j = 1:size(map,2)
                spikeCounts = placeCells_spikeRate([i,j],cell_coord,p_std);
                [C,pred_err,dw]= Critic(spikeCounts,w_critic,0,0);
                C_log(i,j,trialN0) = C;
            end
        end
    end
end


for i = 1:numel(plot_trials)
    
    % plot path
    figure(i)
    imagesc(p_log(:,:,plot_trials(i))+platform)
    title(['Mouse movement in trial ' num2str(plot_trials(i))]);
    
%     % plot value function
%     figure(i+numel(plot_trials))
%     surf(1:size(map,2),1:size(map,1),C_log(:,:,i))
%     title(['C-value function at the end of trial' num2str(plot_trials(i))]);
end

% end % function end
