%% read and prepare the image
% read in the two pictures
foregroundOrigin = imread('Spartaaaaaaaaaaaaaaaaaaaaaaaaaaaa.jpg');
backgroundOrigin = imread('dawn.jpg');

% make sure they both have the same size
[M N S] = size(foregroundOrigin);
backgroundOrigin = imresize(backgroundOrigin, [M N]);

%% Add a grayworld approach
% use the average gray values from the foreground image so the two are
% similar
R=foregroundOrigin(:,:,1);
G=foregroundOrigin(:,:,2);
B=foregroundOrigin(:,:,3);

RR=backgroundOrigin(:,:,1);
GG=backgroundOrigin(:,:,2);
BB=backgroundOrigin(:,:,3);

AvgR=mean(mean(R));
AvgG=mean(mean(G));
AvgB=mean(mean(B));
avgGray=(AvgR+AvgG+AvgB)/3;
outR=(avgGray/(1*AvgR)).*RR;
outG=(avgGray/(1*AvgG)).*GG;
outB=(avgGray/(1*AvgB)).*BB;
backgroundGray=backgroundOrigin;
backgroundGray(:,:,1)=outR;
backgroundGray(:,:,2)=outG;
backgroundGray(:,:,3)=outB;

figure('Name','Grayworld','NumberTitle','off')
subplot(1,2,1);
imshow(backgroundOrigin);
title('Original Background');

subplot(1,2,2);
imshow(backgroundGray);
title('Grayworld changed background');

%% Contrast Stretching
% change the contrast/brightness of the two images so they appear similar
foreground = imadjust(foregroundOrigin, stretchlim(foregroundOrigin));
background = imadjust(backgroundGray, stretchlim(backgroundGray));

figure('Name','Contrast Stretching','NumberTitle','off')
subplot(4,2,1);
imhist(foregroundOrigin(:,:,3));
title('Foreground Blue Channel');

subplot(4,2,2);
imhist(backgroundOrigin(:,:,3));
title('Background Blue Channel');

subplot(4,2,3);
imhist(foregroundOrigin(:,:,1));
title('Foreground Red Channel');

subplot(4,2,4);
imhist(backgroundOrigin(:,:,1));
title('Background Red Channel');

subplot(4,2,5);
imshow(foregroundOrigin);
title('Original Foreground');

subplot(4,2,6);
imshow(foreground);
title('Contrast stretched Foreground');

subplot(4,2,7);
imshow(backgroundGray);
title('Grayworld changed background');

subplot(4,2,8);
imshow(background);
title('Contrast stretched Background');

%% set up the chroma filters
% can't get higher here than .5, else the darker blue parts in the upper left will
% be in the picture
filterBlue=im2bw(foreground(:,:,3),.4);
filterBlueInv=imadjust(double(filterBlue),[0 1],[1 0]);

filterRed=im2bw(foreground(:,:,1),.3);
filterRed = medfilt2(filterRed); % blur a bit to remove some artifacts

filterGreen = im2bw(foreground(:,:,2), .25);
filterGreen = medfilt2(filterGreen);  % blur a bit to remove some artifacts

% combine the three filters
filterCombined = filterBlueInv | filterGreen | filterRed;

% show the result of the filters
figure('Name','Chroma Filters','NumberTitle','off')
subplot(4,2,1);
imhist(foreground(:,:,3));
title('Blue Filter');

subplot(4,2,2);
imshow(filterBlueInv);
title('InvertedBlue Filter');

subplot(4,2,3);
imhist(foreground(:,:,1));
title('Red Filter');

subplot(4,2,4);
imshow(filterRed);
title('Red Filter');

subplot(4,2,5);
imhist(foreground(:,:,2));
title('Green Filter');

subplot(4,2,6);
imshow(filterGreen);
title('Green Filter');

subplot(4,2,7);
imshow(foreground);
title('Original Image');

subplot(4,2,8);
imshow(filterCombined);
title('Combined Filter');

%% calculate the resulting image
final = zeros(M, N, S);
for i=1:M
    for j=1:N
        if(filterCombined(i,j)==0)
            final(i,j,:)=background(i,j,:);
        else
            final(i,j,:)=foreground(i,j,:);
        end
    end
end


figure('Name','Chroma Key','NumberTitle','off')
subplot(2,2,1);
imshow(foregroundOrigin);
title('Foreground Image');

subplot(2,2,2);
imshow(backgroundOrigin);
title('Background Image');

subplot(2,2,3);
imshow(filterCombined);
title('Filter');

subplot(2,2,4);
imshow(uint8(final));
title('Final Image With Chroma Key Applied');