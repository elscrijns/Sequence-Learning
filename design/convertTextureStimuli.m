Dir = 'C:\Users\u0105250\Pictures\Texture images\originals ppm\';
files = dir([Dir '*.ppm']);
n = length(files)
ref = imnoise(uint8(zeros(784,1280) + 127), 'gaussian');
%%
for i = 1:n
    
img = imread([Dir files(i).name]);

large = imresize(img, [784 1280], 'bicubic');
grey = rgb2gray(large);
imhist = histeq(grey);
% imhist = imhistmatch(grey, ref);
m(i) = mean2(imhist);
% imshow(grey);

% h = fspecial('average', 15) ;
% filteredIMG = imfilter(grey, h) ;
% imshow(filteredIMG);

name = files(i).name(1:end-4)
imwrite(imhist, [Dir name '.tif'], 'tif');
close
clear img large grey name

end