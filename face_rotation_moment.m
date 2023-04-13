clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          
%%            This program is used for face detection 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%    Open test image
[filename, pathname] = uigetfile( ...
	{'*.bmp', 'All IMAGE-Files (*.bmp)';'*.mat', 'All MAT-Files (*.mat)'; ...
		'*.*','All Files (*.*)'}, ...
	'Select File');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
	return
end
cd (pathname);
dir_struct = dir(pathname);
%%% dir_struct is a structure which contains four fields:
%%% (1)name, (2)date, (3)bytes and (4) isdir
[sorted_names,sorted_index]=sortrows({dir_struct.name}');
a=[dir_struct.isdir];
a(1:2)=[];
sorted_names(1:2)=[];
[m,n]=size(sorted_names);
cd('E:\MATLABR12\work');
if any(a)==1
    errordlg('Not a valid file, because contain directory',...
        'Open file error')
    return
end
for i=1:m
    [pathstr,name,ext,versn] = fileparts(sorted_names{i});
    % Validate the Image-file
    s={'.bmp','.jpg','hdf','pcx','tiff','xwd'};
    b=strcmp(s,ext);
    if all(b==0) 
        errordlg('Not a valid file, because contain non-image files',...
            'Open file error')
        return
    end    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1=[];
score_record=[];
time_recognition=[];
name_index=[];
wrong_image_number=[];
angle=[];
time=[];
for i=1:m
    
    %% Face detection and normalization     
    hedge=4;  wedge=4;
    theta_bright=0.01; broad=1;  error=4;
    par_noise=10;
    select_file=fullfile(pathname,sorted_names{i});
    A=imread(select_file);
    [height,width]=size(A);
    %figure,imshow(A,'truesize')
    A=preprocessing(A,0.25);
    %figure,imshow(A,'truesize')
    [A,bbg]=ir2bbg(A,[hedge,wedge]);
    [B0,B,theta_bright,broad]=detect_parameters(A,[bbg,theta_bright,broad]);
    %figure,imshow(B0,'truesize')
    %figure,imshow(B,'truesize')
    
    [left0,right0,up,num0,up0,up1,up2]=bw2contour(B0,B,error);  
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  To compensate the error produced in segmentation
    left0=left0+broad;
    up=up+broad;
    CB=zeros(length(left0),max(right0));
    for j=1:length(left0)
        CB(j, left0(j):right0(j))=1.0;
    end   
    CB(:,1:min(left0))=[];
    %figure,imshow(CB,'truesize');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
     
    [left,right,sig]=deshoulder(left0,right0);
    [long,mm]=size(left);
    minleft=min(left);
    maxright=max(right);
    
    B3=zeros(length(left),max(right));
    for j=1:length(left);
        B3(j,left(j):right(j))=1.0;
    end   
    B3(:,1:min(left))=[];
    %figure,imshow(B3,'truesize');
    
    if isempty(up1)
        errordlg('The upper part of face is cut off')
        wrong_image_number=[wrong_image_number i];
        continue
    end       
    if (minleft<=wedge+1)|(maxright>=width-wedge-1)
        errordlg('The side face is cut off')
        wrong_image_number=[wrong_image_number i];
        continue
    end       
    %[dleft,dright]=useful_data(left,right,par_noise);      
    %[dleft,dright]=useful_data(left0,right0,par_noise);
    tic
    alfa=moment_method(CB);
    time1=toc;
    time=[time time1];
    if abs(alfa)<=2
        %disp('No need to rotate')
        alfa=0;
        A(1:up,:)=[];
        A(:,[1:minleft-1 maxright+1:end])=[];     
        angle=[angle alfa];
    else
        %countangle=iterative_rotate(CB,alfa,10)  
        %alfa=sum(countangle);
        angle=[angle alfa];
        A(num0,:)=[];
        A(:,[1:minleft-2*broad-6 maxright+2*broad+6:end])=[];
        A=rotate_pad(A,[alfa,bbg]);
        %figure,imshow(A,'truesize')
        [left,right,A]=ir2face(A,[error bbg theta_bright,broad]); 
        %figure,imshow(A,'truesize')
    end
    A=normalize(A,[80 60]);
    I1=cat(3,I1,A);    
    %figure,imshow(A,'truesize')    
    %keyboard
end
 
 save rotation_moment_data1.mat I1
 %save wu_qian_data_with_rotation.mat I1
 
 for i=1:fix(m/20)
     figure
     for j=1:20      
         IT=I1(:,:,(i-1)*20+1:i*20);
         subplot(4,5,j),imshow(IT(:,:,j))
     end
 end
 