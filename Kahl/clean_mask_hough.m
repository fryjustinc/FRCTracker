function [ cleaned ] = clean_mask_hough( mask )
%CLEAN_MASK_HOUGH(mask) Cleans a mask based on region size
%   CLEAN_MASK_HOUGH cleans the input mask by removing smaller regions
%   with a hard threshold. This function is intended to be used with
%   hough_stough.m
%   
%   INPUTS:
%       mask - mask to be cleaned
%   OUTPUTS:
%       cleaned - cleaned mask

% Max number of pixels to be counted as a region
MIN_PIXEL_COUNT = numel(mask)/500;

cleaned = mask;
labeled_mask = bwlabel(mask);

% Remove regions too small
for a = 1:max(labeled_mask(:))
    [r,c] = find(labeled_mask == a);
    if numel(r) < MIN_PIXEL_COUNT;
        cleaned(r,c) = 0;
    end
end

end