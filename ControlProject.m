clc;
close all;
clear all;

% defining the parameters and constants

Ka=12;
L=0.006;
R=1.4;
Kb=0.00867;
n=200;
Km=4.375;
JL=1;
DL=0.5;
Jm=0.00844;
Dm=0.00013;
J=Jm+JL/n^2;
D=Dm+DL/n^2;


% define the laplce variable s
s = tf('s');

% define the armature and motor dynamics transfer function 
Garm_motor = Km/((L*s+R)*(J*s+D));

%define the Gears & integrator function
Ggears_integrator = 1/(n*s);

% open-loop transfer function
G = Ka*feedback(Garm_motor,Kb)*Ggears_integrator

% closed-loop transfer function   
T = feedback(G,1)

%==========================================================================
% determine the value of Kp for which the system is stable
for i=1:0.1:100
%Calculate the closed loop transfer function for various Kp = i
sys=feedback(G*i,1);
is_stable=isstable(sys); % checks the system is stable or not
if is_stable == 0 % if the system is not stable
Kp=i;
disp(['The overall system is stable for the controller gain Kp < ',num2str(Kp)])
break;
end
end
% OR
% Using root locus technique, on the open loop system
figure;
rlocus(G);

% The step response for four different values of Kp

% stable overdamped
Kp = [0.1 1 33.78 45];
figure;
step(feedback(G*Kp(1),1));grid on;
title('stable overdamped step response');xlim([0 10]);

% stable underdamped
figure;
step(feedback(G*Kp(2),1));grid on;
title('stable underdamped step response');xlim([0 10]);

% marginally stable
figure;
step(feedback(G*Kp(3),1));grid on;
title('marginally stable undamped step response');xlim([0 10]);

% Unstable
figure;
step(feedback(G*Kp(4),1));grid on;
title('unstable step response');xlim([0 10]);

%==========================================================================

% Kp is Given a stable value, Kp = 15
sys=feedback(G*15,1);
stepinfo(sys)