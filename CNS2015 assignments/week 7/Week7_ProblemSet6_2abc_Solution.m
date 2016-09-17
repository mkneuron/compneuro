clear all; close all; home; %figure

% Settings
a = 1; b = 1; % Size of feature space
nrepr = 50; % Number of neurons in representation space
nfeat = 1000; % Number of neurons in feature space
sigma0 = 3.0; % Width of neighborhood function
alpha0 = .01; % Update value for weight factor
niter = 200; % Number of iterations
sigma = sigma0;
alpha = alpha0;

REPR = [a*rand(1,nrepr); b*rand(1,nrepr)];
FEAT = [a*rand(1,nfeat); b*rand(1,nfeat)];

figure;
plot(FEAT(1,:),FEAT(2,:),'y.'); hold on
plot(REPR(1,:),REPR(2,:),'.-'); hold off
title(['Iteration ', num2str(0)]);
axis equal
xlim([0,1]); ylim([0,1])

for iiter = 1:niter
    
    % For all neurons in the feature space
    for ifeat = 1:nfeat
        
        % Distance in coordinates (x,y) between representation space and
        % selected neuron in feature space
        dist_xy = repmat(FEAT(:,ifeat),1,nrepr) - REPR;
        
        % Squared Euclidean distance
        dist2 = sum(dist_xy.^2);
        
        % Select neuron from representation space with the smallest
        % distance (r* in the exercise)
        [val irepr_min] = min(dist2);
        
        % Distance between neuron r* and other neurons in representation
        % space
        dist_repr = (1:nrepr) - irepr_min;
        
        % Update representation space
        update = alpha*exp(-dist_repr.^2/(2*sigma^2));  %non-Euclidean distance calculated here!
        REPR = REPR + [1;1]*update.*dist_xy;
    end

     plot(FEAT(1,:),FEAT(2,:),'y.'); hold on
     plot(REPR(1,:),REPR(2,:),'.-'); hold off
     title(['Iteration ', num2str(iiter)]);
     axis equal
     xlim([0,a]); ylim([0,b]);
     drawnow
end
