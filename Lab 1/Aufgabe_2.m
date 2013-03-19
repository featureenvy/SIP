% load the image
% picture from http://dazid.net/post/28231461356/horribly-noisy-and-terribly-underexposed-but-i
image = imread('myimage.jpg');
[M,N,S]=size(image);
% take an interesting part of it
image = image(500:499+N,1:N,:);

% lets work in hsv space
image = rgb2hsv(image);
imageH = image(:, :, 1);
imageS = image(:, :, 2);
imageV = image(:, :, 3);

% set up a smoothing filter
H=fspecial('gaussian',N,12);
H=H./max(max(H));

% smooth all channels independently
F=fftshift(fft2(imageH));
SpectrumF=log(1+abs(F));
G=H.*F;
smoothImageH = abs(ifft2(ifftshift(G)));

F=fftshift(fft2(imageS));
SpectrumF=log(1+abs(F));
G=H.*F;
smoothImageS = abs(ifft2(ifftshift(G)));

F=fftshift(fft2(imageV));
SpectrumF=log(1+abs(F));
G=H.*F;
smoothImageV = abs(ifft2(ifftshift(G)));

% reassemble the image let's get back into RGB space
smoothImage = cat(3, smoothImageH, smoothImageS, smoothImageV);
rgbImage = hsv2rgb(smoothImage);

figure;
subplot(2,3,1);
imhist(rgbImage(:,:,1));
subplot(2,3,2);
imhist(rgbImage(:,:,2));
subplot(2,3,3);
imhist(rgbImage(:,:,3));

% adjust the colors so they look a lot better
rgbImage = imadjust(rgbImage,[.08 .05 .15; .25 .25 .4]);
% rgbImage = imadjust(rgbImage,[.1 .2 .2; .6 .7 .7]);

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