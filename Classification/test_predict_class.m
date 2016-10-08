%% Cross validatin parititioning
datestr(now)
cv = cvpartition(1:19,'k',5);
clearvars trainingStruct testStruct
cvError = zeros(cv.NumTestSets,1);

%% 
clc
datestr(now)
for cv0 = 1:cv.NumTestSets
trainingStruct.nii = cell(cv.TrainSize(cv0),1);
trainingStruct.landmarks = cell(cv.TrainSize(cv0),1);

trainingPart = cv.training(cv0);
n = 0;
for i = 1:length(trainingPart)
    if trainingPart(i) == 1
        n = n +1;
        trainingStruct.nii{n} = niiNew{i};
        trainingStruct.landmarks{n} = landmarksNew{i};
    end
end

testPart = cv.test(cv0);
n = 0;
for i = 1:length(testPart)
    if testPart(i) == 1
        n = n +1;
        testStruct.nii{n} = niiNew{i};
        testStruct.landmarks{n} = landmarksNew{i};
    end
end


%% Feature Extraction

angles = -10:5:10;
fa = feature_extraction(trainingStruct,angles);

%% Feature Selection
fprintf('Axis\tNum Features\n');

f = cell(3,1);
for axis = 1:3
    
    f{axis} = feature_selection(fa,axis);
    fprintf('%d\t%d\n',axis,length(f{axis}));
    
end


%% Train
fprintf('Axis\tNum Models\n');

SVMModels = cell(3,1);
classFeatures = cell(3,1);
for axis = 1:3
    [SVMModel, classLabels, classFeats] = return_SVMModels(fa,f{axis},axis,angles);
    SVMModels{axis} = SVMModel;
    classFeatures{axis} = classFeats;
    fprintf('%d\t%d\n',axis,length(SVMModel));
end


%% Test Volume
err = 0;

for sub = 1:length(testStruct.landmarks)
    
    test_subject = testStruct.landmarks{sub};
    origin = size(testStruct.nii{sub}.img)./2;
    
    for axis = 1:3
        
        for a = angles
            
            newPoints = getRotatedPoints(test_subject,origin,axis,a);
            test_fa = getFeatures(newPoints,22);
            class = classify_SVM(SVMModels{axis},test_fa,classFeatures{axis},unique(classLabels),angles);
            
            if a ~= str2double(class)
                err = err+1;
            end
            
        end
        
    end
    
end

den = cv.TestSize(cv0)*3*length(angles);
cvError(cv0) = err/den;
fprintf('Set %d Err %d\n',cv0,cvError(cv0)*100);

end
100*mean(cvError)
datestr(now)

