clc, clear, close

image = imread("user_profile_stock.jpeg");
image_gray = rgb2gray(image);
imshow(image_gray, [], "InitialMagnification", 'fit');

filter = fspecial('average',8); 

smooth = filter2(filter, image_gray);

imshow(smooth, [], "InitialMagnification", 'fit');

hp = image_gray - cast(smooth,"uint8");

imshow(hp, [], "InitialMagnification", 'fit');


%%

clc, clear, close

image = imread("user_profile_stock.jpeg");
image_gray = rgb2gray(image);
imshow(image_gray, [], "InitialMagnification", 'fit');

hp = (1./9).* [-1 -1 -1; -1 8 -1; -1 -1 -1]; 

hp_image = filter2(hp,image_gray); 

imshow(hp_image, [0 70], "InitialMagnification", 'fit');

%%
clc, clear, close

image = imread('steve2.jpg');
image_gray = rgb2gray(image);
imshow(image_gray, [], "InitialMagnification", 'fit');

BW = edge(image_gray, 'canny');

imshow(BW, [0 0], "InitialMagnification", 'fit');

%%
clc, clear, close

image = imread('steve2.jpg');
image_gray = rgb2gray(image);
figure (1)
imshow(image_gray, [], "InitialMagnification", 'fit');

wavelet_type = 'haar';

[a, hd, vd, dd] = dwt2( image_gray, wavelet_type );

figure (2)
imshow(hd, [], 'InitialMagnification', 'fit')   % Detail Horizontal

figure (3)
imshow(dd, [], 'InitialMagnification', 'fit')   % No horizontal or vertical details

diag_image = a -hd -vd;

figure (4)
imshow(diag_image, [], 'InitialMagnification', 'fit')   

BW = edge(diag_image, 'canny');

imshow(BW, [], "InitialMagnification", 'fit');