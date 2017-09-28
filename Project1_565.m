% COMPE565 Homework 1
% October 
% Names: Naomi Navarro
%        Natalie Ortiz
% IDs: 816785535
% email: naomikayn@gmail.com

clear all; 
close all;  %close images
clc;

%%
% Problem 1: Read and display image
img_original = imread('C:\Users\naomi\Pictures\Landscape.jpg');
imshow(img_original);

%%
% Problem 2: Display each RGB value
red = img_original(:,:,1);
green = img_original(:,:,2);
blue = img_original(:,:,3);

a = zeros(size(img_original, 1), size(img_original, 2)); 

red_component = cat(3, red, a, a);     %cat(dim, A, B) concatenate arrays
subplot(2,2,1);
imshow(red_component);
title('Red');

green_component = cat(3, a, green, a);
subplot(2,2,2);
imshow(green_component);
subplot(2,2,3);
title('Green');

blue_component = cat(3, a, a, blue);
imshow(blue_component);
title('Blue');
%%
% Problem 3: Convert image into YCbCr
img_ycbcr = rgb2ycbcr(img_original);
imshow(img_ycbcr);

img_rgb = ycbcr2rgb(img_ycbcr);
imshow(img_rgb);

%%
% Problem 4: Display each band separately
y = img_ycbcr(:,:,1);
%cb =
%cr =



