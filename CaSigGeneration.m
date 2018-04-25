function CaSigGeneration(Path,FilterThreshold)
%%
load([Path,'\process\TempData.mat']);
INFO=imfinfo(File);
t=size(INFO);
raw_intensity=[];
filtered_intensity=[];
for u=1:t(1,1)
    picture=im2double(imread(File,u));
    c=0;
    [~, B]=bwboundaries(L_roi,4);
    intensity1=regionprops(B,picture,'meanintensity');
    for  bb=1:max(max(B))
        raw_intensity(u,c+bb)=intensity1(bb,1).MeanIntensity;
    end
    c=c+max(max(B));
end
%%
raw_intensity=raw_intensity/max(max(raw_intensity));
sig=zeros(t(1,1),c);
for k=1:c
    filtered_intensity(:,k)=smooth(raw_intensity(:,k),FilterThreshold*frame_rate);
    for i=1:t(1,1)-delta
        F0(i,1)=min(filtered_intensity(i:i+delta,k));
    end
    R=(filtered_intensity(delta+1:t(1,1),k)-F0*0.3-mean(F0)*0.7)./F0;
    delta1(1:t(1,1)-delta,1)=0;
    delta2(1:t(1,1)-delta,1)=0;
    for i=1:t(1,1)-delta
        for j=1:i
            delta1(i,1)=R(i-j+1)*exp(-j/(delta/15))+delta1(i,1);
            delta2(i,1)=exp(-j/(delta/15))+delta2(i,1);
        end
    end
    w=delta1./delta2;
    sig(delta+1:end,k)=w;
end
save([Path,'\process\TempData.mat'],'raw_intensity','filtered_intensity','sig','-append');
