function ROIGeneration(Path,ROIThreshold)
%%
load([Path,'\process\TempData.mat']);
% [ input_yingyong, Centroid_T,L_ann,cell_aera] = ANN_input(Image_ref);
Image=Image_ref;
% Image_1=Image;
Image_0=Image_ref; %outline image
% threshold=0.2;
% load('findcell_net.mat')
% y=sim(net,input_yingyong);
% base=-0.5;
% TR4= y>threshold+base;
% cell_centroid=Centroid_T(:,TR4);
% TR4_notcell=find(y<=threshold+base);
[ patches,L] = CNN_input(Image);
threshold=ROIThreshold;
load('cnn_net.mat')
[~,raw_scores]=classify(net,patches);
base=-0.5;
scores=raw_scores;
scores(:,1)=raw_scores(:,1)+base+threshold;
scores(:,2)=raw_scores(:,2)-base-threshold;
[~,y]=max(scores,[],2);
wrong_num=find(y==1);
L1=L;
L1_original=L1;
for ci=1:length(wrong_num)
    L1(L1==wrong_num(ci))=0;
end
% for ci=1:length(TR4_notcell)
%     L1(L_ann==TR4_notcell(ci))=0;
% end
% imshow(L1)
se2=strel('disk',1);
L_roi=imerode(L1,se2);
%%
L_roi=L1;
[a,b]=size(Image);
Image_rgb=zeros(a,b,3);
% outline_1_original=bwperim(L1_original,8);
outline_1=bwperim(L_roi,8);
% substraction_1=outline_1_original-outline_1;
% substraction_1(substraction_1<0)=0;
Image_0(outline_1==1)=0;
% Image_r=Image_0;
Image_b=Image_0;
% Image_r(substraction_1==1)=1;
Image_b(outline_1==1)=1;
Image_rgb(1:a,1:b,1)=Image_0;
Image_rgb(1:a,1:b,2)=Image_0;
Image_rgb(1:a,1:b,3)=Image_b;
figure
imshow(Image_rgb,[],'border','tight')
imwrite(Image_rgb,File_Cell_Outline);
bw_image=L1;
bw_image(bw_image>1)=1;
[B,L2,~,~] = bwboundaries(bw_image,4);
figure
imshow(Image_average,'border','tight')
hold on
colors=['b' 'g' 'r' 'c' 'm' 'y'];
nn=0;
for k=1:length(B)
    boundary = B{k};
    cidx = mod(k,length(colors))+1;
    plot(boundary(:,2), boundary(:,1), colors(cidx),'LineWidth',1);
    rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));%返回大于或者等于指定表达式的最小整数
    col = boundary(rndRow,2); row = boundary(rndRow,1);
    h = text(col+2, row-2, num2str(L2(row,col)+nn)); %细胞编号及编号坐标
    set(h,'Color',colors(cidx),'FontSize',8);
end
nn=nn+length(B);
hold off
saveas(gca,File_Cell_Number);
save([Pathnew,'\TempData.mat'],'L_roi','-append');