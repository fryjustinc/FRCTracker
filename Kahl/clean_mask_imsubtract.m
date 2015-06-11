function [ cleaned ] = clean_mask_imsubtract( mask )
%CLEAN_MASK_IMSUBTRACT(mask) Cleans a mask based on region size
%   CLEAN_MASK_IMSUBTRACT cleans the input mask by removing smaller regions
%   both with a hard threshold and iteratively. This function is intended
%   to be used with imsubtract.m
%   
%   INPUTS:
%       mask - mask to be cleaned
%   OUTPUTS:
%       cleaned - cleaned mask

% Max number of pixels to be counted as a region
MIN_PIXEL_COUNT = 100;

cleaned = mask;
labeled_mask = bwlabel(mask);

% Remove regions too small
for a = 1:max(labeled_mask(:))
    [r,c] = find(labeled_mask == a);
    if numel(r) < MIN_PIXEL_COUNT;
        cleaned(r,c) = 0;
    end
end

% Remove regions less than half of mean size
converged = 0;
while converged == 0
    labeled_mask2 = bwlabel(cleaned);
    num_regions = max(labeled_mask2(:));
    mean_region_size = sum(cleaned(:))/num_regions;
    converged = 1;
    for a = 1:num_regions
        [r,c] = find(labeled_mask2 == a);
        if numel(r) < mean_region_size/2;
            cleaned(r,c) = 0;
            converged = 0;
        end
    end
end

end