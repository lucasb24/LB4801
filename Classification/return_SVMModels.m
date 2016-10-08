function [SVMModels, classLabels, classFeatures] = return_SVMModels(farray, fnums, axis, angles)
% Train an return a cell array of trained SVM models based on the feature
% array and feature indices supplied
%
% In:           farray - Feature array for training volumes
%                fnums - Indices of the selection features from the training
%                volumes
%
% Out:      SVMModels - Cell array of SVM models trained on the training data
%               classFeatures - the feature indices corresponding to the
%               trained classifier models

classFeatures = [];
SVMModels = {};
c = 0;
classThreshold = 29;

% Loop through every combination of features
for ii = 1:length(fnums)
    for jj = ii:length(fnums)
        if fnums(ii) ~= fnums(jj)
            
            f1 = fnums(ii);
            f2 = fnums(jj);
            
            X = [];
            y = [];
            for i = 1:length(angles)
                X = [X; farray{axis}{i}(f1,:)',farray{axis}{i}(f2,:)'];
                y = [y; angles(i)*ones(size(farray{axis}{i},2),1)]; 
            end
            
            Y = cell(length(y),1);
            for i = 1:length(y)
                Y{i} = num2str(y(i));
            end
            
            % Train classifier - retain model if it misclassification rate is below classThreshold
            Model = train_svm(X,Y,classThreshold);
            if ~isempty(Model)
                c = c+1;
                SVMModels{c} = Model;
                classFeatures(c,:) = [f1,f2]; %record features
                
            end
        end
    end
end

classLabels = Y;

end