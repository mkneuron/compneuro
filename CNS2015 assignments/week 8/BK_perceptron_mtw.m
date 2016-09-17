%%% Solutions to the following exercises:

% ** Write a computer program that implements the perceptron learning rule.
% Take as data p random input vectors of dimension n with binary
% components. Take as outputs random assignments. Take n=50 and test
% emperically that when p < 2 n the rule converges almost always and for p
% > 2n the rule converges almost never.
% ** Reconstruct the curve C(p,n) as a
% function of p for n=50 in the following way. For each p construct a
% number of learning problems randomly and compute the fraction of these
% problems for which the perceptron learning rule converges. Plot this
% fraction versus p.


clear all; clc

%% perceptron - loop over number of patterns to be learned p


pSet    = 10:10:200;        % number of patterns
n       = 50;               % number of dimensions
eta     = 0.1;              % learning rate
nruns   = 20;               % number of repetitions
maxiter = 1000;             % safety net: stop if not converging

performance = nan(nruns, length(pSet),1);
convergence = nan(nruns, length(pSet),1);

for ip = 1:length(pSet)
    p = pSet(ip);
    fprintf('Presenting %i patterns\n', p);
    
    for sd = 1:nruns      
        rand('seed', 2*sd)          % repeat with different seeds
        
        % generate patterns
        xi  = randi(2,p,n+1)-1;		% inputs xi(:,1:n)=0,1 xi(:,n+1)=-1;
        xi(:,n+1) = -1;
        z   = 2*randi(2,p,1)-3;		% output z(:,1)=-1,1
        x   = xi.*(z*ones(1,n+1));
        
        % initialize
        w   = randn(1,n+1);			% weights w(1:n), threshold w(n+1)
        
        % run perceptron learning
        i   = 0;
        learning = 1;
        while ((learning) && (i<maxiter))
            i = i+1;
            learning = 0;
            for mu = 1:p,           % all patterns are presented in every trial
                if w*x(mu,:)' < 0,
                    w = w+eta*x(mu,:);
                    learning = 1;
                end;
            end;
        end;
        if (i == maxiter)
            fprintf('* Warning: Maximum iterations reached\n');
        end;
        
        % test performance
        convergence(sd,ip) = i;
        performance(sd,ip) = sum(sign((2*xi-1)*w') - z == 0)/p;
    end
end

%% plot results

figure
subplot(211); hold on
title('Convergence')
plot(pSet,nanmean(convergence,1), 'k')
plot([2*n, 2*n],[0,maxiter+1], 'k:')
ylim([0,maxiter+1])
xlabel('p')
ylabel('# iterations needed (max. 1000)')
subplot(212); hold on
title('Performance')
plot(pSet,nanmean(performance,1), 'k')
plot([2*n, 2*n],[0,1], 'k:')
ylim([0.5,1])
xlabel('p')
ylabel('% correct')
