dt = .01; T = 0:dt:10;   % simulation time vector
alpha = 0.9;            % initial guess of alpha
beta = 0.0001;           % initial guess of beta
xk = [1 0]';            % initial state (position)
vk = [0 0]';            % initial dState/dt (velocity)
XR = zeros(length(T),2); XM = zeros(length(T),2); XK = zeros(length(T),2);
VK = zeros(length(T),2); RK = zeros(length(T),2);
for t = 1:length(T)
    xm = [T(t)*10 T(t)^2]';  % true position (A circle)
    XR(t,:) = xm;

    xm(1) = xm(1) + .0 + .5 .* randn;       % error mean .0 and sd .5
    xm(2) = xm(2) + .1 + .3 .* randn;       % error mean .1 and sd .3
    XM(t,:) = xm;
    [xkp,vkp,rk] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta);
    xk = xkp;
    vk = vkp;
    XK(t,:) = xkp; VK(t,:) = vkp; RK(t,:) = rk;
end
figure('units','pixels','Position',[0 0 1024 768]);
subplot(2,1,1);
plot(T,XR(:,1),T,XM(:,1),T,XK(:,1),T,VK(:,1));
xlabel('Time (s)'); title('X Pos, Vel and Acc');
legend('Real','Measured','Estimated','Velocity');
subplot(2,1,2);
plot(T,XR(:,2),T,XM(:,2),T,XK(:,2),T,VK(:,2));
xlabel('Time (s)'); title('Y Pos, Vel and Acc');
legend('Real','Measured','Estimated','Velocity');
