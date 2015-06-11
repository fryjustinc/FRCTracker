clear all;
clc;

load('features.mat');
features = [];
for i = 1:size(imgList, 2)
    features(i,:) = imgList{i}.fv;
end
features = normalizeFeatures01(features);
for i = 1:size(imgList, 2)
    imgList{i}.fv = features(i,:);
end

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

net = svm(size(trainersX, 2), 'rbf', [5.76], 100);
net = svmtrain(net, trainersX, trainersY);
%[net, cverr, paramseq] = svmcv(net, trainersX, trainersY, [4 6], 1.2, 10);

R = repmat([0,1],294,1);
S = [800 1];
[y, y1] = svmfwd(net, trainersX);
trueposarray=[];
falseposarray=[];
areasvm=0;
k = 1;

maxCorrectThreshedY = [0, 0]; % first element is the Y value, second is the testersY index
minCorrectThreshedY = [0, 0];
maxIncorrectThreshedY = [0, 0];
minIncorrectThreshedY = [0, 0];

for threshold = -10:.05:10
    rawThreshedY = y1+threshold;
    threshedY = rawThreshedY./abs(rawThreshedY);
    truepos=0;
    trueneg=0;
    falsepos=0;
    falseneg=0;
    for i = 1:size(trainersY,1)
        if (trainersY(i)==1 && threshedY(i)==1)
            truepos=truepos+1;
            if rawThreshedY(i) > maxCorrectThreshedY
                maxCorrectThreshedY = [rawThreshedY(i), i];
            end
        elseif (trainersY(i)==-1 && threshedY(i)==-1)
            trueneg=trueneg+1;
            if rawThreshedY(i) < minCorrectThreshedY
                minCorrectThreshedY = [rawThreshedY(i), i];
            end
        elseif (trainersY(i)==-1 && threshedY(i)==1)
            falsepos=falsepos+1;
            if rawThreshedY(i) > maxIncorrectThreshedY
                maxIncorrectThreshedY = [rawThreshedY(i), i];
            end
        elseif (trainersY(i)==1 && threshedY(i)==-1)
            falseneg=falseneg+1;
            if rawThreshedY(i) < minIncorrectThreshedY
                minIncorrectThreshedY = [rawThreshedY(i), i];
            end
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
    if threshold > -10
        areasvm=areasvm + (falseposarray(k)-falseposarray(k-1))*trueposarray(k);
    end
k=k+1;            
end

fprintf('TPR: %d.\n', trueposrate);
fprintf('FPR: %d.\n', falseposrate);
fprintf('Best positive classification: Alpha of %d for file %s.\n', maxCorrectThreshedY(1), imgList{maxCorrectThreshedY(2)}.fileLoc);
fprintf('Best negative classification: Alpha of %d for file %s.\n', minCorrectThreshedY(1), imgList{minCorrectThreshedY(2)}.fileLoc);
fprintf('Worst positive classification: Alpha of %d for file %s.\n', maxIncorrectThreshedY(1), imgList{maxIncorrectThreshedY(2)}.fileLoc);
fprintf('Worst negative classification: Alpha of %d for file %s.\n', minIncorrectThreshedY(1), imgList{minIncorrectThreshedY(2)}.fileLoc);