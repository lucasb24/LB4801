function fish = test_fisher(feature_array,axis)
%% Fisher Criterion
fa = feature_array;
ffa = fa{axis};

fish = [];
for ang = 1:length(ffa)-1
    
    for w = 1:length(ffa{ang})
        
        m1 = mean(ffa{ang}(w,:));
        m2 = mean(ffa{ang+1}(w,:));
        s1 = var(ffa{ang}(w,:));
        s2 = var(ffa{ang+1}(w,:));
        fish(ang,w) = fisher_crit(m1,m2,s1,s2);
        
    end
    
end

end
