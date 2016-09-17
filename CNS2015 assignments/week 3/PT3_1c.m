clc
clear all

C=100;
vr=-60;
vt=-40;
k=0.7;
a=0.03;
b=-2;
c=-50;
d=100;
vpeak=35;
tausyn=2;

Nn=100;     % The number of neurons
dt=0.2;     % Step size
Nt=20000;   % The number of dt. Then, the maximum simulation time is Nt*dt.

w=0.5;     % Weight of the connections. We assume that all connections have the same weights.
I=52;       % External current to the neurons.

%% Initial conditions
rand('seed',0);
v=(vpeak-c).*rand(Nn,1)+c;  % Randomly initialize v between [c,vpeak]
u=0*v;                      % The 'conductance' u is always 0.
tt=dt*(0:Nt-1);

spikind=[];
spikt=[];
ConnMat=w*(ones(Nn)-diag(ones(Nn,1))); % no self coupling
Icon=zeros(Nn,1);
dexp=exp(-dt/tausyn);

for i=1:Nt
        v=v+dt*(k*(v-vr).*(v-vt)-u+I+ConnMat*Icon)/C;
        u=v+dt*a*(b*(v-vr)-u);
        Icon=Icon*dexp;     % Effects of input exponentially decay.
        ii=find(v>=vpeak);
        if ~isempty(ii)
            v(ii)=c;
            u(ii)=u(ii)+d;
            spikt=[spikt dt*i*ones(1,length(ii))];
            spikind=[spikind ii(:)'];
            Icon(ii)=Icon(ii)+1;
        end
end

figure(1);clf;
plot(spikt,spikind,'.');
xlim([0 4000]);
