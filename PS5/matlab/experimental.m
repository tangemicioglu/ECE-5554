clc; clear all; close all;
%% Init
actions = {'botharms', 'crouch', 'leftarmup', 'punch', 'rightkick'};
sequences = {'-p1-1', '-p1-2', '-p2-1', '-p2-2'};
basedir = '../database/';
allMHIs = zeros(480,640,20);
huVectors = zeros(20,7);
labels = [1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5];
nActions = length(actions);
nSequences = length(sequences);
nNeighbour = 4;
counter = 1;
confusionMatrix = zeros(nActions,nActions);

%% Loop-over sequences to create MHIs
for i=1:nActions
    for j=1:nSequences
        subdir = [basedir, actions{i}, '/', actions{i}, sequences{j}, '/'];
        H = computeMHIExperimental(subdir);
        allMHIs(:, :, counter) = H;
        figure(counter); imagesc(H); title(['Action: ', actions{i}, ' Sequence: ', sequences{j}]);
%         saveas(counter, ['LOOCV-MHI-', actions{i}, sequences{j}, '.png'],'png');
        counter = counter+1;
    end
end
    
%% Calculate Hu moments
for i=1:nActions*nSequences
    huVectors(i,:) = huMoments(allMHIs(:,:,i));    
end    

%% Nearest Neighbour Classifier - Leave-one-out Cross Validation
for i=1:nActions*nSequences
    trainLabels = 1:nActions*nSequences;
    [sequenceID, actionID] = ind2sub([nSequences, nActions],i);
    trainLabels(i) = [];
    huVectorsCopy = huVectors;
    huVectorsCopy(i,:) = [];    
    predictedLabel = predictAction(huVectors(i,:), huVectorsCopy, trainLabels);
    for j=1:nActions
        nFound = sum(labels(sequenceMatched(1:3)) == j);
        confusionMatrix(actionID,j) = nFound;
    end
end
fprintf('Confusion Matrix: \r\n');
pretty(sym(confusionMatrix));

%% Experimental Work - Leave-one-out Cross Validation
for i=1:nActions*nSequences
    trainLabels = 1:nActions*nSequences;
    [sequenceID, actionID] = ind2sub([nSequences, nActions],i);
    trainLabels(i) = [];
    huVectorsCopy = huVectors;
    huVectorsCopy(i,:) = [];    
    predictedLabel = predictActionExperimental(huVectors(i,:), huVectorsCopy, trainLabels);
    i
%     distances
    sequenceMatched
    for j=1:nActions
        nFound = sum(labels(sequenceMatched(1:4)) == j);
        confusionMatrix(actionID,j) = nFound;
    end
    pause;
end
fprintf('Confusion Matrix: \r\n');
pretty(sym(confusionMatrix));
