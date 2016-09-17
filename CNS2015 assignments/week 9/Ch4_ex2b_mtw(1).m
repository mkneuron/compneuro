clear all;

weights = 0:0.1:2;

for j = 1:length(weights)
    w = weights(j);

    % numerical
mfun = @(m) tanh(w*tanh(w*m + w) + w) - m;
m(j) = fsolve(mfun, 1);

% exact
fex = @(wex) (-exp(-wex)+exp(3*wex))/(3*exp(-wex) + exp(3*wex));
mex(j) = fex(w);


% figure; hold on;
% fplot(@(m) tanh(w*tanh(w*m + w) + w), [-2,2]);
% fplot(@(mi) mi, [-2,2]);
% plot(m, m, 'ob')
% plot(mex, mex, 'or');

end

figure; hold on
plot(weights, m, 'b')
plot(weights, mex, 'r');
xlabel('weights')
ylabel('m_{i}');
legend({'Numerical', 'Exact'},'Location', 'SouthEast');
legend boxoff