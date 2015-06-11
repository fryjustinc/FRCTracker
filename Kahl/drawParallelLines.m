function [ img_lines, img_paral, R1R2T_paral ] = drawParallelLines( edgels, colour )
%DRAWPARALLELLINES(edgels, colour) Draws parallel lines from edgel mask.
%   DRAWPARALLELLINES returns blank images with lines and parallel lines 
%   drawn on them with the specified color. R values and theta value of
%   each parallel line pair is also returned.
%   
%   INPUTS:
%       edgels - edgel mask to find lines from
%       colour - color of lines to be drawn as [R G B] vector
%   OUTPUTS:
%       img_lines - blank image with all detected lines drawn on it
%       img_paral - blank image with parallel lines drawn on it
%       R1R2T_paral - vector with R values and theta value of each parallel
%                     line pair
%           --> Format of each row: <R1> <R2> <Theta>

img_lines = zeros([size(edgels) 3]);
img_paral = zeros([size(edgels) 3]);
R1R2T_paral = [];

%% Find lines in edgel mask
[H, T, R] = hough(edgels);
peaks = houghpeaks(H, 15);
T_peaks = T(peaks(:,2));
R_peaks = R(peaks(:,1));

%% Find parallel lines
isParallel = zeros(size(T_peaks));
for a = 1:numel(T_peaks)
    if isParallel(a) == 0
        for b = a+1:numel(T_peaks)
            if abs(T_peaks(a) - T_peaks(b)) < 2% && ...
               %abs(R_peaks(a) - R_peaks(b)) > 10 && ...
               %abs(R_peaks(a) - R_peaks(b)) < 40
                isParallel(a) = 1;
                isParallel(b) = 1;
                R1R2T_paral = [R1R2T_paral;
                               R_peaks(a) R_peaks(b) (T_peaks(a)+T_peaks(b))/2];
            end
        end
    end
end

%% Draw lines and parallel lines onto a blank image
for a = 1:numel(T_peaks)
    T_a = T_peaks(a);
    R_a = R_peaks(a);
    % Draw with column-first indexing and row-first indexing so vertical 
    % and horizontal lines are solid 
    for c = 1:size(img_lines,2)
        r = round((R_a - c*cosd(T_a))/sind(T_a));
        if r > 0 && r < size(img_lines,1)
            % Draw every line
            img_lines(r,c,1) = colour(1);
            img_lines(r,c,2) = colour(2);
            img_lines(r,c,3) = colour(3);
            if isParallel(a) == 1
                % Draw only parallel lines
                img_paral(r,c,1) = colour(1);
                img_paral(r,c,2) = colour(2);
                img_paral(r,c,3) = colour(3);
            end
        end
    end
    for r = 1:size(img_lines,1)
        c = round((R_a - r*sind(T_a))/cosd(T_a));
        if c > 0 && c < size(img_lines,2)
            % Draw every line
            img_lines(r,c,1) = colour(1);
            img_lines(r,c,2) = colour(2);
            img_lines(r,c,3) = colour(3);
            if isParallel(a) == 1
                % Draw only parallel lines
                img_paral(r,c,1) = colour(1);
                img_paral(r,c,2) = colour(2);
                img_paral(r,c,3) = colour(3);
            end
        end
    end
end

end

