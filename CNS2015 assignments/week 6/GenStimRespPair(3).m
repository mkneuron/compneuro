function [x,y]=GenStimRespPair(Px_y,Ns)

%Px_y: response conditional on stim

if length(Ns)==1, Ns=Ns*ones(size(Px_y,2),1); end
if length(Ns)~=size(Px_y,2), error('Inconsistent num of stims'); end

CPx_y=cumsum([zeros(1,size(Px_y,2)); Px_y],1);
CNs=cumsum([0 Ns(:)']);
nrep=size(Px_y,1);
for i=1:length(Ns)
    N=Ns(i);
    r=rand(N,1);
    dum=zeros(N,1);
    for j=1:nrep
        ii=find(r>=CPx_y(j,i) & r<CPx_y(j+1,i));
        dum(ii)=j;
    end
    y(CNs(i)+1:CNs(i+1))=i; %the stimulus
    x(CNs(i)+1:CNs(i+1))=dum; %the stimulus    
end

return