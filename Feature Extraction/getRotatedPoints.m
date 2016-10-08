function rotatedPoints = getRotatedPoints(points, origin, rot_axis, angle)
% points:      Points to be rotated - form xyz points or point cloud 
% origin:       Center coordinates to be rotated about
% rot_axis:  Axis to be rotated about 
%                     1 = x-axis; 2 = y-axis; 3 = z-axis.
% angle:        Angle to be rotated by (in degrees)


if ~isa(points,'pointCloud')
    points = pointCloud(points);
end

%Translation Matrix
tx = -1*origin(1);
ty = -1*origin(2);
tz = -1*origin(3);
T = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; tx,ty,tz, 1];


% Rotation Matrix
a = angle;%angle to rotate by
switch rot_axis
    case 1      
        R = [1, 0, 0, 0; 0, cosd(a), -sind(a), 0; 0, sind(a), cosd(a), 0; 0, 0, 0, 1]; %Rx
    case 2   
        R = [cosd(a), 0, -sind(a), 0; 0, 1, 0, 0; sind(a), 0, cosd(a), 0; 0, 0, 0, 1]; %Ry
    case 3   
        R = [cosd(a), sind(a), 0, 0; -sind(a), cosd(a), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1]; %Rz
end
  
%Translate to origin
translatedPoints = pctransform(points,affine3d(T));
%Rotate about Origin
rotatedPoints = pctransform(translatedPoints,affine3d(R));
%Inverse translation
rotatedPoints = pctransform(rotatedPoints,affine3d(inv(T)));

% Convert back from point cloud
rotatedPoints = rotatedPoints.Location; 

end