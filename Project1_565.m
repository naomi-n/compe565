% COMPE565 Homework 1
% October 2, 2017
% Names: Naomi Navarro
%        Natalie Ortiz

clear all; 
close all;  %close images
clc;

%%
% Problem 1: Read and display image
figure(1);
img_original = imread('C:\Users\nrnavarro\Pictures\Landscape.jpg');
imshow(img_original);
title('Original image');

%%
% Problem 2: Display each RGB value
red = img_original(:,:,1);
green = img_original(:,:,2);
blue = img_original(:,:,3);

%Get the size dimensions of the image
a = zeros(size(img_original, 1), size(img_original, 2)); 

figure(2);
red_component = cat(3, red, a, a);     %cat(dim, A, B) concatenate arrays
subplot(2,2,1);
imshow(red_component);
title('Red');

green_component = cat(3, a, green, a);
subplot(2,2,2);
imshow(green_component);
title('Green');

blue_component = cat(3, a, a, blue);
subplot(2,2,3);
imshow(blue_component);
title('Blue');

%%
% Problem 3: Convert image into YCbCr
figure(3);
img_YCbCr = rgb2ycbcr(img_original);
imshow(img_YCbCr);
title('YCbCr');

%%
% Problem 4: Display each YCbCr band separately
Y = img_YCbCr(:,:,1);
Cb = img_YCbCr(:,:,2);
Cr = img_YCbCr(:,:,3);

figure(4);
subplot(2,2,1);
imshow(Y);
title('Y');

subplot(2,2,2);
imshow(Cb);
title('Cb');

subplot(2,2,3);
imshow(Cr);
title('Cr');

%%
% Problem 5: Subsample Cb and Cr bands using 4:2:0 and display both bands

%4:2:0 - Every two pixels on a row share a chroma sample and the row below
%it has no color information
Cb_420 = Cb(1:2:end,1:2:end);
Cr_420 = Cr(1:2:end,1:2:end);

subplot(1,2,1);
imshow(Cb_420);
title('4:2:0 Cb');

subplot(1,2,2);
imshow(Cr_420);
title('4:2:0 Cr');

%%
%Problem 6: Upsampling
%6.1. Linear interpolation
Cb_lin = Cb;
[Num_rows_Cbl, Num_cols_Cbl] = size(Cb_lin);

for Row = 1:Num_rows_Cbl
     for Col = 1:Num_cols_Cbl
         row_Cb = Row;
         col_Cb = Col;
         
         if(mod(row_Cb,2) == 1 && mod(col_Cb,2)==0 && col_Cb ~= Num_cols_Cbl) %odd row and even column
             Cb_lin(row_Cb, col_Cb) = (Cb(row_Cb, (col_Cb-1)) + Cb(row_Cb, (col_Cb+1))/2);
         end
     end
end

for Row = 1:Num_rows_Cbl
     for Col = 1:Num_cols_Cbl
         row_Cb = Row;
         col_Cb = Col;
         
         if (mod(row_Cb,2) == 0 && row_Cb ~= Num_rows_Cbl)
            Cb_lin(row_Cb, col_Cb)=(Cb((row_Cb-1), col_Cb) + Cb((row_Cb+1), col_Cb)/2);
         end
     end
end

Cr_lin = Cr;
[Num_rows_Crl, Num_cols_Crl] = size(Cr_lin);
for Row = 1:1:Num_rows_Crl
     for Col = 1:1:Num_cols_Crl
         row_Cr = Row;
         col_Cr = Col;
         
         if(mod(row_Cr,2)==1&&mod(col_Cr,2)==0 && col_Cr ~= Num_cols_Crl)%odd row and even column
             Cr_lin(row_Cr, col_Cr)=(Cb(row_Cr, (col_Cr-1)) + Cr(row_Cr, (col_Cr+1))/2);
         end
     end
end

for Row = 1:1:Num_rows_Crl
     for Col = 1:1:Num_cols_Crl
         row_Cr = Row;
         col_Cr = Col;
         
         if (mod(row_Cr,2)==0 && row_Cr ~= Num_rows_Crl)
            Cr_lin(row_Cr, col_Cr)=(Cr((row_Cr-1), col_Cr) + Cr((row_Cr+1), col_Cr)/2);
         end
     end
end

figure(6);
subplot(1,2,1);
imshow(Cb_lin);
title('Cb Linear Interpolation');

subplot(1,2,2);
imshow(Cr_lin);
title('Cr Linear Interpolation');

figure(7);
upsample_lin = cat(3, Y, Cb_lin, Cr_lin);

imshow(ycbcr2rgb(upsample_lin));
title('Linear Interpolation');

%% 
% Problem 6.2: Row Replication

Cb_rep = Cb;
[Num_rows_Cb, Num_cols_Cb] = size(Cb_rep);
for Row = 1:Num_rows_Cb
     for Col = 1:Num_cols_Cb
         row_Cb = Row;
         col_Cb = Col;
         
         if (mod(row_Cb,2) == 0) && (mod(col_Cb,2) == 0) %even row, even column
            Cb_rep(row_Cb, col_Cb) = Cb((row_Cb - 1), (col_Cb - 1)); %make that equal           
         end
     end
end

Cr_rep = Cr;
[Num_rows_Cr, Num_cols_Cr] = size(Cr_rep);
for Row = 1:Num_rows_Cr
     for Col = 1:Num_cols_Cr
         row_Cr = Row;
         col_Cr = Col;
         
         if (mod(row_Cr,2) == 0) && (mod(col_Cr,2) == 0)
            Cr_rep(row_Cr, col_Cr) = Cr((row_Cr -1), (col_Cr-1)); 
         end
     end
end

figure(8);
subplot(1,2,1);
imshow(Cb_rep);
title('Cb Row Replication');

subplot(1,2,2);
imshow(Cr_rep);
title('Cr Row Replication');

figure(9);
upsample_rep = cat(3, Y, Cb_rep, Cr_rep);
imshow(ycbcr2rgb(upsample_rep));
title('Row Replication');

%% 
% Problem 10: Measure MSE between the original and reconstructed images

[rows, cols] = size(img_original);

squaredErrorImage = (double(img_original) - double(upsample_lin)) .^ 2;
MSE = sum(sum(squaredErrorImage)) / (rows * cols);

fprintf('MSE for YCbCr respectively:\n');
fprintf('%.2f\n', MSE);


%% 
% Problem 11: Comment on the compression ratio achieved by subsampling Cb and Cr
% components for 4:2:0 approach.

original = size(Y,1) * size(Y,2) * 3;

Cb_420 = Cb(2:2:end, 2:2:end); %even columns, even rows
Cr_420 = Cr(2:2:end, 2:2:end);

reconstructed = size(Y,1) * size(Y,2) +  size(Cb_420,1) * size(Cb_420,2) + size(Cr_420,1) * size(Cr_420,2);

Compression_Ratio = original/reconstructed;

fprintf('Compression ratio: %f\n', Compression_Ratio);
