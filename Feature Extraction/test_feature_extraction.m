%test_feature_extraction
fa1 = [];
fa3 = fa1;
fa2 = fa1;
fa4 = fa1;
fa5 = fa1;
%%
% fa = cell(1,3);
% 
%%
angle = 10;
rot_axis = 1;
i = 1;
for n = 1:28
    if ~isempty(nii{n})
        
        points = landmarks{n};
%         points2 = siftMarks{n};
        fa1(:,i) = getFeatures(points,22);
%         fs1(:,i) = getFeatures(points2,1:22);
        
        origin = size(nii{n}.img)./2;
        
        rotatedPoints = getRotatedPoints(points, origin, rot_axis, angle);
        fa2(:,i) = getFeatures(rotatedPoints,22);
%         
        rotatedPoints = getRotatedPoints(points, origin, rot_axis, -1*angle);
        fa3(:,i) = getFeatures(rotatedPoints,22);
        
        rotatedPoints = getRotatedPoints(points, origin, rot_axis, 2*angle);
        fa4(:,i) = getFeatures(rotatedPoints,22);
%         
        rotatedPoints = getRotatedPoints(points, origin, rot_axis, -2*angle);
        fa5(:,i) = getFeatures(rotatedPoints,22);
        
        i = i +1;
    end
end


%% Fisher Criterion
fish1 = [];
for w = 1:length(fa1)
     m1 = mean(fa1(w,:));
     m2 = mean(fa5(w,:));
     s1 = var(fa1(w,:));
     s2 = var(fa5(w,:));
     fish1(w) = fisher_crit(m1,m2,s1,s2);
end
figure;bar(fish1);

%% Fisher threshold for features
inds = (find(fish1 > (mean(fish1)+std(fish1)*3)));

%% Compare features
c = 1;
clearvars f_sel_err
tic
for i = 1:length(inds)
%     for j = i:length(inds)
        
%         if i ~= j
        f1 = inds(i,1);
        f2 = inds(i,2);

        
%         figure(6);clf;
        
        x1 = fa1(f1,:);
        y1 = fa1(f2,:);
        
        
        x2 = fa2(f1,:);
        y2 = fa2(f2,:);
        
        x3 = fa3(f1,:);
        y3 = fa3(f2,:);
        
        x4 = fa4(f1,:);
        y4 = fa4(f2,:);
        
        x5 = fa5(f1,:);
        y5 = fa5(f2,:);
        
        X = [x1', y1';x2', y2'; x3', y3'; x4', y4';x5', y5'];

%         f_sel_err(c) = test_svm(X,Y);
        test_svm(X,Y);
        gcf;xlabel(num2str(f1));ylabel(num2str(f2));
%         feats(c,:) = [f1,f2];
%         c = c+1;
        
%         plot(x1,y1,'r*');hold on;
%         plot(x2,y2,'bx');hold on;
%         plot(x3,y3,'go');hold on;
%         plot(x4,y4,'mo');hold on;
%         plot(x5,y5,'b*');
%         title(sprintf('Features [%d, %d]',f1,f2));
        pause;
%         end
%     end

end

toc




