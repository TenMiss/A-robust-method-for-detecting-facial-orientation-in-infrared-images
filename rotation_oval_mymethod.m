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
figure,imshow(A,'truesize')  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Centralized the image
[left,right,A]=bw2sides(A);
%figure,imshow(A,'truesize');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%               Generate an ellipse with rotation angle theta 
theta=30
B=imrotate(A,theta);% B---is the rotated ellipse
%figure,imshow(B,'truesize')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%           Find the contour data and centralized the image B
[nleft,nright,B]=bw2sides(B);
%figure,imshow(B,'truesize');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        Detect the orientation
h=20;
B(end-h:end,:)=[];
figure,imshow(B,'truesize');
% B is the centralizaed images and keep it as original one
alfa=side2rotate(nleft,nright)

if abs(alfa)<=1
    disp('No need to rotate')
    countangle=alfa;
else
    countangle=alfa;
    L=nright(end-h)-nleft(end-h);
    symbol=1;
    ally=[];
    newleft=[];
    newright=[];
    count=1;
    while symbol==1
        BB=imrotate(B,-sum(countangle));
        %figure,imshow(BB,'truesize');
        [newleft,newright,BB]=bw2sides(BB);
        %figure,imshow(BB,'truesize');
        delt=ceil(abs(L*sin(sum(countangle)*pi/180)));
        newleft(end-delt:end)=[];
        newright(end-delt:end)=[];
        % Obtain the rotated binary image
        BB(end-delt:end,:)=[];
        %figure,imshow(BB,'truesize');                       
        beta=side2rotate(newleft,newright);
        countangle=[countangle beta];
        count=count+1;
        %if abs(beta)>abs(countangle(end-1)) | abs(beta)<=1                 
        if abs(beta)<=1
            symbol=0;
            break
        end       
        if count>=10
            symbol=0;
            break
        end             
    end
end   
rotate_value=countangle
alfa=sum(countangle)
BB=imrotate(B,-alfa);
%figure, imshow(BB)
