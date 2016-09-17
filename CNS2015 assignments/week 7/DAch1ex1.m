%Parameter definition
T=10; % 10 sec
dt=0.001; % 1 msec
lambda=100; % 100 Hz
N=T/dt;

% compute 10 spike trains
y=zeros(10,N);
for j=1:10,
for i=1:N,	
	y(j,i)=(rand<lambda*dt);
end;
end;
spy(y)
axis square

% Coefficient of variation
y=y(1,:);
times=find(y);
isi(1)=times(1);
for i=2:length(times),
	isi(i)=times(i)-times(i-1);
end;
mean_isi=mean(isi);
std_isi=std(isi);
cv=mean_isi/std_isi

% Fano factor
n1=N/100; % n1 intervals of 100 msec
for i=1:n1,
	n(i)=sum(y((i-1)*n1+1:i*n1));
end;
mean_n=mean(n);
std_n=std(n);
fano=std_n^2/mean_n

% ISI Histogram
hist(isi,50)