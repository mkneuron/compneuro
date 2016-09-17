% Compare Fisher estimates to actual variance determined by sampling

clear all;

nth=50; % # stimulus orientations
N=30; % # neurons
Nsample=1000;
tha=linspace(0,2*pi,N+1); tha(end)=[]; %preferred ori of the neurons

ths=pi/2+pi*rand(nth,1); %stimuli, away from boundaries
% ths=2*pi*rand(nth,1); %stimuli

sigma=0.4;
sig2=2*sigma^2;
mth=zeros(nth,1);
sth=zeros(nth,1);

for j=1:nth % loop over stimulus orientations
    thsm=ths(j);
    nexp=exp(-(thsm-tha).^2/sig2); % expected firing rates of all neurons
    
    th_est=zeros(Nsample,1);
    for i=1:Nsample
        re=poissrnd(nexp); % actual firing rates
        th_est(i)=sum(re.*tha)./sum(re); % estimated orientation per trial
    end
    mth(j)=nanmean(th_est); % > bias
    sth(j)=nanstd(th_est); % variability
    
    % fisher info
    IFest(j)=sum(((thsm-tha).^2).*exp(-(thsm-tha).^2/sig2)./sigma^4);
end

figure; clf;
[Sths, Id] = sort(ths);
subplot(1,3,1); plot(Sths, IFest(Id));
xlabel('Orientation (rad)')
ylabel('Fisher info')
xlim([0,2*pi]);
ylim([min(IFest)-5, max(IFest)+5]);

subplot(1,3,2); hold on
scatter(ths, mth, 40, 'filled');
plot([0,2*pi],[0,2*pi], 'k:'); ylim([0,2*pi]); xlim([0,2*pi]);
xlabel('Stimulus orientation'); ylabel('Average estimated orientation');

subplot(1,3,3); hold on
plot([sth, sqrt(1./IFest)']);
xlabel('Trial number'); ylabel('Variability of estimated orientation');
legend({'Estimate','sqrt(1 / I_{F})'})



