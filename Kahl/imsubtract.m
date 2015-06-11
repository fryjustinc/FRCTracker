clear all; clc;

% Define normalization function
normalize = @(A) ( A - min(A(:)) ) ./ ( max(A(:)) - min(A(:)) );

%% Extract images from folder
foldername = 'QF2-1_5160-5240';
fileList = dir('QF2-1_5160-5240');

% Build array of Image objects
Images = Image.empty;
% files 1 and 2 are . (current dir) and .. (parent dir), respectively, 
% so we start with 3
for a = 3:size(fileList, 1)
    Images = [Images; Image(imread(['QF2-1_5160-5240'  '/'  fileList(a).name]))];
end

%% Run motion detection algorithm
w = 2; % Subtraction Width
centroids = [];
for f = (1 + w):(numel(Images) - w) % frame number

    % Subtract L band of images
    subbed_L = normalize(abs(Images(f + w).L - Images(f - w).L));
    
    % Theshold the normalized subtraction
    mask = subbed_L > 0.15;

    % Close with disk element of radius 2
    closed_mask = imclose(mask, strel('disk', 2));

    % Clean mask by removing small regions
    cleaned_mask = clean_mask_imsubtract(closed_mask);

    % Close with disk element of raduis 10
    connected_mask = imclose(cleaned_mask, strel('disk', 10));

    % Get bounding box and boxed image
    [r1, c1, r2, c2, boxed_Image] = bounding_box(connected_mask, Images(f));
    
    % Save centroid locations of bounding box with associated frame number
    for a = 1:numel(r1)
        centroids = [centroids; (r1(a)+r2(a))/2  (c1(a)+c2(a))/2  f];
    end
    
    % Save boxed image
    imwrite(boxed_Image.img, ['boxed/' , int2str(f), '.png']);
    
end

% Save centroid location file
save('centroids.mat', 'centroids');