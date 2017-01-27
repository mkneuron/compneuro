N = 4;  % number of place cells (593 normally)
overlap = 4;    % 4 squares overlap (max, no noise)
sigma = 16;     % standard deviation (1s --> 61% max firing rate)
nSTDs = 3;      % number of standard deviations we take into account
maxNoise = 3;      % number of squares the cell centers can deviate from perfect 

% environment dimensions
nCellsx = floor(sqrt(N));
nCellsy = floor(N/nCellsx);
lastRow = N - nCellsx * nCellsy;
if lastRow ~=0
    nCellsy = nCellsy + 1;
end

diameter = 2 * sigma; % diameter of a std

% calculate the dimensions of the matrix
sidePadding = (nSTDs-1)*diameter+maxNoise;
xLength = (nCellsx/2)*(2*diameter-overlap) + 2 * sidePadding;
yLength = (nCellsx/2)*(2*diameter-overlap) + 2 * sidePadding;

% create the matrix
noise = @() Ranint(6)-3;
env = zeros(xLength,yLength);
for i=1:nCellsx
    for j=1:nCellsy
        x = (sidePadding + sigma - overlap) * j + noise();
        y = (sidePadding + sigma - overlap) * i + noise();
        env(x,y) = 1;
    end
end

B = imgaussfilt(env,sigma);
imagesc(B);


%% completely random
N = 493;  % number of place cells (593 normally)
overlap = 4;    % 4 squares overlap (max, no noise)
sigma = 16;     % standard deviation (1s --> 61% max firing rate)
nSTDs = 3;      % number of standard deviations we take into account

x = 88+ 80 * 2;
y = 88 + 80 * 2;
diameter = 2 * sigma; % diameter of a std

env = zeros(x,y);
for i=1:493
    env(80+Ranint(88),80+Ranint(88)) = 1;
end

imagesc(env(88:168,88:168));

B1 = imgaussfilt(env,sigma);
imagesc(B1(88:168,88:168));

B2 = imgaussfilt(env(88:168,88:168),sigma);
imagesc(B2);


