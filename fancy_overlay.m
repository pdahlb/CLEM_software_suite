function [] = fancy_overlay(image_1,image_2,alpha_thresh)
%[] = fancy_overlay(image_1,image_2,alpha_thresh) change alpha_thresh to
%change image saturation

image_1=double((image_1-min(image_1(:)))); % remove any offset
image_2=double((image_2-min(image_2(:))));

max_image_1=max(image_1(:));                           % normalize by first taking max
max_image_2=max(image_2(:));   

image_1=uint8((image_1./max_image_1)*255);              % divide by max and make into 8 bit number
image_2=uint8((image_2./max_image_2)*255);  
% make image1 into RGB image with hot heat map (typically fluorescence
% image
color_map_jet=jet(256);
for k=1:3
    for i =1:size(image_1,1)
        for j=1:size(image_1,2)
            image_1_RGB(i,j,k)=color_map_jet(image_1(i,j)+1,k);
        end
    end
    k
end

figure
imagesc(image_2)
colormap('gray')
axis equal
axis off

figure

imagesc(image_2)
colormap('gray')
axis equal
axis off
hold on
h=imshow((image_1_RGB))
alpha=double(image_1)/255;
alpha(find(alpha>alpha_thresh))=alpha_thresh;
set(h,'AlphaData',alpha)
