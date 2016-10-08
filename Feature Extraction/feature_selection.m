function feats = feature_selection(feature_array, axis)

% Fisher Criterion
fa = feature_array;
ffa = fa{axis};

fish = [];%todo preallocate size

for ang = 1:length(ffa)-1
    
    for w = 1:length(ffa{ang})
        
        m1 = mean(ffa{ang}(w,:));
        m2 = mean(ffa{ang+1}(w,:));
        s1 = var(ffa{ang}(w,:));
        s2 = var(ffa{ang+1}(w,:));
        fish(ang,w) = fisher_crit(m1,m2,s1,s2);
        
    end
    
end

fishStd = std(fish);
inds = find(fishStd < 0.01);
idx = find(fish(inds) >  mean(fish(inds))+2*std(fish(inds)));
feats = inds(idx);


end