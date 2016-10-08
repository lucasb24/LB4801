
function matches = getSIFTMatches(test_struct, training_struct, sift_mag, sift_dist_thr,sift_match_thr, lm)

test_volume = test_struct.vol;
f_ = test_struct.feat;
d_ = test_struct.desc;

training_volumes = training_struct.volumes;
training_landmarks = training_struct.landmarks;

fprintf('[%d] Matching subject''s interest points to landmark: Matching Threshold %d ',lm,sift_match_thr);


% fprintf('%d ',lm');
%inits fix
totalScores = [];
finalScores = cell(28,1);

for kn = 1:28
    
    tempScores = [];
    
    if (~isempty(training_volumes{kn}))
        % for testing
        % separate training and test volumes
        flag = strcmp(training_volumes{kn}.fileprefix,test_volume.fileprefix);
        if ~flag
            %
            ts = 1;%counter for scores - todo fix
            
            for dim = 1:3
                
                vox = training_landmarks{kn}(lm,:);
                images = splice(vox(1),vox(2),vox(3),training_volumes{kn});
                I = images{dim};
                I = single(I);
                
                for mag = sift_mag
                    
                    if dim == 1
                        lk = [vox(2); 256-vox(3); mag; 0];
                    elseif dim == 2
                        lk = [vox(1); 256-vox(3); mag; 0];
                    elseif dim == 3
                        lk = [vox(1); vox(2); mag; 0];
                    end
                    
                    [~,d] = vl_sift(I, 'frames',lk, 'orientations');
                    
                    if mag == sift_mag(1)
                        dd = d;
                    else
                        dd = [dd,d];
                    end
                    
                end
                
                %Matching
                for view = 1:size(d_{dim},2)
                    [matches, scores] = vl_ubcmatch(dd,d_{dim}{view},sift_match_thr);
                    if ~isempty(matches)
                        for mh = 1:size(matches,2)
                            tempScores(ts,1:4) = [scores(mh),view,matches(2,mh),dim];
                            ts = ts+1;
                        end
                    end
                end
            end
        end
        finalScores{kn} = tempScores;
    end
end

% Weighted Majoriting voting for new landmark

for kn = 1:28
    if ~isempty(finalScores{kn})
        totalScores =[totalScores; finalScores{kn}];
    end
end


voxels = [];
sift_dist_thr = median(totalScores(:,1));
inds = find(totalScores(:,1) < sift_dist_thr);
mx = max(totalScores(:,1));
mi = min(totalScores(:,1));
me = mean(totalScores(:,1));
fprintf('\n[%d] Scores - Max: %d Min: %d Mean: %d',lm,mx,mi,me);
fprintf('\n[%d] Points matched = %d',lm,size(totalScores,1));
minScores = totalScores(inds,:);%todo fix find func

if ~isempty(minScores)
    
    sc = minScores(:,1);
    in = 1./sc;
    f = sum(in);
    wsc = in./f;
    for i = 1:size(minScores,1)
        
        dim = minScores(i,4);
        view = minScores(i,2);
        mk = minScores(i,3);
        
        vox = [];
        
        if dim == 1
            im = splice(view,1,1,test_volume);
            vox(1) = view;
            vox(2) =  f_{dim}{view}(1,mk);
            vox(3) = 256- f_{dim}{view}(2,mk);
            if vox(3) == 0
                vox(3) = vox(3) + 1;
            end
        elseif dim == 2
            im = splice(1,view,1,test_volume);
            vox(1) = f_{dim}{view}(1,mk);
            vox(2) = view;
            vox(3) = 256 - f_{dim}{view}(2,mk);
            if vox(3) == 0
                vox(3) = vox(3) + 1;
            end
        elseif dim == 3
            im = splice(1,1,view,test_volume);
            vox(1) = f_{dim}{view}(1,mk);
            vox(2) = f_{dim}{view}(2,mk);
            vox(3) = view;
        end
        
        
            voxels(i,:) = [vox, wsc(i)];
        end
        
        
        %     Weighted Scatter plot great for visualisation
        %     figure;
        %     title(sprintf('Landmark %d Scatter {%d}',lm,length(voxels)));
        %     scatter3(voxels(:,1),voxels(:,2),voxels(:,3),wsc*10000,wsc*10000);
        %
        if size(voxels,1) > 1
            mx = max(voxels);
            fprintf(' -> points under %d = %d\n',sift_dist_thr,size(voxels,1));
        else
            mx = voxels;
        end
        
        matches = voxels;
        
    end
    
end %func end

