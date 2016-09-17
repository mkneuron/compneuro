%Driver file -- problem 1, problem set 6

%The probabilities
pr_s=[2/3 5/18 1/18;
    5/18 2/3 1/18;
    1/36 1/36 4/9;
    1/36 1/36 4/9];

%pr_s=[1 0 0; 0 1 0; 0 0 0.5; 0.0 0.0 0.5]; %test case, full MI

ps=[1/3 1/3 1/3]';

%Exact entropy
pxy=pr_s*diag(ps); 
[MIa Sxa Sya Sxya]=GenEntrop(pxy);
Sara=[MIa Sxa Sya Sxya]';

%Approx entropy
nn=10;
Nsar=round(logspace(1,4,nn)); % define sample sizes Ns
Sarm=zeros(4,nn);
VarS=zeros(4,nn);
Ntrial=1000;

for inn=1:length(Nsar)
tic 
disp(['Sample size: ' sprintf('%4d',Nsar(inn))])
    Ns=Nsar(inn)*ones(size(ps)); %number of samples
    Sar=zeros(4,Ntrial);
    PEar=zeros([size(pr_s) Ntrial]);
    for it=1:Ntrial %You can save the overhead of the three function call
        [x,y]=GenStimRespPair(pr_s,Ns);
        [PExy PEx_y PEy]=GenPxyest(x,y,size(pr_s,1),size(pr_s,2));
        [MIe Sxe Sye Sxye]=GenEntrop(PExy);
        PEar(:,:,it)=PEx_y;
        Sar(1:4,it)=[MIe Sxe Sye Sxye]';
    end
    Sarm(:,inn)=mean(Sar,2); 
    PEarm=mean(PEar,3);

    %biasS=Sarm-Sara;
    VarS(:,inn)=std(Sar,[],2);
toc
end

%Make some more figures, we need to extrapolate the entropy and then
%determine mutual information!
%%
hp.LineWidth=2;
hp.FontSize=14;
for icho=1:4
labar={'MI','S_{R}','S_{S}','S_{joint}'};
figure(icho); clf;
hh=errorbar(log10(Nsar),Sarm(icho,:),VarS(icho,:));
hold on; plot(log10(Nsar),Sara(icho)*ones(size(Nsar)),'g','LineWidth',2);
set(gca,hp);
%set(gca,'Xscale','log');
xlim([log10(Nsar(1)),log10(Nsar(end))]); 
%ylim([0.55 0.8]);
set(hh,'LineWidth',2);
legend('Sampled','Exact');
xlabel('log10(N)');
ylabel(labar{icho});
end
%%
for icho=1:4
figure(4+icho);clf;
%take some points and see how far extrapolation comes.
npt=10;
iir=1:5; %take the first 5 datapoints (so low number of samples) and extrapolate
xx=1./Nsar;
xfit=1./Nsar(iir);
yfit=Sarm(icho,iir);
P=polyfit(xfit,yfit,2); %quadratic -- the offset is the infinite N limit
ypred=polyval(P,xx);

plot(xx,Sarm(icho,:),'bo-',xx,ypred,'go-',xx,Sara(icho)*ones(size(xx)),'ro-',[xx(1),xx(end)], [P(3),P(3)], 'g:', 'LineWidth',2);
set(gca,hp); legend('sampled','extrapolated','exact', 'estimated');

xlabel('1/n samples');
ylabel(labar{icho});
if icho==1
MI_ex=P(3); %offset
coef_a=P(2);
coef_b=P(3);
end
end


disp(['Exact       : ' sprintf('%6.5f',MIa)]);
disp(['Extrapolated: ' sprintf('%6.5f',MI_ex)]);
disp([sprintf('Sampled (N = %.3f): ',Nsar(end)), sprintf('%6.5f',Sarm(1,end))]);
disp(['Bias at 30  : ' sprintf('%6.5f',Sarm(1,1)-MIa)]);
disp(['Var at 30   : ' sprintf('%6.5f',VarS(1,1))]);
