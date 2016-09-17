function [MI Sx Sy Sxy]=GenEntrop(pxy)
px=sum(pxy,2);
py=sum(pxy,1);
ii=find(px>0); dum=px(ii); Sx=-sum(dum.*log2(dum));
ii=find(py>0); dum=py(ii); Sy=-sum(dum.*log2(dum));
dum=pxy(:); ii=find(dum>0); dum=dum(ii);
Sxy=-sum(dum.*log2(dum));
MI=Sx+Sy-Sxy;
return