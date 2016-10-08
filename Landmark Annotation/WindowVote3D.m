
%%
% matches = cell(28,22);
% siftMarks = cell(1,28);
%  errors = cell(1,28);
for n = 2:3
    if ~isempty(nii{n})
%         clc;
        
        tic
        thr = 7;
        fprintf('[%d] Returning interest points - DOG threshold: %d\n',n,thr);
        interestPoints = getInterestPoints(nii{n},thr);
        t = toc;
        fprintf('[%d] Duration:',n);
        disp(duration(0,0,t));
        
        
        sift_mag = 6:9;
        tic
           
        fprintf('[%d] Returning SIFT descriptors of interest points: \nDescriptor Magnitudes: %s\n',n,num2str(sift_mag));
        [feat, desc]  = getSIFTPoints(nii{n}, interestPoints, sift_mag);
        test_struct = create_testStruct(nii{n},feat,desc);

        training_struct = create_trainingStruct(nii,landmarks);
        
        t = toc;
        fprintf('[%d] Duration:',n);
        disp(duration(0,0,t));
        
        
        sift_dist_thr = 80000;%doesnt matter %dynamically found now
        sift_match_thr = 1.2;
        marks = 1:22;
        disp(' ');
        %%
        siftMarks{n} = [];
        errors{n} = [];
        matches{n} = cell(22,1);
        tic
        for lm = marks
            matches{n}{lm} = getSIFTMatches(test_struct,training_struct,sift_mag,sift_dist_thr,sift_match_thr,lm);
            if ~isempty(matches{n}{lm})
                m = matches{n}{lm};
            else
                fprintf('\n[%d] No Matches\n',lm);
                continue;
            end
            %%
            sz = size(test_struct.vol.img);
            search_box = [1, sz(1); 1, sz(2); 1, sz(3)];
            sb = search_box;
            vol_size = size(test_struct.vol.img);
            mat = zeros(vol_size);
            
            for i = 1:size(m,1)
                mat(m(i,1),m(i,2),m(i,3)) =  mat(m(i,1),m(i,2),m(i,3)) + m(i,4);
            end
            
%             [x,y,z]=ind2sub(size(mat),find(mat > 0));
%             s = zeros(length(x),1);
%             for c = 1:length(s)
%                 s(c) = mat(x(c),y(c),z(c));
%             end
%             figure;
%             scatter3(x,y,z,s*1000,s);colorbar;
%             xlabel('Sagittal Plane');ylabel('Coronial Plane');zlabel('Axial Plane');
            
            div = 2;
            boxx = coarse_voting(mat,sb,div);
            
            c_box2 = {};
            for b = 1:2
                if size(boxx,1) >= 4
                    c_box2{b} = coarse_voting(mat,boxx{b,1},3);
                end
            end
            
            s = zeros(4,4);
            for bb = 1:2
                for b = 1:4
                    if size(c_box2{bb},1) >= 4
                        s(bb,b) = fine_voting(mat,c_box2{bb}{b,1},3);
                    end
                end
            end
            
            [x, y] = ind2sub(size(s),find(s == max(max(s))));
            
            for t = 1:length(x) %todo check if all fp maximums are equal
                
                fbb = c_box2{x(t)}{y(t)};
                
                A = mat(fbb(1,1):fbb(1,2),fbb(2,1):fbb(2,2),fbb(3,1):fbb(3,2));
                [i, j, k] = ind2sub(size(A), find(A == max(max(max(A)))));
                
                
                sz = abs(fbb(:,1) - fbb(:,2));
%                 drawCube(fbb(:,1),sz,'k')
                fp = fbb(:,1) + [i;j;k];
                fp = fp -1; %correction
            end
            
            
            siftMarks{n}(lm,:) = fp;
            mm = nii{n}.hdr.dime.pixdim(2:4);
            [v1,v2,err] = compare_landmarks(landmarks,nii,n,siftMarks{n},n,lm);
            ed = training_error(err,mm);
            errors{n}(lm) = ed;
%             title(sprintf('lm %d err %d mm',lm,ed));
            
            voxel(1,:) = v1;
            voxel(2,:) = v2;
            x1 = voxel(1,1);y1 = voxel(1,2);z1 = voxel(1,3);
            x2 = voxel(2,1);y2 = voxel(2,2);z2=voxel(2,3);
            euc_dist = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2);
%             hold on;
%             scatter3(v1(1),v1(2),v1(3),'r','filled');hold on;
%             scatter3(v2(1),v2(2),v2(3),'k','filled');hold on;
%             plot3(voxel(:,1),voxel(:,2),voxel(:,3),'m');
            fprintf('[%d] Manl  found:\t%s\n', lm, num2str(v1));
            fprintf('[%d] Point found:\t%s\n',lm,num2str(v2));
            fprintf('[%d] Error voxel:\t%s \n',lm,num2str(err));
            fprintf('[%d] Error :\t %s \n',lm,num2str(ed));
            %%
            fprintf('[%d] Duration:',lm);
            x = toc;
            disp(duration(0,0,x));
        end
   
%     %% Graph Error vs Landmark
%     % save png as reference for log file
%     
%     fig = figure;
%     bar(errors{n});title(sprintf('kn%d',n));
%     yPos = mean(errors{n});
%     hold on;plot(get(gca,'xlim'), [yPos yPos]);
%     xlabel(yPos);
%     fprintf('\n\nMean Error for landmarks %d\n',yPos);
%     disp('Finished:')
%     disp(datestr(now))
%     diary
%     print(fig, fullfile(pwd,'output',strcat(fn,scrip)), '-dpng')
     end
end
% 
save(strcat(datestr(now, 'yymmddHHMMSS'),'_siftMarks'),'siftMarks');

%  origin = [nii{kn}.hdr.hist.srow_x(4), nii{kn}.hdr.hist.srow_y(4), nii{kn}.hdr.hist.srow_z(4)];
%        pixdim = nii{kn}.hdr.dime.pixdim(2:4);
%        lnii = make_nii(matx{kn}, pixdim, origin, 4);
%        seg_str = sprintf('matlab_marks_knee%d.nii',kn);
%        save_path = fullfile(pwd,'matlab_voxel_nifti_points',seg_str);
%        save_nii(lnii,save_path);

