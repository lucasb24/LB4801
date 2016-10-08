tic
fol = 'C:\Users\Lucas\Documents\Thesis\SPRI_Knee_coregistered';
cd(fol);
nii = cell(28,1);
landmarks = cell(28,1);
matx = cell(28,1);
training_subjects = cell(28,1);

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
        filename = strsplit(filename,'_');
        disp(filename);
        training_subjects{kn} = char(filename(1)); 
        [x,y,z] = importfile(landmark_dir,2, 23);
        for i = 1:length(x)
            landmarks{kn}(i,:) = [x(i)+1, y(i)+1, z(i)+1];
            matx{kn}(x(i),y(i),z(i)) = 1;
        end
        
        
       %Save a nifti for viewing in ITK SNAP
       origin = [nii{kn}.hdr.hist.srow_x(4), nii{kn}.hdr.hist.srow_y(4), nii{kn}.hdr.hist.srow_z(4)];
       pixdim = nii{kn}.hdr.dime.pixdim(2:4);
       lnii = make_nii(matx{kn}, pixdim, origin, 4);
       seg_str = sprintf('matlab_marks_knee%d.nii',kn);
       save_path = fullfile(pwd,'matlab_voxel_nifti_points',seg_str);
       save_nii(lnii,save_path);

    end
end

% save('matlab_landmarks','landmarks');
% save('nii_structs','nii');
% save('world_coords','worldco');
toc



