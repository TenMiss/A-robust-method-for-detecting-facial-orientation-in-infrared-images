%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      This program uses moment method to detect object orientation angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
height=120;
width=160;
A=zeros(120,160);
left0=[];
right0=[];
newleft0=[];
newright0=[];
newleft=[];
newright=[];
ally=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                             Generate an ellipse
%
%                        (x-100).^2/30*30+(y-60).^2/40*40=1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                    Get the original ellipse A
for y=20:100
    x1=round(100-30*sqrt(1-(y-60)*(y-60)/1600));
    x2=round(100+30*sqrt(1-(y-60)*(y-60)/1600));
    left0=[left0;y x1];
    right0=[right0;y x2];
    A(y,x1:x2)=1.0;
end
%figure,imshow(A,'truesize')  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Centralized the image
%[left,right,B]=bw2sides(A);
%figure,imshow(B,'truesize');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%               Generate an ellipse with rotation angle theta 
%theta=30;
%B=imrotate(B,theta);% B---is the rotated ellipse
%figure,imshow(B,'truesize');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%           Find the contour data and centralized the image B
%[newleft,newright,B]=bw2sides(B);
%figure,imshow(B,'truesize');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%          Generate different shape of oval

%%%%%   1. Consider face localization (part of the face may be cut off) 
%h=0;
%B(end-h:end,:)=[];
%figure,imshow(B,'truesize');

%%%%%   2. Consider segmentation error

A=zeros(120,160);
left0(1:20,:)=left0(1:20,:)+12;
for j=20:100
    A(j, left0(j-19,2):right0(j-19,2))=1.0;
end   
%figure,imshow(A,'truesize') 
B=A;
theta=30
B=imrotate(B,theta,'crop');% B---is the rotated ellipse
figure,imshow(B,'truesize');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        Detect the orientation
[h,w]=size(B);
tic
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
gama=-90*atan(bb)/pi
time=toc