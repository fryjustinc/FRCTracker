function  video_maker(videoFileName, directory, start,finish)
writer = VideoWriter(videoFileName);
open(writer);

fileList = dir(directory);

for i = 3+start:finish
    filename = [directory '\' num2str(i-2) '.png'];
    img = imread(filename);
    writeVideo(writer, im2frame(img));
end
close(writer);
end