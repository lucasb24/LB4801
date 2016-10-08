function [vox1,vox2,e] = compare_landmarks(lmarks,nii,n1,smarks,n2,lm)

vox1 = lmarks{n1}(lm,:);
vox2 = smarks(lm,:);
e = abs(vox1-vox2);

% fprintf('Sift Voxel\t %d\t%d\t%d\n',vox2(1),vox2(2),vox2(3));
% fprintf('Manl Voxel\t %d\t%d\t%d\n',vox1(1),vox1(2),vox1(3));
% fprintf('Error \t\t %d\t%d\t%d\n', e(1),e(2),e(3));
% fprintf('Eucl dist \t%f\n',sqrt((e(1))^2+(e(2))^2+(e(3))^2));
% 
% figure(1);clf;splice_disp(vox1(1),vox1(2),vox1(3),nii{n1});
% %display
% subplot(1,3,1);plot(vox1(2),size(nii{n1}.img,3)-vox1(3),'r.','MarkerSize',20);
% knee_legend = sprintf('Sagittal %d', vox1(1));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d',vox1(2),size(nii{n1}.img,3)-vox1(3));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% subplot(1,3,2);plot(vox1(1),size(nii{n1}.img,3)-vox1(3),'r.','MarkerSize',20);
% knee_legend = sprintf('Coronial %d', vox1(2));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d', vox1(1),size(nii{n1}.img,3)-vox1(3));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% subplot(1,3,3);plot(vox1(1),vox1(2),'r.','MarkerSize',20);
% knee_legend = sprintf('Axial %d', vox1(3));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d', vox1(1),vox1(2));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% [~, nam] = fileparts(nii{n1}.fileprefix);
% tBox = uicontrol('style','text');
% str = nam;
% str = sprintf('%s\n%d%s',str,labels{lm,1},labels{lm,2});
% set(tBox,'String',str);
% set(tBox,'Position',[10,10,200,50])
% 
% figure(2);clf;
% splice_disp(size(nii{n2}.img,1)-vox2(1),size(nii{n2}.img,3)-vox2(2),vox2(3),nii{n2});
% % display
% subplot(1,3,1);plot(vox2(2),size(nii{n2}.img,3)-vox2(3),'r.','MarkerSize',20);
% knee_legend = sprintf('Sagittal %d', vox2(1));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d',vox2(2),size(nii{n2}.img,3)-vox2(3));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% subplot(1,3,2);plot(vox2(1),size(nii{n2}.img,3)-vox2(3),'r.','MarkerSize',20);
% knee_legend = sprintf('Coronial %d', vox2(2));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d', vox2(1),size(nii{n2}.img,3)-vox2(3));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% subplot(1,3,3);plot(vox2(1),vox2(2),'r.','MarkerSize',20);
% knee_legend = sprintf('Axial %d', vox2(3));
% title(knee_legend);
% knee_legend = sprintf('X:%d Y:%d', vox2(1),vox2(2));
% legend(knee_legend, 'Location', 'SouthOutside');hold off;
% 
% [~, nam] = fileparts(nii{n2}.fileprefix);
% tBox = uicontrol('style','text');
% str =nam;
% str = sprintf('%s\n%d%s',str,labels{lm,1},labels{lm,2});
% set(tBox,'String',str);
% set(tBox,'Position',[10,10,200,50])


end


