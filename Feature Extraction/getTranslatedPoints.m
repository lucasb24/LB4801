function translatedPoints = getTranslatedPoints(points, axis, translation_dist)
% points:      Points to be translated - form xyz points or point cloud 
% axis:           Axis to be translated on 
%                     1 = x-axis; 2 = y-axis; 3 = z-axis.
%
% translation_dist:       Distance to be translated (in voxels)


if ~isa(points,'pointCloud')
    points = pointCloud(points);
end

tx = 0;
ty = 0;
tz = 0;

switch axis
    case 1
        tx = translation_dist;
    case 2
        ty = translation_dist;
    case 3
        tz = translation_dist;
end

%Translation Matrix
T = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; tx,ty,tz, 1];

%Transform point cloud using translation matrix
translatedPoints = pctransform(points,affine3d(T));

% Convert back from point cloud to xyz points
translatedPoints = translatedPoints.Location; 

end
