function [out] = psnr_calculate(img1,img2)

e = mse_calculate(img1,img2);
m = max(max(img1));
out = 10*log((double(m)^2)/e);
end