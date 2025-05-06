% this analysis code takes DL FM data and correlates it with manually
% selected points to EM data

%% Import data
clear
close all
fn_root='/Users/pdahlberg/Desktop/2024_AAV_overlays/lamella_2'; %Path to the folder containing the data
image_0_fn='red_file_name'; % color channel 1 image in .tif format
image_1_fn='green_file_name'; % color channel 2 image in . tif format
image_2_fn='reflected_light_file_name'; % reflected light image in . tif format
image_3_fn='EM_lamella_image'; % low magnification image of the lamella


cd(fn_root)


%% load the data

[image_data_0,bounds_0] = load_image_data(fn_root,image_0_fn,1,1); % load in the files
[image_data_1,bounds_1] = load_image_data(fn_root,image_1_fn,1,1);
[image_data_2,bounds_2] = load_image_data(fn_root,image_2_fn,1,1);
[image_data_3,bounds_3] = load_image_data(fn_root,image_3_fn,1,1);
% [image_data_4,bounds_4] = load_image_data(fn_root,image_4_fn,1);
% [image_data_5,bounds_5] = load_image_data(fn_root,image_5_fn,1);
% [image_data_6,bounds_6] = load_image_data(fn_root,image_6_fn,1);



%% now define control points between successive images
close all

%can uncomment the block below if you need to shift color channels relative
%to eachother. I have not troubleshot this or tried to run it though.
% [pts_010,pts_011] =  cpselect(image_data_0,image_data_1,'Wait',true); % pick points that define the transformation from the first to the second image
% t_concord_01 = fitgeotrans(pts_010,pts_011,'similar');%
% %calculate the transformation
% save('transform_01.mat',"t_concord_01","pts_010","pts_011") % Save the transformation
% load("transform_01.mat");
% REM = imref2d(size(image_data_1));
% image_data_01_registered = imwarp(image_data_0,t_concord_01,'OutputView',REM,'interp','nearest');
% figure, imshowpair(image_data_01_registered,image_data_1,'false','ColorChannels',[1 2 0])


%can uncomment the block below if you need to shift color channels relative
%to reflected light image. I have not troubleshot this or tried to run it though.
% [pts_121,pts_122] =  cpselect(image_data_1,image_data_2,'Wait',true); % pick points that define the transformation from the first to the second image
% t_concord_12 = fitgeotrans(pts_121,pts_122,'similar');%
% %calculate the transformation
% save('transform_12.mat',"t_concord_12","pts_121","pts_122") % Save the transformation
% load("transform_12.mat");
% REM = imref2d(size(image_data_1));
% image_data_12_registered = imwarp(image_data_1,t_concord_12,'OutputView',REM,'interp','nearest');
% figure, imshowpair(image_data_12_registered,image_data_2,'false','ColorChannels',[1 2 0])



[pts_232,pts_233] =  cpselect(image_data_2,image_data_3,'Wait',true); % pick points that define the transformation from the first to the second image
t_concord_23 = fitgeotrans(pts_232,pts_233,'projective');%
%calculate the transformation
save('transform_23.mat',"t_concord_23","pts_232","pts_233") % Save the transformation
load("transform_23.mat");
REM = imref2d(size(image_data_3));
image_data_23_registered = imwarp(image_data_1,t_concord_23,'OutputView',REM,'interp','nearest');
figure, imshowpair(image_data_23_registered,image_data_3,'false','ColorChannels',[1 2 0])


%% complete the registration by multiplying the transformations
%spoof the initial transformations by making them the identiy. If you need
%a shift between color channels or with the white light modify the lines of
%code below appropriately and let me know if you need help. 
t_concord_01=t_concord_23;
t_concord_01.T=[1 0 0; 0 1 0; 0 0 1];
t_concord_12=t_concord_01;


% if in looking at the overlay you feel you need additional shifts you can
% apply that here.
tx=0;
ty=0;
t_concord_01.T=[1 0 0; 0 1 0; tx ty 1]; % add in a shift in x and y


% overlay data for first color channel image_data_03_registered
REM = imref2d(size(image_data_1));
image_data_03_registered = imwarp(image_data_0,t_concord_01,'OutputView',REM,'interp','nearest');
REM = imref2d(size(image_data_2));
image_data_03_registered = imwarp(image_data_03_registered,t_concord_12,'OutputView',REM,'interp','nearest');
REM = imref2d(size(image_data_3));
image_data_03_registered = imwarp(image_data_03_registered,t_concord_23,'OutputView',REM,'interp','nearest');

% overlay data for first color channel image_data_13_registered
REM = imref2d(size(image_data_2));
image_data_13_registered = imwarp(image_data_1,t_concord_12,'OutputView',REM,'interp','nearest');
REM = imref2d(size(image_data_3));
image_data_13_registered = imwarp(image_data_13_registered,t_concord_23,'OutputView',REM,'interp','nearest');


%% produce final overlays

fancy_overlay(image_data_03_registered,image_data_3,1)
fancy_overlay(image_data_13_registered,image_data_3,1)
