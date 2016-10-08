function class = classify_SVM(SVMModels,test_featureArray, classFeatures, classLabels,angles)
    
    test_fa = test_featureArray;
    CC = [];
    classes = classLabels;%unique(Y);
    
    for fts = 1:length(SVMModels)%numFeatClassifiers
        
        test_fa1 = test_fa(classFeatures(fts,1));
        test_fa2 = test_fa(classFeatures(fts,2));
        XX = [test_fa1,test_fa2];
        
        Scores = zeros(1,numel(classes));
        for j = 1:numel(classes);
            
            [~,score] = predict(SVMModels{fts}{j},XX);
            Scores(:,j) = score(:,2); % Second column contains positive-class scores
            
        end
        
        [~, i] = max(Scores);
        CC(fts) = angles(i);
        
    end
    
    edges = [angles, angles(end)+(angles(end)-angles(end-1))]; 
    [N, ~] = histcounts(CC,edges);
    [~ ,i] = max(N);
    class = (char(classes(i)));
    
    
end