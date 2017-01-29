function [map, cell_coord, platform_mask] = ...
         RL_env(Pcel, map_radius, platform_radius, p_std, restrict_place)
% Standard parameters used in the paper are:
% map_radius = 1m
% platform_radius = 0.05m
% rat_speed = 0.3ms^-1
% 1 pixel ~= 0.0075m
% -----------------------------------------
% => map_diameter ~ 266-277 pixels
% => platform_radius ~ 6-7 pixels
% => rat_movement = 4 pixels/iteration
% -----------------------------------------

fprintf('Experiment initialized.\n')

%% Setting default values.

if nargin < 5
    restrict_place = 1; % restrict place cells to stay inside the map
end
if nargin < 4
    p_std = 1; 
end
if nargin < 3
    platform_radius = 6;
end
if nargin < 2
    map_radius = 133;
end
if nargin < 1
    Pcel = 493;
end
    

%% Construct a pool in shape of a circle
map_diameter = 2*map_radius;
map = zeros(map_diameter);
for i=1:map_diameter
    for j=1:map_diameter
        % calculate polar coordinates
        if sqrt((i-map_radius-0.5)^2 + (j-map_radius-0.5)^2) < map_radius
            map(i,j) = 1;
        end
    end
end
fprintf('Map ready.\n')


%% Put place cells in map
fprintf('Place cells in position...\n')
cell_pos = zeros(map_diameter); % start with 0 cells
cell_count = Pcel;
while cell_count>0 % unplaced place cells
    
    % get random coordinates
    x = randi(map_diameter);
    y = randi(map_diameter);
    % check if position is in map and if it has a place cell
    if cell_pos(x,y) || (restrict_place && ~map(x,y))
        % code used to be here but the architecture changed. I'm too lazy
        % to change the logic though
    else
        cell_pos(x,y) = 1; % the position was empty, have a place cell.
        cell_count = cell_count-1;
    end
    
end

cell_coord = nan(2, Pcel);
[cell_coord(1,:), cell_coord(2,:)] = find(cell_pos);
fprintf('%d place cells in position.\n', size(cell_coord,2));


%% Create platform.
% Search a valid platform position.
FLAG_goal_position_found = 0;
while FLAG_goal_position_found ~= 4
    goal_platform_position = [randi([platform_radius, map_diameter - platform_radius]),...
                              randi([platform_radius, map_diameter - platform_radius])];
    FLAG_goal_position_found = 0;
    for x = -1:2:1
        for y = -1:2:1
            platform_extremity = ...
                [goal_platform_position(1,1) + x*uint16(platform_radius),...
                goal_platform_position(1,2) + y*uint16(platform_radius)];
            if map(platform_extremity(1,1), platform_extremity(1,2)) == 1
                FLAG_goal_position_found = FLAG_goal_position_found + 1;
            end
        end
    end
end
% Make platform mask.
[rr, cc] = meshgrid(1:map_diameter);
platform_mask = sqrt((rr-goal_platform_position(1,1)).^2 + ...
                     (cc-goal_platform_position(1,2)).^2 )<=platform_radius;


% % Put the platform in the map.
% for i=1:(platform_radius*2)
%     for j=1:(platform_radius*2)
%         if platform_mask(i,j) == 1
%             map(i,j) = 2;
%         end
%     end
% end
fprintf('Platform created in a random position.\n');

end
