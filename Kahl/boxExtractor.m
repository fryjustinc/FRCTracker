clear all
clc

boxedDir = 'boxed';
fileList = dir(boxedDir);
% files 1 and 2 are . (current dir) and .. (parent dir), respectively, 
% so we start with 3.
for i = 3:size(fileList, 1)
    fileLoc = [boxedDir  '/'  fileList(i).name];
    [p, fileNum, e] = fileparts(fileList(i).name);
    img = imread(fileLoc);
    grayimg = rgb2gray(img);
    
    % get largest connected component (black background):
    cc = bwconncomp(grayimg);
    for j = 1:cc.NumObjects
        r = regionprops(cc, 'BoundingBox');
        bb = r(j).BoundingBox;
        bb = arrayfun(@(x) ceil(x), bb); % convert to integer
        y = bb(2); yf = bb(2)+bb(4)-1; x = bb(1); xf = bb(1)+bb(3)-1;
        newimg = repmat(0, bb(4), bb(3));
        newimg(:,:,1) = img(y:yf, x:xf, 1);
        newimg(:,:,2) = img(y:yf, x:xf, 2);
        newimg(:,:,3) = img(y:yf, x:xf, 3);
        
        imwrite(uint8(newimg), ['segmented/unsorted/' fileNum '.' int2str(j) '.png']);
    end       
end