% load the image
% picture from http://dazid.net/post/28231461356/horribly-noisy-and-terribly-underexposed-but-i
image = imread('myimage.jpg');
[M,N,S]=size(image);

% lets work in hsv space
image = rgb2hsv(image);

% set up a smoothing filter
H=fspecial('gaussian',[10 10],100);
smoothImage = imfilter(image,H);

% get back to rgb space
rgbImage = hsv2rgb(smoothImage);

% plot the old histograms
figure;
subplot(2,3,1);
imhist(rgbImage(:,:,1));
subplot(2,3,2);
imhist(rgbImage(:,:,2));
subplot(2,3,3);
imhist(rgbImage(:,:,3));

% brighten the image a bit, it is a night sky after all
rgbImage = brighten(rgbImage, .3);

% let's get some more contrast in
% low_high = stretchlim(rgbImage, [.03 .97]);
% rgbImage = imadjust(rgbImage, low_high);

% plot the new histograms
subplot(2,3,4);
imhist(rgbImage(:,:,1));
subplot(2,3,5);
imhist(rgbImage(:,:,2));
subplot(2,3,6);
imhist(rgbImage(:,:,3));

%plot the result!
figure;
subplot(1,2,1);
imshow(hsv2rgb(image));
subplot(1,2,2);
imshow(rgbImage);

imwrite(rgbImage, 'Exercise2_Result.png', 'png')