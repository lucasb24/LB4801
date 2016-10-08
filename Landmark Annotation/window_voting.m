function [foundPoint, score, searchBox] = window_voting(matches, mat, box_size, search_box)
%todo make recursive? where is the end?

% step = box_size;
sb = search_box;
step = floor((sb(:,2) - sb(:,1))/10);
st = step;
bx = box_size;

a = find(sb == 0); %silly bug during recursion matlab indexing
if ~isempty(a)
    sb(a) = sb(a) +1;
end

sz = size(mat);
scores = zeros(sz);


for x = sb(1,1):st(1):sb(1,2)
    for y = sb(2,1):st(2):sb(2,2)
        for z = sb(3,1):st(3):sb(3,2)
            score = 0;
            for i = x:x+bx(1)
                for j = y:y+bx(2)
                    for k = z:z+bx(3)
                        if ~((i > sz(1) )||(j > sz(2))||(k > sz(3)))
                            if mat(i,j,k) ~= 0
                                score = score + mat(i,j,k);
                            end
                        end
                    end
                end
            end
            scores(x,y,z) = score;
        end
    end
end

inds = find(scores == max(max(max(scores))));
[I, J, K] = ind2sub(size(scores),inds);

% Display bounding box for visual purposes
% hold on;scatter3(I,J,K,'k','filled');
if length(I) < 2
    hold on;
    drawCube([I,J,K],bx);
else
    for c = 1:length(I)
        hold on;
        boxx = [I(c),J(c),K(c)];
        drawCube(boxx,bx);
    end
end

cor = [I, J, K]; %corner of box 

for i = 1:3
    if length(I) > 1
        searchBox(i,:) = [min(cor(:,i)), max(cor(:,i))+bx(i)];
    else
        searchBox(i,:) = [(cor(:,i)), (cor(:,i))+bx(i)];
    end
end

sb = searchBox;

[box_ind, ~] = find((matches(:,1) > sb(1,1) & matches(:,1) < sb(1,2)) ...
    &(matches(:,2) > sb(2,1) & matches(:,2) < sb(2,2)) ...
    &(matches(:,3) > sb(3,1) & matches(:,3) < sb(3,2)));

m = matches(box_ind,:);

[max_ind, ~] = find(m(:,4) == max(m(:,4)));

foundPoint = m(max_ind,1:3);
score = m(max_ind,4);

end