tic
% % %% Load test image - im
% load('matlab_landmarks.mat')
% load('nii_structs.mat')
n1 = 4; % knee subject number /28
subj = sprintf('Asymknee%d_space.nii.gz',n1);
nii{n1} = load_nii(fullfile(pwd,'SPRI_knee_coregistered',subj)); %subject 4 for testing

sz = size(nii{n1}.img);

interestPoints = cell(1,3);
dupe = 0;
for dim = 1:3
    
    
    for view = 1:sz(dim)-1
        
        if dim == 1
            im = splice(view,1,1,nii{n1});
        elseif dim == 2
            im = splice(1,view,1,nii{n1});
        elseif dim == 3
            im = splice(1,1,view,nii{n1});
        end
        imdisp = im{dim};
        im = im{dim};
        
        % Gaussian pyramid
        sigma0 = 0.6;
        k = sqrt(2);
        levels = 1:5;
        lnum = size(levels,2);
        
        im = double(im);
        [h,w] = size(im);
        GaussPyramid = zeros(h,w,lnum);
        
        for  l = 1:lnum
            sigma = sigma0*k^levels(l);
            gaussian = fspecial('Gaussian',floor(3*sigma*2)+1,sigma);
            GaussPyramid(:,:,l) = conv2(im,gaussian,'same');
        end
        
        % DoG pyrgramid
        DogPyramid = zeros(h,w,lnum-1);
        for l = 2:lnum
            DogPyramid(:,:,l-1) = GaussPyramid(:,:,l) - GaussPyramid(:,:,l-1);
        end
        
        % LocalEXTrema
        localFilt = true(3);%3x3 matrix of 1's
        localFilt(5) = 0; %centre element 0
        thr = 6;
        thpc = 8;
        
        for i = 1:size(DogPyramid,3)
            
            impc = DogPyramid(:,:,i);
            [gx, gy] = gradient(impc);
            [gxx, gxy] = gradient(gx);
            [~, gyy] = gradient(gy);
            TraceH = gxx + gyy;
            TraceH2 = TraceH.*TraceH;
            DetH = (gxx.*gyy) - (gxy.*gxy);
            R = TraceH./DetH;
            
            im = DogPyramid(:,:,i);
            imf = ordfilt2(im, 8, localFilt);
            imMask = (im > imf);
            imf = abs(im .* imMask);
            
            prev = zeros(size(im));
            next = zeros(size(im));
            if i > 1
                prev = abs(DogPyramid(:,:,i-1) .*imMask);
            end
            if i < (size(DogPyramid,3))
                next = abs(DogPyramid(:,:,i+1) .*imMask);
            end
            
            maxx =max(max(imf,prev),next);
            imf = imf .* (maxx == imf);
            
            ind = find((abs(imf) > thr) & (abs(impc) < thpc));
            [y, x] = ind2sub(size(imf), ind);
            
            loc = [x, y, repmat(i, size(x,1), 1)];
            if i == 1
                locations = loc;
            else
                locations = [locations; loc];
            end
        end
        
        interestPoints{dim}{view} = locations(:,1:2);
        
        %display
        %     if ((dim == 3)&&(view <97)&&(view>87))
        %         figure(view);
        %         imshow(imdisp,[]);hold on;
        %         locs = locations;
        %         for i = 1:length(interestPoints{dim}{view})
        %             if locs(i,3) == 1
        %                 plot(locs(i,1),locs(i,2),'r.','MarkerSize',10);
        %             end
        %             if locs(i,3) == 2
        %                 plot(locs(i,1),locs(i,2),'b.','MarkerSize',10);
        %             end
        %             if locs(i,3) == 3
        %                 plot(locs(i,1),locs(i,2),'g.','MarkerSize',10);
        %             end
        %             if locs(i,3) == 4
        %                 plot(locs(i,1),locs(i,2),'m.','MarkerSize',10);
        %             end
        %         end
        %
        %         [~, subject] = fileparts(nii{n1}.fileprefix);
        %         tl = strsplit(subject,'_');
        %         title(tl(1));
        %         xlabel(sprintf('slice %d',view));
        %     end
        
        %         % %todo remove duplicates to ultimately speed up processing
        [n,~ ] = hist3(interestPoints{dim}{view},size(imdisp));
        ind = find(n > 1);
        if ~isempty(ind)
            [y, x] = ind2sub(size(imdisp), ind);
            %             fprintf('%d duplicates found\n',length(ind));
            dupe = dupe + length(ind);
        end
        
    end
end

toc




