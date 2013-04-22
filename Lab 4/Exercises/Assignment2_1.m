% set the size of the filter, feel free to change this.
filterSize = 3;

medianFilterValue = ceil(filterSize / 2);

image = imread('lego.jpg');
image = rgb2gray(image);

% MAKE SOME NOOOOISE!
noisy = imnoise(image, 'salt & pepper');

% add an extended border around the image
% makes handling the border pixels really easy!
filter = zeros(filterSize,filterSize);
filter(medianFilterValue, medianFilterValue) = 1;
noisyWithBorder = imfilter(noisy, filter, 'replicate', 'full');

[M,N] = size(noisy);
restored = zeros(M,N);
% go over all the pixels in the new image
for col=1:M
    for row=1:N

        % extract the neighborhood for our median filter
        filterValues = noisyWithBorder(col:(col + filterSize - 1), row:(row + filterSize - 1));
        
        % have to do some trickery here since median() expects a double
        % vector, not a matrix
        restored(col, row) = median(double(filterValues(:)'));
    end
end

figure('Name','Median Filtering','NumberTitle','off')
subplot(2,2,1);
imshow(image);
title('Original Image');

subplot(2,2,2);
imshow(noisy);
title('Noisy Image');

subplot(2,2,3);
imshow(uint8(restored));
title('Restored Image');

subplot(2,2,4);
imshow(medfilt2(noisy));
title('Restored with medfilt2, for comparison');