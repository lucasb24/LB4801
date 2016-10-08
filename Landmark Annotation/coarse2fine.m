%coarse2fine
% exploit empty space with coarse check
% iterate finely over the rest

copy(gcf);
sb = [1, 176; 1, 256; 1, 256];
boxx = coarse_voting(mat,sb,3);
div = 2;

for b = 1:4
    c_box2{b} = coarse_voting(mat,boxx{b,1},div);
end

div = 2;
for bb = 1:4
    for b = 1:4
        s(bb,b) = fine_voting(mat,c_box2{bb}{b,1},div);
    end
end


[x, y] = ind2sub(size(s),find(s == max(max(s))));
if length(x) > 1
    for k = 1:length(x)
        fbb{k} = c_box2{x(k)}{y(k)};
    end
else
    fbb = c_box2{x}{y};
end

fbx = fbb{1};
A = mat(fbx(1,1):fbx(1,2),fbx(2,1):fbx(2,2),fbx(3,1):fbx(3,2));

[i, j, k] = ind2sub(size(A), find(A == max(max(max(A)))));
fp = fbx(:,1) + [i;j;k];
hold on;scatter3(fp(1),fp(2),fp(3),'k','filled');

