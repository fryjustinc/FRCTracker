function [L,S,T] = rgb2lst(img)

R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));

L = (R + G + B) / sqrt(3);
S = (R - B) / sqrt(2);
T = (R - 2.*G + B) / sqrt(6);

lst_img(:,:,1) = zeros(size(S,1), size(S,2));
lst_img(:,:,2) = S;
lst_img(:,:,3) = zeros(size(S,1), size(S,2));

end