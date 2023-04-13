%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This program is used to test the Digital Fourier transform (DFT) method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
A=imread('E:\project\qww_to_wu\Wu Shiqian\sequences_0305\Image22.bmp');
[u,v]=size(A);
I=zeros(u/4,v/4);
AA=double(A)/255;
A=imresize(AA,0.25);
figure,imshow(A)
AA=fft2(A,256,256);
F2=fftshift(AA);
figure,imshow(log(abs(F2)), [-1,5]);
