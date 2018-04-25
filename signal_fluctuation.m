function [Image_average,Image_ref]=signal_fluctuation(File,delta)
%%
File
frame_smooth=0.3;
INFO=imfinfo(File);
t=size(INFO);
a=INFO(1).Height;
b=INFO(1).Width;
stack_num=ceil(t(1,1)/(delta*10));
stack_per=delta*10;
Image_filter=zeros(a,b,stack_num);
im_start=1;
smooth_trace=round(frame_smooth*delta);
if a+b<=1024
    ave=3;
    se1=strel('disk',2);
else
    ave=5;
    se1=strel('disk',2);
end
for stack_round=1:stack_num
    stack_round
    if t(1,1)-im_start>=stack_per
        stack_per=delta*10;
    else
        stack_per=t(1,1)-im_start+1;
    end
    sig=zeros(a,b,stack_per);
    stack=zeros(a,b,stack_per);
    Image_average=zeros(a,b);
    uu=0;
    for u=im_start:im_start+stack_per-1
        uu=uu+1;
        stack(:,:,uu)=im2double(imread(File,u));
        Image_average=Image_average+stack(:,:,uu);
        stack(:,:,uu)=imclose(filter2(fspecial('average',[ave ave]),stack(:,:,uu)),se1);
%         stack(:,:,uu)=imgaussfilt(stack(:,:,uu),3);
    end
    for i=1:a
        for j=1:b
            F=smooth(stack(i,j,:),smooth_trace);
            R=(F(1:stack_per)-min(F));
%             R=(F(1:stack_per));
            sig(i,j,1:end)=R;
        end
    end
    difm=max(sig(:,:,:),[],3);
%     Image_filter(:,:,stack_round)=medfilt2(difm,[0,0]);
    Image_filter(:,:,stack_round)=difm;
    im_start=im_start+stack_per;
end
Image_average=Image_average/t(1,1);
Image_average=imadjust(Image_average,[min(min(Image_average)),max(max(Image_average))],[0,1]);
Image_filter_max=max(Image_filter,[],3);
se2=strel('square',2);
Image_open=imopen(Image_filter_max,se2);
Image_ref=imadjust(Image_open);
% imshow(Image_ref)
% imwrite(Image_ref,File_Reference_Image);