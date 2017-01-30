function [  ] = actor_critic_assignment(  )
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

act_Cells = 8;          % equivalent to the number of possible actions
P_Cels = 493;           % number of place cells
pool_radius = 133;      % radius in cm (aka pixels ?)
platform_R = 6;         % platform radius in cm (aka pixels ?)
p_std = 16;             % place cell std, aka sigma
strict_place = 1;       % forbid place cell centers outside maze
totalTrials = 22;       % number of total trials
plat_posit = 1:4;       % number of platform positions
timeline = 0:0.1:120;   % time as described in paper
random_start = 0;       % toggle random start (see voluntary_jump.m) 
eta_a = 0.7;            % actor learning rate
eta_c = 0.7;            % critic learning rate

%% Get environment map and coordinates of place cells
% e.g. [map, cell_coord, platform_mask] = ...
%       RL_env(Pcel, pool_radius, platform_R, p_std, strict_place)
[map, cell_coord, platform] = RL_env(P_Cels,pool_radius, ...
                                     platform_R,p_std,strict_place); 
map_dims=size(map,2); % map dimensions


%% Actor-Critic loop

% Initialize weights.
% actor weights as named in the paper
z_ij = rand(P_Cels, act_Cells); % weights place cell to actor
w_critic      = zeros(P_Cels,1);  % weights of critic

% init loop variables
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
    pred_err = 0; % Critic's error
    momentum = [0,0]; % momentum of swimming rat
    Reward = 0;
    t = 0;
    rat_position = v_rat_position(daily_trial,:); % get starting point
    
    while t<=length(timeline) && ~Reward % single trial loop
        
        % iterators
        t = t+1; % where t is timestep equal to 0.1s
        
        % get spike rates for place cells
        spikeCounts = placeCells_spikeRate(rat_position,cell_coord,p_std);
        % feed place cell activity, prediction error and weights to actor
        [direction, z_ij_dx] = actor(act_Cells, spikeCounts, pred_err, z_ij);
        % move the mouse 
        [rat_position,momentum] = move_rat(rat_position,direction,momentum,map);
        
        % check for reward
        if platform(rat_position)
            Reward = 1;
        end
        
        % [C-value fuction, prediction error, change in weights]
        [C,pred_err,dw]= Critic(spikeCounts,w_critic,Reward,Cprev);
        Cprev=C;
        
        % Update Weights
        z_ij = z_ij + eta_a*z_ij_dx'; % actor
        w_critic= w_critic + eta_c*dw;  % critic
    end
end
end