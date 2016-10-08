function feature_array = feature_extraction(training_struct,angles)
%feature extraction
nii = training_struct.nii;
landmarks = training_struct.landmarks;
tic
fa = cell(1,3);

for rot_axis = 1:3
      
    fa{rot_axis} = cell(size(angles,2),1); 
    
    for angle = 1:length(angles)
        
        c = 1; % counter
        fa{rot_axis}{angle} = zeros(693,length(landmarks));%693 is (22*63)/2 -- landmarks * features per landmarks / 2  
        
        for n = 1:length(landmarks)
                
                points = landmarks{n};
                origin = size(nii{n}.img)./2; %point to rotate about - todo consider rotation about other points?
                points = getRotatedPoints(points, origin, rot_axis, angles(angle));
                fa{rot_axis}{angle}(:,c) = getFeatures(points,22);
                c = c+1;
            
        end
        
    end
    
end

feature_array = fa;
toc
end
