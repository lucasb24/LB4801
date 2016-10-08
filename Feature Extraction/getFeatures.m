function feat_array = getFeatures(points, num)

sz = 3*(sum(1:num-1));
feat_array = zeros(sz,1);
fa = 1;
P = points;

% Feature creation - landmarks with respect to other landmarks on all 3 axes
% For each dimension of each landmark compute the voxel difference between
% point LMS and remaining points RMS of that dimension in the volume
for lms = 1:num
    for rms = lms:num
        if lms ~= rms
            difs = P(rms,:) -P(lms,:); 
            for d = 1:3
                switch d
                    case 1
                        if ~(difs(2) == 0 && difs(1) == 0)
                            feat_array(fa) = atand(difs(2)/difs(1));
                        end
                    case 2
                        if ~(difs(3) == 0 && difs(1) == 0)
                            feat_array(fa) = atand(difs(3)/difs(1));
                        end
                    case 3
                        if ~(difs(2) == 0 && difs(3) == 0)
                            feat_array(fa) =atand(difs(3)/difs(2));
                        end
                end
                fa = fa+1;
            end
        end
    end
end


end