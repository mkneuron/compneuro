%Problem 2, set 6

%3d array
p3r_s(:,:,1)=[4/18 3/18 1/18;
    3/18 4/18 1/18 ;
    1/18 0 1/18];

p3r_s(:,:,2)=[1/18 7/144 1/144;
    1/18 4/18 3/18 ;
    1/18 3/18 4/18];

ps=[1/2 1/2]';
%2d version
nn=size(p3r_s);
p2r_s=reshape(p3r_s,[nn(1)*nn(2) nn(3)]);

%independent version
dum1=repmat(sum(p3r_s,2),[1 nn(2) 1]);
dum2=repmat(sum(p3r_s,1),[nn(1) 1 1]);
p3r_s_i=dum1.*dum2;
p2r_s_i=reshape(p3r_s_i,[nn(1)*nn(2) nn(3)]);


%check normalization
sum(p2r_s,1)
sum(p2r_s_i,1)

%make it a joint distribution
p2rs=p2r_s*diag(ps);
p2rs_i=p2r_s_i*diag(ps);

%analytical entropies
[MIa Sxa Sya Sxya]=GenEntrop(p2rs); Hxya=Sxya-Sya;
[MIa_i Sxa_i Sya_i Sxya_i]=GenEntrop(p2rs_i); Hxya_i=Sxya_i-Sya_i;

%Do some sampling
Ntrial=1000;
ninn=10;
Nsar=round(logspace(1,3,ninn));
Hxye=zeros(ninn,1);
Hxye_std=zeros(ninn,1);

for inn=1:length(Nsar)
Ns=Nsar(inn);
clear ha;
disp(sprintf('N=%4d',Ns));
tic
for i=1:Ntrial
 [x,y]=GenStimRespPair(p2r_s,Ns);
 ha(i)=GenPxyestDuo(x,y,nn);
end
toc

Hxye(inn)=mean([ha(:).Hxy]);
Hxye_std(inn)=std([ha(:).Hxy],[]);
Hxye_s(inn)=mean([ha(:).Hxy_s]);
Hxye_s_std(inn)=std([ha(:).Hxy_s],[]);
Hxye_i(inn)=mean([ha(:).Hxy_i]);
Hxye_i_std(inn)=std([ha(:).Hxy_i],[]);


end

icho=1;
disp(sprintf('Hxya %6.4f Hxye %6.4f bias %6.5f',Hxya,Hxye(icho),Hxye(icho)-Hxya));
disp(sprintf('Hxya_i %6.4f Hxye_s %6.4f bias %6.5f',Hxya_i,Hxye_s(icho),Hxye_s(icho)-Hxya_i));
disp(sprintf('Hxya_i %6.4f Hxye_i %6.4f bias %6.5f',Hxya_i,Hxye_i(icho),Hxye_i(icho)-Hxya_i));
 
%  
%   [x,y]=GenStimRespPair(p2r_s,10000);
%   hb=GenPxyestDuo(x,y,nn);
%


figure(1); clf;
clear hp
hp.LineWidth=2;
hp.FontSize=14;
hh=errorbar(log10(Nsar),Hxye,Hxye_std);
hold on; 
plot(log10(Nsar),Hxye'-Hxye_s+Hxye_i,'r','LineWidth',2);
plot(log10(Nsar),Hxya*ones(size(Nsar)),'g','LineWidth',2);
set(gca,hp);
%set(gca,'Xscale','log');
xlim([log10(Nsar(1)),log10(Nsar(end))]); 
set(hh,'LineWidth',2);
legend('Sampled','Corrected','Exact');
xlabel('log10(N)');
ylabel('HXY');

% whatrun=1;
% if 0
%     for i=1:1
%     figure(i);
%     eval(sprintf('print -djpeg95 FIGURES/PanzeriExample%d_%d',whatrun,i));
%     eval(sprintf('print -depsc FIGURES/PanzeriExample%d_%d',whatrun,i));
%     end
%  end
