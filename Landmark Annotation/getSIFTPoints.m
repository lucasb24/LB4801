
function [feat, desc]  = getSIFTPoints(test_vol, interestPoints, sift_mag)
% Calculate SIFT features and descriptors of the interest points for a 3D
% nifti volutme

sz = size(test_vol.img);

f_ = cell(1,3);
d_ = cell(1,3);
for i = 1:size(f_,1)
    f{i} = cell(sz(i),1);
    d{i} = cell(sz(i),1);
end

for dim = 1:3
    for view = 1:sz(dim)-1
        
        if dim == 1
            im = splice(view,1,1,test_vol);
        elseif dim == 2
            im = splice(1,view,1,test_vol);
        elseif dim == 3
            im = splice(1,1,view,test_vol);
        end
        I = single(im{dim});
        
        for mag = sift_mag
        
            % fc = x y mag orientation
            fc = [interestPoints{dim}{view}(:,1)';interestPoints{dim}{view}(:,2)'];
            fc =[fc;mag*ones(1,size(fc,2));zeros(1,size(fc,2))];
            
            
            [f,d] = vl_sift(I, 'frames',fc, 'orientations');
            if mag == sift_mag(1)
                f_{dim}{view} = f;
                d_{dim}{view} = d;
            else
                 f_{dim}{view} = [f_{dim}{view}, f];
                d_{dim}{view} = [d_{dim}{view}, d];
            end
   
        end
        
    end
end
feat = f_;
desc = d_;
end