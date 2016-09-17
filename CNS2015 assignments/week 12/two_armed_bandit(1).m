%%% Computational Neuroscience 2013 -
%%% Bayesian solution to the two-armed bandit problem using dynamic programming

% Marije ter Wal - 2013


clear all; close all; clc

%% Calculate V* fo all states (backward)

% Initialization:
h       = 3;
Vstar   = zeros(h+2,h+2,h+2,h+2); % t values run between 0 and h. We need 
                                  % h+1 = 0 for the calculations at t = 3. 
                                  % Furthermore, Matlab uses indices
                                  % 1,2,... in stead of 0,1,..., hence the
                                  % h+2 in the allocation of memory of V*

for t = h:-1:0 % Time
    fprintf('\nTime = %i\n', t)
    for n1 = 0:t % Arms
        n2 = t - n1; % The number of times arm 2 is chosen is equal to the 
                     % number of times any arm (t) was chosen minus
                     % the number of times arm 1 was chosen (n1)
        for w1 = 0:n1 % winnings after choosing 1
            for w2 = 0:n2 % winnings after choosing 2
                p1 = (w1+1) / (n1+2); % posterior for choosing 1
                p2 = (w2+1) / (n2+2); % posterior for choosing 2
                Vstar(n1+1,w1+1,n2+1,w2+1) = ... % I add 1 to all of variables for saving purposes: indices in Matlab run from 1, not from 0
                    max(    p1 + p1*Vstar(n1+2,w1+2,n2+1,w2+1) + (1-p1)*Vstar(n1+2,w1+1,n2+1,w2+1), ...
                            p2 + p2*Vstar(n1+1,w1+1,n2+2,w2+2) + (1-p2)*Vstar(n1+1,w1+1,n2+2,w2+1));
                % print!
                fprintf('V*(%i, %i, %i, %i) = %.2f \n', ...
                    n1, w1, n2, w2, Vstar(n1+1,w1+1,n2+1,w2+1))
            end
        end
    end
end

%% Compute choice sequence (forward)

Pwin    = [0.2, 0.9]; % payout strategy of the machines

% Initialization
p1      = 0.5; % flat prior
p2      = 0.5;
n1    = 0; 
n2    = 0;
w1     = 0;
w2     = 0;
R       = 'no'; % just for printing
Seq     = zeros(h+1,1); % allocation for choice sequence

for t = 0:1:h % Time
    R1 = p1 + p1*Vstar(n1+2, w1+2, n2+1, w2+1) + (1-p1)*Vstar(n1+2, w1+1, n2+1, w2+1);
    R2 = p2 + p2*Vstar(n1+1, w1+1, n2+2, w2+2) + (1-p2)*Vstar(n1+1, w1+1, n2+2, w2+1);
    [~, I] = sort([R1, R2], 'descend'); % which arm has the higher expected future reward?
    Seq(t+1) = I(1);
    
    % update Arm, win or lose?
    if Seq(t+1) == 1
        n1 = n1 +1;
        if rand(1) < Pwin(1); 
            w1 = w1 +1; 
            R = 'a';
        end
    else
        n2 = n2 +1; %if you don't choose arm one, you choose two
        if rand(1) < Pwin(2); 
            w2 = w2 +1; 
            R = 'a';
        end
    end   

    % print outcome
    fprintf(['\nAt time = %i, arm %i was pulled and ',R,' reward was received.'], t, Seq(t+1))
    
    p1 = (w1 + 1)/(n1 + 2); % update believe about the machines
    p2 = (w2 + 1)/(n2 + 2);
    R = 'no';
end

fprintf('\nTotal reward: %i\n', w1+w2)