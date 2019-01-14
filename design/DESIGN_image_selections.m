%% read in image
clear all
DIR =  'C:\Users\u0105250\Pictures\Texture images\images\';
name1 = 'Bark.0003' ;
img1 = imread([DIR name1 '.tiff']);

name2 = 'Bark.0009' ;
img2 = imread([DIR name2 '.tiff']);

h = histeq(img1(:,:,1));
imshowpair(h,img1(:,:,1), 'montage')

absDiffImage = imabsdiff(img1, img2);

%% calculate image characteristics
DIR =  'C:\Users\u0105250\Pictures\Texture images\originals ppm\histeq\';
files = dir('C:\Users\u0105250\Pictures\Texture images\originals ppm\histeq\*.tif');
l = length({files.name});
ssimval = [];
err = [];
absDiffImage = [];

for i = 1:l
    name1 = files(i).name ;
    img1 = imread([DIR name1]);
    
    for j = 1:l 
        name2 = files(j).name ;
        img2 = imread([DIR name2]);
        
         ssimval(i,j) = ssim(img1(:,:,1), img2(:,:,1));
         err(i,j) = immse(img1(:,:,1), img2(:,:,1));
         absDiffImage(i,j) = mean(mean(imabsdiff(img1(:,:,1), img2(:,:,1))));
    end
    clear name* img*
end

meanSim = mean(ssimval);
meanErr = mean(err);

stims = find(meanSim<0.5 & meanErr > 6000);
files(stims).name