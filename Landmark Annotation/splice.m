function ret = splice(x,y,z,A)

x = size(A.img,1)-x;
y = size(A.img,3)-y;
z = z;

if (x == 0)
    x = x+1;
elseif (y == 0)
    y = y +1;
end


a=A.img;         % The image of the function A is defined as a.

b=a(x,:,:);      %Here, b is defined as the slice taken at all the points 
                 %where the x values are equal to the user entered x.

c=a(:,y,:);      %Here, c is defined as the slice taken at all the points 
                 %where the y values are equal to the user entered y.

d=a(:,:,z);      %Here, d is defined as the slice taken at all the points 
                 %where the z values are equal to the user entered z.


b=squeeze(b);    %All three must be aqueezed to remove possible 1 unit sides
c=squeeze(c);    %that sould interfere with displaying b, c and d as images.
d=squeeze(d);

b = imrotate(b,90);
c = imrotate(c,90);
d = imrotate(d,90);

b = fliplr(b);
c = fliplr(c);
d = fliplr(d);

ret = cell(1,3);
ret{3} = d;
ret{1} = b;
ret{2} = c;



