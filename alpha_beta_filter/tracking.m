clear all; close all; clc;

% Track the point that we are extracting from the center of the robot
framerate = 30; % fps of video
N = 81;  % number of frames extracted/to extract

dt = 1/framerate;
T = dt:dt:N*dt;

% Initial guess for alpha and beta
alpha = 0.9;
beta = 0.01;

% Load in the centroids data
load('centroids.mat');

% Initialize
xk = [1 0]';            % initial state (position)
vk = [0 0]';            % initial dState/dt (velocity)
XR = zeros(length(T),2); XM = zeros(length(T),2); XK = zeros(length(T),2);
VK = zeros(length(T),2); RK = zeros(length(T),2);
XM(2,:) = [0,0]';
for i = 3:size(T,2)-2
    current = centroids(floor(find(centroids == i)/3),:);
    
    %     for j = 1:size(current,1)
    blah = min(current(1,:) - XM(i-1,1) + current(2,:) + XM(i-1,2));
    xm = [current(1,1) current(2,1)]';
    XM(i,:) = xm;
    
    [xkp,vkp,rk] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta);
    xk = xkp;
    vk = vkp;
    XK(i,:) = xkp; VK(i,:) = vkp; RK(i,:) = rk;
    %     end
end

figure('units','pixels','Position',[0 0 1024 768]);
subplot(2,1,1);
plot(T,XM(:,1),T,XK(:,1),T,VK(:,1));
xlabel('Time (s)'); title('X Pos, Vel and Acc');
legend('Measured','Estimated','Velocity');
subplot(2,1,2);
plot(T,XM(:,2),T,XK(:,2),T,VK(:,2));
xlabel('Time (s)'); title('Y Pos, Vel and Acc');
legend('Measured','Estimated','Velocity');
