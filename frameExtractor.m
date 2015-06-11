clear all
clc

fprintf('Read frame numbers in lower-right corner of video window.\r\n');
%filename = '../Videos/Galileo Division - Semi Finals 1 Match 3.mp4';
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
    

reader = VideoReader(filename);
vidHeight = reader.Height;
vidWidth = reader.Width;
extractSize = lastFrame - firstFrame + 1;
%frames(1:extractSize) = struct('cdata', ...
%                                            zeros(vidHeight, vidWidth, 3, 'uint8'), ...
%                                            'colormap', []);
mkdir(folderName);
h = waitbar(0, ['0/' num2str(extractSize) ' frames']);
for i = 1:extractSize
    %frames(i).cdata = read(reader, i);
    frame = read(reader, firstFrame + i - 1);
    imwrite(frame, [folderName '/' num2str(i) '.png']);
    waitbar(i / extractSize, h, [num2str(i) '/' num2str(extractSize) ' frames']);
end
close(h);

fprintf(['Wrote ' num2str(extractSize) ' frames to ' folderName '.\r\n']);