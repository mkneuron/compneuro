function ha=GenPxyestDuo(x,y,nn)

N=length(x);
%First analyze it 2D 
PEy=accumarray([ones(size(y))' y'],1,[1 nn(3)])/N;
dum=repmat(PEy,[nn(1)*nn(2) 1]);
dum2=reshape(dum,nn);

P2Exy=accumarray([x',y'],1,[nn(1)*nn(2) nn(3)])/N;
P2Ex_y=P2Exy./dum;

%Go to 3D and shuffle and then turn back to 2D

%Full shuffle - shuffle r1 while keeping r2 and s
[x1 x2]=ind2sub(nn(1:2),x);
x1s=x1(randperm(N));
xshuf=sub2ind(nn(1:2),x1s,x2);


%Conditional shuffle - shuffle r1 for same s
[ys indx]=sort(y);

cii=[0 find(diff(ys)>0) length(ys)];
x1s2=zeros(size(ys));
nii=diff(cii);
for i=1:length(nii) % loop over number of samples per stimulus
    range=cii(i)+1:cii(i+1);
    x1s2(indx(range))=x1(indx(randperm(length(range))));
end
xshufcond=sub2ind(nn(1:2),x1s2,x2);    
P2Exy_s=accumarray([xshufcond',y'],1,[nn(1)*nn(2) nn(3)])/N;
P2Ex_y_s=P2Exy_s./dum;

%write the distribution as a product of marginals, but still stimulus
%conditioned
dum1_i=repmat(accumarray([x1',ones(size(x2))', y'],1,[nn(1) 1 nn(3)])/N,[1 nn(2) 1])./dum2;
dum2_i=repmat(accumarray([ones(size(x1))', x2',y'],1,[1 nn(2) nn(3)])/N,[nn(1) 1 1])./dum2;
P2Exy_i=reshape(dum1_i.*dum2_i,[nn(1)*nn(2) nn(3)]).*dum;
P2Ex_y_i=P2Exy_i./dum;

%We would need to do the same for the H(R) by itself
P2Ex=accumarray([ones(size(x))' x'],1,[1 nn(1)*nn(2)])/N;
P2Ex_s=accumarray([ones(size(xshuf))' xshuf'],1,[1 nn(1)*nn(2)])/N;
dum1_i=repmat(accumarray([ x1' ones(size(x1))'],1,[nn(1) 1 ])/N,[1 nn(2)]);
dum2_i=repmat(accumarray([ones(size(x1))' x2'],1,[1 nn(2) ])/N,[nn(1) 1]);
P2Ex_i=reshape(dum1_i.*dum2_i,[1 nn(1)*nn(2)]);

ha.PEy=PEy;
ha.P2Exy=P2Exy;
ha.P2Ex_y=P2Ex_y;
ha.P2Exy_s=P2Exy_s; % shuffled
ha.P2Ex_y_s=P2Ex_y_s;
ha.P2Exy_i=P2Exy_i; % independent
ha.P2Ex_y_i=P2Ex_y_i;

%Let's do the calculation directly in here

dum=P2Exy(:); ii=find(dum>0); dum=dum(ii); Sxy=-sum(dum.*log2(dum)); 
dum=P2Exy_s(:); ii=find(dum>0); dum=dum(ii); Sxy_s=-sum(dum.*log2(dum)); 
dum=P2Exy_i(:); ii=find(dum>0); dum=dum(ii); Sxy_i=-sum(dum.*log2(dum)); 
ha.Sxy=Sxy;
ha.Sxy_s=Sxy_s;
ha.Sxy_i=Sxy_i;

%We should do the noise entropy, a bit more involved, b/c it is summed
%across the stimuli
Hxy=0;Hxy_s=0;Hxy_i=0;

for i=1:nn(3)
dum=P2Ex_y(:,i); ii=find(dum>0); dum=dum(ii); Hxy=Hxy-PEy(i)*sum(dum.*log2(dum));     
dum=P2Ex_y_s(:,i); ii=find(dum>0); dum=dum(ii); Hxy_s=Hxy_s-PEy(i)*sum(dum.*log2(dum));     
dum=P2Ex_y_i(:,i); ii=find(dum>0); dum=dum(ii); Hxy_i=Hxy_i-PEy(i)*sum(dum.*log2(dum));     

ha.Hxy=Hxy;
ha.Hxy_s=Hxy_s;
ha.Hxy_i=Hxy_i;

end

dum=P2Ex(:); ii=find(dum>0); dum=dum(ii); Sx=-sum(dum.*log2(dum));
dum=P2Ex_s(:); ii=find(dum>0); dum=dum(ii); Sx_s=-sum(dum.*log2(dum)); 
dum=P2Ex_i(:); ii=find(dum>0); dum=dum(ii); Sx_i=-sum(dum.*log2(dum)); 

ha.Sx=Sxy;
ha.Sx_s=Sx_s;
ha.Sx_i=Sx_i;


ha.MI=Sx+(Sx_i-Sx_s)-(Hxy+(Hxy_i-Hxy_s));

end