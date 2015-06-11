clear all
clc

% acquire the location of the video to extract frames from:
fprintf('Read frame numbers in lower-right corner of video window.\r\n');
[filename, pathname, filterIdx] = uigetfile('*.*', 'Select video file');
filename = [pathname '/' filename];
implay(filename);

firstFrame = 0;
lastFrame = 0;
folderName = '';
while firstFrame <= 0 || lastFrame <= 0 || firstFrame > lastFrame || isempty(folderName)
    firstFrame = input('First frame #: ');
    lastFrame = input('Last frame #: ');
    folderName = input('Folder name: ', 's');
end
    
% open the video, calculate the number of frames to extract
reader = VideoReader(filename);
vidHeight = reader.Height;
vidWidth = reader.Width;
extractSize = lastFrame - firstFrame + 1; % +1 for inclusive indexing

% write each extracted frame to file; the filename is the new relative frame number
% starting from 1
mkdir(folderName);
h = waitbar(0, ['0/' num2str(extractSize) ' frames']); % show progress bar
for i = 1:extractSize
    frame = read(reader, firstFrame + i - 1);
    imwrite(frame, [folderName '/' num2str(i) '.png']);
    waitbar(i / extractSize, h, [num2str(i) '/' num2str(extractSize) ' frames']); % update progress bar
end
close(h);

fprintf(['Wrote ' num2str(extractSize) ' frames to ' folderName '.\r\n']);