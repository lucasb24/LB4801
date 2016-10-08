function SVMModels = test_svm(X,Y)

classes = unique(Y);
SVMModels = cell(numel(classes),1);

for j = 1:numel(classes)
indx = strcmp(Y,classes(j));
SVMModels{j} = fitcsvm(X,indx,'ClassNames',[false true], 'Standardize', true, 'KernelFunction', 'rbf', 'BoxConstraint',2);
end

% d = 0.1;
% [x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
% min(X(:,2)):d:max(X(:,2)));
% xGrid = [x1Grid(:),x2Grid(:)];
% N = size(xGrid,1);
% Scores = zeros(N,numel(classes));
% 
% for j = 1:numel(classes);
% [~,score] = predict(SVMModels{j},xGrid);
% Scores(:,j) = score(:,2); % Second column contains positive-class scores
% end
% [~,maxScore] = max(Scores,[],2);
% 
% figure
% gscatter(xGrid(:,1),xGrid(:,2),maxScore,...
% [0.1 0.5 0.5; 0.5 0.1 0.5; 0.5 0.5 0.1]);
% hold on
% gscatter(X(:,1),X(:,2),Y);
% title('{\bf X rot Classification Regions}');
% % xlabel('F 93');
% % ylabel('F 837');
% axis tight
% hold off

%% wrongly classified
clearvars Scores
for j = 1:numel(classes);
[~,score] = predict(SVMModels{j},X);
Scores(:,j) = score(:,2); % Second column contains positive-class scores
end
[~, cls] = max(Scores');

for ii = 1:length(cls)
    if ~strcmp(Y{ii},classes{cls(ii)})
        mydiff(ii) = 1;
        hold on;plot(X(ii,1),X(ii,2),'ks','MarkerSize',12);
    else
        mydiff(ii) = 0;
    end
end

% g = zeros(1,numel(classes));
% for i = 1:numel(classes)
%     for ii = i*19-18:i*19
%         g(i) = g(i) + mydiff(ii);
%     end
%     g(i) = g(i)/19;
% end

a = size(mydiff,2);
b = size(mydiff(mydiff == 1),2);

err = (b/a)*100;
fprintf('Percentage misclassified \t%f  \n',err);
if err > 25
    SVMModels = {};
end
% fprintf('For each class\t\t\t %s\n',num2str(g*100));
% pause;
end

