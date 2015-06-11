clear all; clc; imtool close all;

% scaling factor to resize images to specified size
rowSize = 300;

%% Read image and extract LST bands
img = imread('pix/50.jpg');
img = imresize(img, rowSize/size(img,1));
imtool(img);

R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));

normalize = @(A) ( A - min(A(:)) ) ./ ( max(A(:)) - min(A(:)) );

L = normalize(R + G + B);
S = normalize(R - B);
T = normalize(R - 2*G + B);

%% Extract edges of red/blue regions
red_mask0 = S > 0.70 & L > 0.20 & T > 0.55;
blu_mask0 = S < 0.40 & L > 0.20;
red_mask1 = clean_mask_hough(red_mask0);
blu_mask1 = clean_mask_hough(blu_mask0);
red_mask2 = imclose(red_mask1, strel('disk',3));
blu_mask2 = imclose(blu_mask1, strel('disk',3));

E_red2 = edge(red_mask2, 'canny');
E_blu2 = edge(blu_mask2, 'canny');

figure(1);
subplot(2,2,1); imshow(E_red2);
subplot(2,2,2); imshow(E_blu2);

%% Find parallel lines and draw them onto image
[lines_red, paral_red, R1R2T_paral_red] = drawParallelLines(E_red2, [0 255 0]);
[lines_blu, paral_blu, R1R2T_paral_blu] = drawParallelLines(E_blu2, [255 255 0]);

% Draw lines onto original image
img_lines = img + uint8(lines_red + lines_blu);
img_paral = img + uint8(paral_red + paral_blu);

%% Find centroids of red/blue regions between parallel lines
centroids_red = [];

for a = 1:size(R1R2T_paral_red,1)
    R1 = R1R2T_paral_red(a,1);
    R2 = R1R2T_paral_red(a,2);
    T = R1R2T_paral_red(a,3);
    [r, c] = find(red_mask2 == 1);
    
    % Avg row/col of pixels in mask that are within the parallel lines
    rbar = round(mean(r( c*cosd(T) + r*sind(T) > min([R1 R2]) & ...
                         c*cosd(T) + r*sind(T) < max([R1 R2]) )));
    cbar = round(mean(c( c*cosd(T) + r*sind(T) > min([R1 R2]) & ...
                         c*cosd(T) + r*sind(T) < max([R1 R2]) )));
    centroids_red = [centroids_red; rbar cbar];
    
    % draw a cross at centroid on the image with parallel lines
    img_paral(rbar-5:rbar+5, cbar, 1) = 0;
    img_paral(rbar-5:rbar+5, cbar, 2) = 255;
    img_paral(rbar-5:rbar+5, cbar, 3) = 0;
    img_paral(rbar, cbar-5:cbar+5, 1) = 0;
    img_paral(rbar, cbar-5:cbar+5, 2) = 255;
    img_paral(rbar, cbar-5:cbar+5, 3) = 0;
end

centroids_blu = [];

for a = 1:size(R1R2T_paral_blu,1)
    R1 = R1R2T_paral_blu(a,1);
    R2 = R1R2T_paral_blu(a,2);
    T = R1R2T_paral_blu(a,3);
    [r, c] = find(blu_mask2 == 1);
    
    % Avg row/col of pixels in mask that are within the parallel lines
    rbar = round(mean(r( c*cosd(T) + r*sind(T) > min([R1 R2]) & ...
                         c*cosd(T) + r*sind(T) < max([R1 R2]) )));
    cbar = round(mean(c( c*cosd(T) + r*sind(T) > min([R1 R2]) & ...
                         c*cosd(T) + r*sind(T) < max([R1 R2]) )));
    centroids_blu = [centroids_blu; rbar cbar];
    
    % draw a cross at centroid on the image with parallel lines
    img_paral(rbar-5:rbar+5, cbar, 1) = 255;
    img_paral(rbar-5:rbar+5, cbar, 2) = 255;
    img_paral(rbar-5:rbar+5, cbar, 3) = 0;
    img_paral(rbar, cbar-5:cbar+5, 1) = 255;
    img_paral(rbar, cbar-5:cbar+5, 2) = 255;
    img_paral(rbar, cbar-5:cbar+5, 3) = 0;
end

subplot(2,2,3); imshow(img_lines);
subplot(2,2,4); imshow(img_paral);



