%Look at the discrete version of Fisher information 
%The calculation in Abbott is only good for very dense
%distribution of preferred phases compared to sigma
%then increasing sigma will increase information


%optimal sigma value

clear all

Nsig=31; %the number of sigma values to try
Nph=101; % # orientations
NAr=[10 20 30 100]; % # neurons

FIM=zeros(Nsig,length(NAr));
FIME=zeros(Nsig,length(NAr));

for ic=1:length(NAr) % loop over number of neurons
N=NAr(ic);
%sigma values tried
sigo=2*pi/N;
sigar=logspace(log10(0.1*sigo),log10(10*sigo),Nsig);

%pref. orientations
thar=linspace(0,2*pi,N+1); thar(end)=[];

%number of phases to try
ths=linspace(0,2*pi,Nph+1); ths(end)=[];


dth=repmat(reshape(ths,[Nph 1]),[1 N])-repmat(reshape(thar,[1 N]),[Nph 1]);
dth=mod(dth+pi,2*pi)-pi; 
dth=dth.^2;


FI=zeros(Nph,Nsig);
for j=1:Nsig % loop over sigma
    sig2=sigar(j)^2;
    FI(:,j)=sum(dth.*exp(-dth/sig2/2)/sig2^2,2);
    rate(:,j) = sum(exp(-dth/sig2),2);
end


FIM(:,ic)=min(FI,[],1);
FIME(:,ic)=median(FI,1);
FIMA(:,ic)=mean(FI,1);

rateMA(:,ic)=mean(rate,1);

end

figure(1); clf;
subplot(1,3,1); loglog(sigar,FIM); title('Minimum'); xlabel('\sigma'); ylabel('Fisher info');
subplot(1,3,2); loglog(sigar,FIME);title('Median'); xlabel('\sigma');
subplot(1,3,3); loglog(sigar,FIMA);title('Mean'); xlabel('\sigma');

legend({'N = 10', 'N = 20', 'N = 30', 'N = 100'},'Location', 'SouthWest');
legend boxoff

figure;
loglog(sigar, rateMA)
xlabel('\sigma'); ylabel('Mean firing rate')