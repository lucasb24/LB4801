function boxx = coarse_voting(mat, search_box,div)
% coarse_voting
ylim([0 260])
zlim([0 260])
xlim([0 180])

% div = 5;
% sz = size(mat);
sb = search_box;
sz = sb(:,2) - sb(:,1);

bx = floor(sz/div);
score = [];
c = 1;


for i =sb(1,1):sz(1)/(2*div):sb(1,2)-bx(1)
    for j = sb(2,1):sz(2)/(2*div):sb(2,2)-bx(2)
        for k = sb(3,1):sz(3)/(2*div):sb(3,2)-bx(3)
            p = [floor(i), floor(j), floor(k)];
            x = p(1):p(1)+bx(1)-1;
            y = p(2):p(2)+bx(2)-1;
            z = p(3):p(3)+bx(3)-1;
            sc = sum(sum(sum(mat(x,y,z))));
            score(c,:) = [p(1),p(2),p(3),sc];
            c = c + 1;
        end
    end
end


[~, d2] = sort(score(:,4),'descend');
score_sort = score(d2,:);
ss = score_sort;

for c = 1:4
    if ss(c,4) == 0% exploit the empty space somehow
        %         drawCube(ss(c,1:3),bx,'b');
    else
%         drawCube(ss(c,1:3),bx,'k');
%         pause;%debugging
    end
end

boxx = {};

for i = 1:length(ss)
    if ss(i,4) ~= 0
        boxx{i,1} = [ss(i,1:3)',ss(i,1:3)'+bx];
        boxx{i,2} = ss(i,4);
    end
end
end