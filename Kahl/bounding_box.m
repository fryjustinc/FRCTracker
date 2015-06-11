function [ R1, C1, R2, C2, boxed_Image_Obj ] = bounding_box( mask, Image_Obj )
%BOUNDING_BOX(mask, Image_Obj) Finds bounding boxes of mask.
%   BOUNDING_BOX returns the coordinates of the bounding boxes of the
%   regions found in the given mask. Also outputs an Image object with the
%   image blacked out everywhere except within the bounding boxes
%   
%   INPUTS:
%       mask - edgel mask to find lines from
%       Image_Obj - Image object of original image
%   OUTPUTS:
%       R1 - Vector of row of top-left corner of bounding boxes
%       C1 - Vector of column of top-left corner of bounding boxes
%       R2 - Vector of row of bottom-right corner of bounding boxes
%       C2 - Vector of column of bottom-right corner of bounding boxes
%       boxed_Image_Obj - Image object of boxed image 

labeled_mask = bwlabel(mask);
R1 = [];
C1 = [];
R2 = [];
C2 = [];
box_mask = zeros(size(mask));

%% Find bounding box of each region
for a = 1:max(labeled_mask(:))
    [r,c] = find(labeled_mask == a);
    r1 = min(r);
    c1 = min(c);
    r2 = max(r);
    c2 = max(c);
    
    % Store coordinates
    R1 = [R1; r1];
    C1 = [C1; c1];
    R2 = [R2; r2];
    C2 = [C2; c2];
    
    % Mask of the bounding boxes
    box_mask(r1:r2,c1:c2) = 1;
end

%% Black out image not within bounding boxes
boxed_img = Image_Obj.img;
boxed_img(:,:,1) = boxed_img(:,:,1) .* box_mask;
boxed_img(:,:,2) = boxed_img(:,:,2) .* box_mask;
boxed_img(:,:,3) = boxed_img(:,:,3) .* box_mask;

boxed_Image_Obj = Image(boxed_img);

end