
clc, clear, close

%img = imread("amadus4.jpeg");
%img = imread('user_profile_stock.jpeg');
img = imread('Amadeus.jpeg');
img = imresize(img, 0.15);
gray = rgb2gray(img);

th = 140;          %amadeus
%th = 100;           %stock image
%th = 120;           %steve 2
inv = 255 - gray;
bw = inv > th;               % binary: figure = 1, background = 0

figure(1)
imshow(bw)
title('Base binary mask');

bw = bwareafilt(bw, 1);      % keep largest white object
bw = imclose(bw, strel('disk', 20));   % close small gaps
bw = bwareafilt(bw, 1);

figure(2)
imshow(bw)
title('Base binary mask');

[h, w] = size(bw);


%fill the figure from up to down
fill_updown = false(h, w);
for c = 1:w
    col = bw(:, c);
    if any(col)
        topIdx = find(col, 1, 'first');
        fill_updown(topIdx:end, c) = true;
    end
end

%fill the image from down to up
fill_downup = false(h, w);
for c = 1:w
    col = bw(:, c);
    if any(col)
        botIdx = find(col, 1, 'last');
        fill_downup(1:botIdx, c) = true;
    end
end

%fill the image from left to right
fill_leftright = false(h, w);
for r = 1:h
    row = bw(r, :);
    if any(row)
        leftIdx = find(row, 1, 'first');
        fill_leftright(r, leftIdx:end) = true;
    end
end

% Fill the image from right to left
fill_rightleft = false(h, w);
for r = 1:h
    row = bw(r, :);
    if any(row)
        rightIdx = find(row, 1, 'last');
        fill_rightleft(r, 1:rightIdx) = true;
    end
end


combined_all = fill_updown & fill_downup & fill_leftright & fill_rightleft;


figure(3);
subplot(2,3,1); imshow(fill_updown); title('Up → Down');
subplot(2,3,2); imshow(fill_downup); title('Down → Up');
subplot(2,3,3); imshow(fill_leftright); title('Left → Right');
subplot(2,3,4); imshow(fill_rightleft); title('Right → Left');
subplot(2,3,5); imshow(combined_all); title('Intersection (All Directions)');

% smoothing and sharpening

filter = fspecial('average',5); 

smooth = filter2(filter, gray);

figure(5)
imshow(smooth, [], "InitialMagnification", 'fit')

img_hp = gray - cast(smooth,"uint8");

sharp = gray + img_hp * 2.;

figure(6)
imshow(sharp, [], "InitialMagnification", 'fit')

final_img = zeros(h,w);
for r = 1:h
    for c = 1:w
        if combined_all(r,c) == 1
            final_img(r,c) = sharp(r,c);
        else
            final_img(r,c) = smooth(r,c);
        end
    end
end


figure(7)
imshow(final_img, [], "InitialMagnification", 'fit')



%% ---------- Optional cleanup ----------
combined_all = imopen(combined_all, strel('disk', 2));
combined_all = imclose(combined_all, strel('disk', 3));
combined_all = bwareafilt(combined_all, 1);

figure(4); imshow(combined_all); title('Final 4-direction silhouette');

%% ---------- Save result ----------
imwrite(combined_all, 'Amadeus_4dir_silhouette.png');
