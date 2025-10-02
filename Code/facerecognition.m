% Input
imgPath = 'BridgeHDR_GooglePixel6_DxOMark_Selfie_05-00.jpg';

I0 = im2double(imread(imgPath));
scale = 0.3;
I0 = imresize(I0, scale, 'bicubic', 'Antialiasing', true);
if size(I0,3) == 1, I0 = repmat(I0,[1 1 3]); 
end
G  = rgb2gray(I0);

BW = G <= 0.55;
%BW = bwareaopen(BW, 50);
BW_filled = imfill(BW, 'holes');
keepLargest  = true;
if keepLargest
    BW_filled = bwareafilt(BW_filled, 1);  % keep largest region
end

E = edge(BW_filled, 'Canny', [0.05 0.20], 2.0);

E_thick = imdilate(E, strel('disk', 2));

smooth_area = imfill(E_thick,"holes")==0;
sharp_area = ~smooth_area;


I_sharp = imsharpen(I0, 'Radius', 2, 'Amount', 2);

I_out_hard = I0;
for c = 1:size(I0,3)
    channel = I0(:,:,c);
    ch_sharp = I_sharp(:,:,c);
    channel(sharp_area) = ch_sharp(sharp_area);
    I_out_hard(:,:,c) = channel;
end

filter = fspecial('average', 4);
I_smooth = imfilter(I0, filter, 'replicate');

I_out = zeros(size(I0));
for c = 1:size(I0,3)
    I_out(:,:,c) = I_smooth(:,:,c).*(~sharp_area) + I_sharp(:,:,c).*sharp_area;
end

figure; imshow(I_out); title('Sharpened Foreground + Smoothed Background');
figure;
imshow(sharp_area)

