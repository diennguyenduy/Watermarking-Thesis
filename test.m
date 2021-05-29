cover=imresize(imread('dataset/lena.png'),[512 512]);
%rgbimage=rgb2gray(rgbimage);
cover=im2double(cover);
[F1,F2]= wfilters('haar', 'd');
figure;imshow(cover);title('original color image');

[h_LL,h_LH,h_HL,h_HH]=dwt2(cover,'haar', 'd');
[h_LL2,h_LH2,h_HL2,h_HH2]=dwt2(h_LL,'haar', 'd');
 [nRow nCol noDim] = size(h_LL2);
 
water=imresize(imread('dataset/watermark_qr.png'),[nRow nCol]);
%water=rgb2gray(water);
water=im2double(water);
%watermarking
 newhost_LL = h_LL2 +0.5*water;
 %output
 hasil1=idwt2(newhost_LL,h_LH2,h_HL2,h_HH2,'haar', 'd');
hasil1=idwt2(hasil1,h_LH,h_HL,h_HH,'haar', 'd');
 figure;imshow(hasil1);title('Watermarked image');
imwrite(hasil1,'Watermarked.bmp','bmp');
 %extracted
watermarked=imread('watermarked.bmp');
watermarked=im2double(watermarked);
[wm_LL,wm_LH,wm_HL,wm_HH]=dwt2(watermarked,'haar', 'd');
[wm_LL2,wm_LH2,wm_HL2,wm_HH2]=dwt2(wm_LL,'haar', 'd');
 newwatermark_LL= (wm_LL2-h_LL2)/0.1;
 figure;imshow(newwatermark_LL);title('Extracted watermark');
 %imwrite(newwatermark_LL,'EeweWatermark.bmp');