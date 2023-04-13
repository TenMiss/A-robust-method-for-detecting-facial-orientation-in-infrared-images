%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This program is used to test two rotation methods. It is shown that my 
%  simplied method is better. The available boundary is -40<=theta<=40
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
%                        (x-110).^2/30*30+(y-60).^2/40*40=1
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
[left,right,A]=bw2sides(A);
%figure,imshow(A,'truesize');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%               Generate an ellipse with rotation angle theta 
theta=60;
B=imrotate(A,theta);% B---is the rotated ellipse
%figure,imshow(B,'truesize')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%           Find the contour data and centralized the image B
[nleft,nright,B]=bw2sides(B);
%figure,imshow(B,'truesize');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%          Generate different shape of oval

%%%%%   1. Consider face localization (part of the face may be cut off) 
h=0;
B(end-h:end,:)=[];
%figure,imshow(B,'truesize');

%%%%%   2. Consider segmentation error

%A=zeros(120,160);
%left0(1:20,:)=left0(1:20,:)+12;
%for j=20:100
%    A(j, left0(j-19,2):right0(j-19,2))=1.0;
%end   
%figure,imshow(A,'truesize') 
%B=A;
%theta=20
%B=imrotate(B,theta,'crop');% B---is the rotated ellipse
%figure,imshow(B,'truesize');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        Detect the orientation

tic
alfa=side2rotate(nleft,nright);

if abs(alfa)<=1
    %disp('No need to rotate')
    angle=alfa;
else
    countangle=iterative_rotate(B,alfa,10);
    alfa=sum(countangle)
    angle=alfa;
end
time=toc