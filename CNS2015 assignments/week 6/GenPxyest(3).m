function [PExy,PEx_y,PEy]=GenPxyest(x,y,Nresp,Nstim)

%PEx_y=full(sparse(x,y,1,Nresp,Nstim));
PEy=accumarray([ones(size(y))' y'],1,[1 Nstim]);
dum=repmat(PEy,[Nresp 1])/length(x);
PExy=accumarray([x',y'],1,[Nresp Nstim])/length(x);
PEx_y=PExy./dum;

end