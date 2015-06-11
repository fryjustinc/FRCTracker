clear all
clc

dirs{1} = 'segmented/robots';
label{1} = 1;
class{1} = 0;
dirs{2} = 'segmented/nonrobots';
label{2} = -1;
class{2} = 0;
% 
% dirs{3} = 'images/TestBumpers';
% label{3} = 1;
% class{3} = 1;
% dirs{4} = 'images/TestNonbumpers';
% label{4} = -1;
% class{4} = 1;
    
dirList = cell(size(dirs, 2),1);
for i = 1:size(dirs, 2)
    thisFileList = dir(dirs{i});
    thisLabel = label{i};
    thisClass = class{i};
    
    dirList{i} = struct('fileList', thisFileList, ...
                          'label', thisLabel, ...
                          'class', thisClass);
end

imgList = {};
for i = 1:size(dirList, 1)
    % files 1 and 2 are . (current dir) and .. (parent dir), respectively, 
    % so we start with 3.
    for j = 3:size(dirList{i}.fileList)
        fileLoc = [dirs{i}  '/'  dirList{i}.fileList(j).name];
        img = imread(fileLoc);
        fv = extractFeatureVector(img);
        imgList{size(imgList, 2) + 1} = struct('fv', fv, ...
                                               'label', dirList{i}.label, ...
                                               'class', dirList{i}.class, ...
                                               'fileLoc', fileLoc);
    end
end

save('features.mat', 'imgList');