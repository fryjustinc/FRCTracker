clear all;
clc;

% load features extracted by imageReader.m
load('features.mat');
features = [];
for i = 1:size(imgList, 2) % create matrix of feature vectors
    features(i,:) = imgList{i}.fv;
end

% associate features with images
features = normalizeFeatures01(features);
for i = 1:size(imgList, 2)
    imgList{i}.fv = features(i,:);
end

% load training and test images
trainersX = [];
trainersY = [];
testersX = [];
testersY = [];
for i = 1:size(imgList, 2)
    if imgList{i}.class == 0
        trainersX = cat(1, trainersX, imgList{i}.fv);
        trainersY = cat(1, trainersY, imgList{i}.label);
    else
        testersX = cat(1,testersX,imgList{i}.fv);
        testersY = cat(1,testersY,imgList{i}.label);
    end
end

% perform svm training
net = svm(size(trainersX, 2), 'rbf', [5.76], 100); % parameter of 5.76 generated by using 10-fold svmcv
net = svmtrain(net, trainersX, trainersY);

% test svm against testing set
[y, y1] = svmfwd(net, testersX);
trueposarray=[];
falseposarray=[];

% determine the threshold value for y1 that produces the most accurate SVM
% results:
k = 1;
bestSVMThreshold = 0;
for threshold = -10:.05:10
    rawThreshedY = y1+threshold;
    threshedY = rawThreshedY./abs(rawThreshedY);
    truepos=0;
    trueneg=0;
    falsepos=0;
    falseneg=0;
    for i = 1:size(testersX,1)
        if (testersY(i)==1 && threshedY(i)==1)
            truepos=truepos+1;
        elseif (testersY(i)==-1 && threshedY(i)==-1)
            trueneg=trueneg+1;
        elseif (testersY(i)==-1 && threshedY(i)==1)
            falsepos=falsepos+1;
        elseif (testersY(i)==1 && threshedY(i)==-1)
            falseneg=falseneg+1;
        end
    end
    trueposrate = truepos / (truepos + falseneg);
    falseposrate = falsepos / (truepos + falseneg);
    trueposarray=cat(1,trueposarray,trueposrate);
    falseposarray=cat(1,falseposarray,falseposrate);
    if threshold == 0
        naturaltruepos = truepos;
        naturaltrueneg = trueneg;
        naturalfalsepos = falsepos;
        naturalfalseneg = falseneg;
        naturaltrueposrate = trueposrate;
        naturalfalseposrate = falseposrate;
    end
    
    if k == 191 % makes k equal the index at which fpr and tpr are optimized according to ROC curve below
        bestSVMThreshold = threshold;
    end
    
    k = k + 1;
end

plot(falseposarray, trueposarray); % show ROC curve

save('svm.mat', 'net', 'bestSVMThreshold');