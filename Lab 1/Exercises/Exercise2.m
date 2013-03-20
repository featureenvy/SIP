% load the image
% picture from http://dazid.net/post/28231461356/horribly-noisy-and-terribly-underexposed-but-i
image = imread('myimage.jpg');
[M,N,S]=size(image);

% set up a smoothing filter
H=fspecial('gaussian',[10 10],100);
smoothImage = imfilter(image,H);

% plot the old histograms
figure;
subplot(2,3,1);
imhist(image(:,:,1));
subplot(2,3,2);
imhist(image(:,:,2));
subplot(2,3,3);
imhist(image(:,:,3));

% lets work in hsv space
smoothImage = rgb2hsv(smoothImage);

% let's get some more contrast in
low_high = stretchlim(smoothImage, [.03 .97]);
low_high(1,1) = 0;
low_high(2,1) = 1;
smoothImage = imadjust(smoothImage, low_high);

% get back to rgb space
rgbImage = hsv2rgb(smoothImage);

rgbImage = imadjust(rgbImage, [0 1], [], .8);

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
% imshow(hsv2rgb(image));
imshow(image);
subplot(1,2,2);
imshow(rgbImage);

imwrite(rgbImage, 'Exercise2_Result.png', 'png')