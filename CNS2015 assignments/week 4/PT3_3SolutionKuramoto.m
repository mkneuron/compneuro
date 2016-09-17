clc
clear all

% We define the oscillation frequency relative to a mean
No=1000;    % number of oscillators
Nt=10000;   % number of time steps
dt=0.1;     % time resolution
sig_o=0.1;  % standard deviation
NK=30;      % the number of samples of K
Kar=logspace(log10(1E-2),log10(1),NK); % strength of coupling

% Derived quantities
omg=sig_o*randn(No,1);  % each oscillator has random frequency
dth=zeros(No,1);        % change of the phase
dtha=zeros(No,Nt);      % keep track change of the phase
rs=zeros(Nt,NK);        % keep track 'r'
iav=3*Nt/4:Nt;          % last 25% of time trace (for averaging phases)
tic
for j=1:NK
    th=2*pi*rand(No,1); % asynchronous initial conditions
    K=Kar(j);
    for i=1:Nt
        r=mean(exp(complex(0,th)));
        dth=dt*(omg-K*abs(r)*sin(th-angle(r))); % assume that the desired phase is 0.
        th=th+dth;
        dtha(:,i)=dth;  % to determine the locked oscillators (dth = 0)
        rs(i,j)=r;
    end
    dthb(:,j)=mean(abs(dtha(:,iav)),2); % find the mean absolute phase of the steady state of each oscillator
end
toc

dthc=sort(dthb,1);
thr=1E-3; % we need some fundamental theory for setting this as funct of No
dthd=sum(dthc<thr,1);

figure(1);clf;
subplot(1,3,1);plot(abs(rs));ylabel('r');xlabel('time steps');
subplot(1,3,2);plot(unwrap(angle(rs)));ylabel('\Theta');xlabel('time steps');
subplot(1,3,3);plot(dthc);ylabel('Phase');xlabel('Sorted oscillators'); title(' Steady state phases for different values of K')

figure(2); clf
subplot(1,2,1);plot(Kar,abs(rs(Nt,:)));ylabel('r at the last time step');xlabel('K');
subplot(1,2,2);plot(Kar,dthd);ylabel('The number of oscillators that have the desired phase (i.e. 0)');xlabel('K');

