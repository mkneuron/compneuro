function [direction, z_ij_dx] = actor(act_Cells, spikeCounts, pred_err,z_ij)
% INPUTS:
% "spikeCounts" is a vector containing the firing rate for every place cell.
% "z_ij" is the weight from the place cell i to the actor cell j.
% "pred_err" comes from the Critic, its the difference between
% seccessively occurring Critic outputs

n0_plaCells = numel(spikeCounts);

%% Compute probability of next movement.
% "actor_cell_activity" is the preference for the rat to move in the j
% direction when he is at location "current_position"

P_movement_direction = zeros(1, act_Cells);
actor_cell_activity= z_ij'*spikeCounts;

for j = 1:act_Cells
    P_movement_direction(j) = (exp(2*actor_cell_activity(j)))./...
                                 (sum(exp(2*actor_cell_activity)));
end
if sum(P_movement_direction) ~= 1
    warning('P_movement_direction is not normalized');
end

%% Decide action.
% Scroll the probabilities, if a random number is between a probability
% value p1 and p1 + the next one, then chose the corresponding action. 
random_selector = rand();
direction = zeros(1, act_Cells);
cumulative = cumsum(P_movement_direction); % cumulative probabilities of action

for j = 1:act_Cells
    if (random_selector <= cumulative(j))
        direction(1, j) = 1;
        break
    end
end
 
%% Update weights given the prediction error from the Critic.

z_ij_dx = zeros(act_Cells, n0_plaCells);
for i = 1:act_Cells
   z_ij_dx(i,:) = pred_err * z_ij(:,i) * direction(i);
end
% for i = 1:n0_plaCells
%     for j = 1:act_Cells
%         z_ij_dx(i, j) = pred_err.*z_ij(i,j).*direction(1, j);
%     end
% end
movement_tmp = find(direction);
if ~isscalar(movement_tmp)
    warning('Dumb rat (Actor) chose 2 movement directions!')
end
end
