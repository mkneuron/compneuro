function [C,dt,dw]= Critic(spikeCounts,w_critic,Reward,Cprev)

%% Output:
% C : The critic's take of the value function
% dt: Prediction Error
% dw: change in weights
%% Input:
% spikeCounts: accessible with placeCells_spikeRate()
% w_critic   : the weights of the critic
% Reward     : reward
% Cprev      : The C that is output by the critic in t-1, see below
% The value function is calculated with C_t+1, but since we can't
% predict the future we make everyhting go a step back in time.
%% General theory:
% A value function represents the value that is assigned to a position. 
% The Critic's job is to learn the value of each position as defined by
% the reward. In this instance, the reward is when the rat finds the 
% platform and climbs on it to rest. The place cells that are active at
% that moment receive a reward proportional to their activity. 
% C is the Critic's interpretation of the value function.

%% Function:

if nargin < 3
    Reward = 0;
end

w  = w_critic;
fi = spikeCounts;
R  = Reward;
g  = 0.9975;     % discount factor gamma for calculating expected reward
C  = w'*fi/max([max(fi) max(w)]);       

% implement dt = R -gamma*C_t+1 + C
% as said in the end of the input section, we shift everything a timepoint
% to the past so that we won't have to predict the future. 

dt = R - g*C + Cprev;     % prediction error
dw = dt*fi;               % change in weights
