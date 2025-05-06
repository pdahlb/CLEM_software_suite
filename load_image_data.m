function [image_data,bounds] = load_image_data(file_path,file_name,expansion,istif)
% [image_data,bounds] = load_image_data(file_path,file_name,expansion,istif)
%loads in the imaging data the "expansion" argument can expand the image
% with no interpolation or low pass filters the image if "expand" is less
% than 1, the "istif" argument just checks if the file is tif and if not it
% assumes MRC since that is what we work with. 

if istif==1

image_data=single(load_tiff(file_path,file_name,1));
if size(image_data,1)>1
    image_data=squeeze(mean(image_data));
else
    image_data=squeeze(image_data);
end

else
    image_data=ReadMRC(file_name);
end
image_data=double(image_data);

H=histogram(image_data(:));% threshold image
foo=sort(H.Values);
ylim([0 foo(end-2)]);
title('Select Min and Max range to make holes most visible (typically around peak)')

[bounds,y]=ginput(2); 
bounds=sort(bounds);
image_data(find(image_data(:)>bounds(2)))=bounds(2);
image_data(find(image_data(:)<bounds(1)))=bounds(1);

if expansion>1% expand image
    image_data=imresize(image_data,expansion,'nearest');
elseif expansion<1
    image_data=imresize(image_data,expansion);%conv2(image_data,ones(round(1/expansion),round(1/expansion)),'same');
end


image_data=image_data-min(image_data(:)); % repackage as uint8
image_data=image_data/max(image_data(:));
image_data=image_data*255;
image_data=uint8(image_data);

end