clear all; close all; clc; imtool close all;

%% Intialization
% Colors for plotting
color = zeros(7, 3); color(1,:) = [0 1 0]; color(2,:) = [0 1 1];
color(3,:) = [0 0 0]; color(4,:) = [0 0 1]; color(5,:) = [1 1 0];
color(6,:) = [1 0 0]; color(7,:) = [1 0 1];

% Factors from video itself
framerate = 30; % fps of video
N = 81;  % number of frames extracted/to extract
dt = 1/framerate;
T = dt:dt:N*dt;

% Initial guess for alpha and beta
alpha = 0.9;
beta = 0.01;

% Load in the centroids data
load('centroids.mat');
times = centroids(:,3);
tracks = zeros(length(T), 2, 7);
predicted_tracks = zeros(length(T), 2, 7);

% Initialize
xk = [1 0]';            % initial state (position)
vk = [0 0]';            % initial dState/dt (velocity)
XR = zeros(length(T),2); XM = zeros(length(T),2); XK = zeros(length(T),2);
VK = zeros(length(T),2); RK = zeros(length(T),2);
XM(2,:) = [0,0]';

%% Tracking
for i = 3:size(T,2)-2
    current = centroids(times == i, :);
    for start = 1:2
        if i ~= 3
            [minDist, idx] = min(abs(current(:,1) - predicted_tracks(i-1,1,start)...
                + current(:,2) - predicted_tracks(i-1,2,start)));
        else
            minDist = 0;
            idx = start;
        end
        if abs(minDist) > 40
            xm = predicted_tracks(i-1,:,start)';
        else
            xm = [current(idx,1) current(idx,2)]';
        end
        tracks(i, :, start) = xm;
        XM(i,:) = xm;
        
        [xkp,vkp,rk] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta);
        xk = xkp;
        vk = vkp;
        XK(i,:) = xkp; VK(i,:) = vkp; RK(i,:) = rk;
        predicted_tracks(i, :, start) = xk;
    end
end

%% Plotting
% Plot the tracks
figure();
hold on;
for i = 1:size(tracks,3)
    plot(tracks(:,2,i), tracks(:,1,i),'Color', color(i,:), 'Marker', 'x', 'LineStyle', 'none');
end
legend('Track 1', 'Track2');
hold off;
axis([0 640 0 360]);

% Save the overlaid images
fileList = dir('QF2-1_5160-5240\');
for a = 6:size(fileList,1) - 2
    if a-2<10
        filename = ['QF2-1_5160-5240\' num2str(a-2) '.png'];
    else
        filename = ['QF2-1_5160-5240\' num2str(a-2) '.png'];
    end
    new_filename = ['filtered_imgs\' num2str(a-2) '.png'];
    img = imread(filename);
    new_img = zeros(size(img,1), size(img,2), size(img,3));
    for i = 1:2%size(tracks,3)
        x_mid = floor(tracks(a,2,i)); y_mid = floor(tracks(a,1,i));
        x = repmat(x_mid-5:x_mid+5, [1 5]);
        y = floor(y_mid-5:1/5:y_mid+5);
        if x_mid~=0 && y_mid~=0
            img(y(1,:),x(1,:),1) = color(i,1) * 255;
            img(y(1,:),x(1,:),2) = color(i,2) * 255;
            img(y(1,:),x(1,:),3) = color(i,3) * 255;
        end
    end
    imwrite(img, new_filename);
end

% Save the overlaid images and play them
video_maker('filtered.avi', 'filtered_imgs',3, size(T,2)-2);
implay('filtered.avi');
