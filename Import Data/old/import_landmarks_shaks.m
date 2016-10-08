tic
fol = 'C:\Users\Lucas\Documents\Thesis\SPRI_Knee_coregistered';
cd(fol);
nii = cell(28,1);
marks = cell(28,1);
worldco = cell(28,1);
r = 1;
matx = cell(28,1);

%foreach coregistered knee subject
for kn = 1:28
    
    case_str = sprintf('Asymknee%d_landmarks.csv',kn);
    landmark_dir = fullfile(pwd,'KneeLandmarks','ACL_knee_Lucas',case_str);
      
    fn_knee = sprintf('Asymknee%d_space.nii.gz',kn);
    fp_knee = fullfile(pwd,'KneeLandmarks','ACL_knee_Lucas',fn_knee);
    
    %check if there is landmarks for mri
    if exist(landmark_dir, 'file') && exist(fp_knee, 'file')
        
        nii{kn} = load_nii(fp_knee);
        matx{kn} = zeros(size(nii{kn}.img));
        
        [path, filename, ext] = fileparts(landmark_dir);
        [x,y,z] = importfile(landmark_dir,2, 23);
        for i = 1:length(x)
            worldco{kn}{i} = [x(i), y(i), z(i)];
        end
        
        marks{kn} = cell(22,1);
       %foreach world point convert to voxel and store
       for i = 1:size(x,1)
           world = [x(i), y(i), z(i)];
           
           vox = world2image(world,nii{kn});
           vox = round(vox);
           marks{kn}{i} = vox;
           matx{kn}(vox(1),vox(2),vox(3)) = 1;    
       end
       
%        origin = [nii{kn}.hdr.hist.srow_x(4), nii{kn}.hdr.hist.srow_y(4), nii{kn}.hdr.hist.srow_z(4)];
%        pixdim = nii{kn}.hdr.dime.pixdim(2:4);
%        lnii = make_nii(matx{kn}, pixdim, origin, 4);
%        seg_str = sprintf('matlab_marks_knee%d.nii',kn);
%        save_path = fullfile(pwd,'Matlab_NIFTI_Points',seg_str);
%        save_nii(lnii,save_path);

    end
end

save('matlab_landmarks','marks');
% save('nii_structs','nii');
% save('world_coords','worldco');
toc

%% Display
% h = figure;
% c = 6;
% for lm = 1:22
% vox = marks{c}{lm};
% h = splice(size(nii{c}.img,1)-vox(1),size(nii{c}.img,3)-vox(2),vox(3),nii{c});
% 
% subplot(2,2,2);plot(vox(2),size(nii{c}.img,3)-vox(3),'r.','MarkerSize',20);
% knee_legend = sprintf('Sagittal %d', vox(1));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d',vox(2),size(nii{c}.img,3)-vox(3));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% subplot(2,2,4);plot(vox(1),size(nii{c}.img,3)-vox(3),'r.','MarkerSize',20);
% knee_legend = sprintf('Coronial %d', vox(2));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d', vox(1),size(nii{c}.img,3)-vox(3));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% subplot(2,2,1);plot(vox(1),vox(2),'r.','MarkerSize',20);
% knee_legend = sprintf('Axial %d', vox(3));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d', vox(1),vox(2));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% pause;
% end

