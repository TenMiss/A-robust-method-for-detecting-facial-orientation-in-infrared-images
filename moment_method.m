function gama=moment_method(B)

%  input:    argument "B" is a normalized binary image without noise 
%               
%  output:  "countangle" is a row vector contains the angle v

%%%%    Detect the orientation

tic
[h,w]=size(B);
xc1=0; xw=0; yc1=0; a=0; b=0; c=0; 
for i=1:h
    for j=1:w
        xc1=xc1+j*B(i,j);        
        yc1=yc1+i*B(i,j);
    end
end
m=sum(sum(B));
xc=xc1/m;
yc=yc1/m;
for i=1:h
    for j=1:w
        a=a+(j-xc)^2*B(i,j);
        b=b+2*(j-xc)*(i-yc)*B(i,j);
        c=c+(i-yc)^2*B(i,j);        
    end
end
bb=b/(a-c);
gama=-90*atan(bb)/pi;
time=toc;