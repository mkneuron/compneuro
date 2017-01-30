function [updated_position, movement, trajectory] = move_rat(current_position, movement_direction_selected, map, previous_movement)
% INPUT VARIABLES
% "movement_direction_selected" is a 1xnumber_of_actor_cells
% (=1xnumber_of_possible_directions) vector, where the only element = 1 is
% the chosen direction.
% "current_position" is a 1x2 array, with the row and column of the position
% matrix.
% "previous_movement" is a 1x2 array, where the 1st element is the movement in the x
% direction and the 2nd element the movement in the y direction: both
% elements can have value of -1, 0, +1, depending on the direction on that
% axis.
% OUTPUT VARIABLES
% "movement" is a 1x2 array, where the 1st element is the movement in the x
% direction and the 2nd element the movement in the y direction: both
% elements can have value of -1, 0, +1, depending on the direction on that
% axis.
momentum_memory = 3;

%% Defining movement direction.
movement_tmp = find(movement_direction_selected);
if isempty(movement_tmp)
    fprintf('Lazy rat did not move.\n');
end
if ~isscalar(movement_tmp)
    fprintf('Dumb rat (Actor) chose 2 movement directions!\n')
end

% goddamn it Niccolo
switch movement_tmp
    case 1  % S
        movement(1, 1) =  0; movement(1, 2) = -1;
    case 2  % SE
        movement(1, 1) =  1; movement(1, 2) = -1;
    case 3  % E
        movement(1, 1) =  1; movement(1, 2) =  0;
    case 4  % NE
        movement(1, 1) =  1; movement(1, 2) =  1;
    case 5  % N
        movement(1, 1) =  0; movement(1, 2) =  1;
    case 6  % NW
        movement(1, 1) = -1; movement(1, 2) =  1;
    case 7  % W
        movement(1, 1) = -1; movement(1, 2) =  0;
    case 8  % SW
        movement(1, 1) = -1; movement(1, 2) = -1;
    otherwise
        movement(1, 1) =  0; movement(1, 2) =  0; % No movement
end

%% Move.
map_dimension = size(map,2);
current_position_x = current_position(1, 1);
current_position_y = current_position(1, 2);
trajectory = zeros(momentum_memory, 2);
% Move by momentum.
for i = 1:momentum_memory
    current_position_x = current_position_x + previous_movement(1, 1);
    if current_position_x >= map_dimension || current_position_x <= 0 % If it's outside the map matrix.
        previous_movement(1, 1) = - previous_movement(1, 1);
        current_position_x = current_position_x + previous_movement(1, 1); % Bounce back on that direction
    elseif map(current_position_x, current_position_y) == 0 % If it just went out of bondaries
        previous_movement(1, 1) = - previous_movement(1, 1);
        current_position_x = current_position_x + previous_movement(1, 1); % Bounce back on that direction
    end
    % Move y coordinate
        current_position_y = current_position_y + previous_movement(1, 2); 
    if current_position_y >= map_dimension || current_position_y <= 0 % If it's outside the map matrix.
        previous_movement(1, 2) = - previous_movement(1, 2);
        current_position_y = current_position_y + previous_movement(1, 2); % Bounce back on that direction
    elseif map(current_position_x, current_position_y) == 0 % If it just went out of the pool bondaries.
        previous_movement(1, 2) = - previous_movement(1, 2);
        current_position_y = current_position_y + previous_movement(1, 2); % Bounce back on that direction
    end
    trajectory(i,1) = current_position_x;
    trajectory(i,2) = current_position_y;
end

% Move by actor.

% Move x coordinate
current_position_x = current_position_x + movement(1, 1);
if current_position_x >= map_dimension || current_position_x <= 0 % If it's outside the map matrix.
    movement(1, 1) = - movement(1, 1);
    current_position_x = current_position_x + 2*movement(1, 1); % Bounce back on that direction
    %fprintf('Rat (Actor) wanted to go outside the swimming pool.\n');
elseif map(current_position_x, current_position_y) == 0 % If it just went out of bondaries
    movement(1, 1) = - movement(1, 1);
    current_position_x = current_position_x + 2*movement(1, 1); % Bounce back on that direction
    %fprintf('Rat (Actor) wanted to go outside the swimming pool.\n');
end

% Move y coordinate
current_position_y = current_position_y + movement(1, 2);
if current_position_y >= map_dimension || current_position_y <= 0 % If it's outside the map matrix.
    movement(1, 2) = - movement(1, 2);
    current_position_y = current_position_y + 2*movement(1, 2); % Bounce back on that direction
    %fprintf('Rat (Actor) wanted to go outside the swimming pool.\n');
elseif map(current_position_x, current_position_y) == 0 % If it just went out of the pool bondaries.
    movement(1, 2) = - movement(1, 2);
    current_position_y = current_position_y + 2*movement(1, 2); % Bounce back on that direction
    %fprintf('Rat (Actor) wanted to go outside the swimming pool.\n');
end
updated_position(1, 1) = current_position_x;
updated_position(1, 2) = current_position_y;
trajectory(4,1) = current_position_x;
trajectory(4,2) = current_position_y;
% 
% % Update momentum (movement)
% movement = (movement + previous_movement)./2;
% % These controls will prevent rounding bias.
% if abs(movement(1,1)) == 0.5
%     movement(1,1) = movement(1,1) + rand - 0.5;
% end
% if abs(movement(1,2)) == 0.5
%     movement(1,2) = movement(1,2) + rand - 0.5;
% end
% movement = double(int16(movement));

% updated_position(1, 1) = current_position_x + movement(1, 1);
% updated_position(1, 2) = current_position_y + movement(1, 2);
% % If it goes out of the matrix, roll back.
% if updated_position(1, 1) >= map_dimension || updated_position(1, 2) >= map_dimension ...
%         || updated_position(1, 1) <= 0 || updated_position(1, 2) <= 0
%     updated_position(1, 1) = current_position_x;
%     updated_position(1, 2) = current_position_y;
%     fprintf('Rat (Actor) wanted to go outside the swimming pool.\n');
% % If it goes out of the swimming pool, roll back.
% elseif map(updated_position(1, 1), updated_position(1, 2)) == 0
%     updated_position(1, 1) = current_position_x;
%     updated_position(1, 2) = current_position_y;
%     fprintf('Rat (Actor) wanted to go outside the swimming pool.\n');
% end
end
