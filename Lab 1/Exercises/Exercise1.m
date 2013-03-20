% load the image and take the grayscale of it
origImage = imread('palace.jpg');
grayImage = rgb2gray(origImage);
[M,N,S] = size(grayImage);

% get the histogram
% Could have been done with histogram = imhist(grayImage);
histogram = zeros(256, 1);
for col=1:M
    for row=1:N
        histogram(grayImage(col, row)) = histogram(grayImage(col, row)) + 1;
    end
end

% get the cumulative histogram
% Could have been done with cumHisto2 = cumsum(histogram);
cumHisto = zeros(256, 1);
for count=2:size(histogram)
    cumHisto(count) = (histogram(count) + cumHisto(count - 1));
end

% get the first level with pixels and the max levels we want
cumHistoMin = cumHisto(find(cumHisto, 1));
grayLevels = 256;

% build up the new cumulative histogram
hv = zeros(size(cumHisto));
for entry=1:size(cumHisto)
    pixelIntensity = cumHisto(entry);
    hv(entry) = round(((pixelIntensity - cumHistoMin) / ((M * N) - cumHistoMin)) * (grayLevels - 1));
end

% add the new intensity values to the new image
equalImage = zeros(M, N);
for col=1:M
    for row=1:N
        intensityOld = grayImage(col, row);
        equalImage(col, row) = hv(intensityOld);
    end
end

% show your work
subplot(2,2,1);
imshow(grayImage);
subplot(2,2,2);
imhist(grayImage);
subplot(2,2,3);
imshow(equalImage, []);
subplot(2,2,4);
imhist(uint8(equalImage));



imwrite(uint8(equalImage), 'Exercise1_Result.png', 'png')

