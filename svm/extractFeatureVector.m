function [ featureVector ] = extractFeatureVector( img )
%extractFeatureVector Extracts 294-dimension feature vector from a given image.

dimg = double(img);
r = dimg(:,:,1);
g = dimg(:,:,2);
b = dimg(:,:,3);
l = r + g + b;
s = r - b;
t = r - 2*g + b;
blockSize = 7;

xBlockSize = floor(size(img, 2) / blockSize);
yBlockSize = floor(size(img, 1) / blockSize);

featureVector = [];
for i = 1:yBlockSize:yBlockSize*blockSize %size(img, 1)
    if i + yBlockSize > size(img, 1) + 1
        break
    end
    
    for j = 1:xBlockSize:xBlockSize*blockSize %size(img, 2)
        if j + xBlockSize > size(img, 2) + 1
            break
        end
        
        lBlock = [];
        sBlock = [];
        tBlock = [];
        for k = 0:xBlockSize - 1
            row = j + k;
            colLimit = i + yBlockSize - 1;
            lBlock = [lBlock; l(i:colLimit, row)];
            sBlock = [sBlock; s(i:colLimit, row)];
            tBlock = [tBlock; t(i:colLimit, row)];
        end
    
        featureVector = [featureVector ...
            mean2(lBlock) std2(lBlock) ...
            mean2(sBlock) std2(sBlock) ...
            mean2(tBlock) std2(tBlock)];
    end
end
end

