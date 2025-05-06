function [ data ] = load_tiff( direct,fname,nfile )
%[ data ] = load_tiff( direct,fname,nfile )
cd(direct)
warning off
frame=1;
for i=1:nfile
    display(['Loading meta data for file ',num2str(i),' of ',num2str(nfile),'...'])
    if i==1
        info = imfinfo(strcat(fname,'.tif'));
    else
        info = imfinfo(strcat(fname,'_X',num2str(i),'.tif'));
    end
    num_images(i) = numel(info);
end
tot_images=sum(num_images);
height=info.Height;
width=info.Width;
data=zeros(tot_images,height,width,'uint16');
for i=1:nfile
    display(['Loading data for file ',num2str(i),' of ',num2str(nfile),'...'])
    if i==1
        tmp_fname=strcat(fname,'.tif');
    else
        tmp_fname=strcat(fname,'_X',num2str(i),'.tif');
    end
    TifLink=Tiff(tmp_fname,'r');
    for k = 1:num_images(i)
        TifLink.setDirectory(k);
        data(frame,:,:) = TifLink.read();
        if sum(k==round(linspace(1,num_images(i),10)))
            disp(['Loading video ',num2str(i),'  ', num2str(round(100*k/num_images(i))),'% done'])
        end
        frame=frame+1;
    end
end


end

