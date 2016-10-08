function [score] = fine_voting(mat, searchBox,div)

sb = searchBox;
sz = sb(:,2) - sb(:,1);

bx = floor(sz/div);
score = [];
c = 1;

for i =sb(1,1):sb(1,2)-bx(1)
    for j = sb(2,1):sb(2,2)-bx(2)
        for k = sb(3,1):sb(3,2)-bx(3)
            p = [floor(i), floor(j), floor(k)];
            x = p(1):p(1)+bx(1);
            y = p(2):p(2)+bx(2);
            z = p(3):p(3)+bx(3);
            sc = sum(sum(sum(mat(x,y,z))));
            score(c,:) = [p(1),p(2),p(3),sc];
            c = c + 1;
        end
    end
end

[~, d2] = sort(score(:,4),'descend');
score_sort = score(d2,:);
ss = score_sort;

% drawCube(ss(1,1:3),bx,'r');
score = ss(1,4);

end
