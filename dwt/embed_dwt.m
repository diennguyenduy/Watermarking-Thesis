% Thực hiện nhúng thủy vân sử dụng thuật toán DWT
function [watermarked, time] = embed_dwt(varargin)

%Lấy ảnh gốc và biến đổi
img = varargin{1};
img = double(img);
[p, q, r] = size(img);

%Lấy thủy vân và thực hiện biến đổi
watermark_img = varargin{2};
watermark = imresize(watermark_img,[p/2 q/2]);
watermark = double(watermark);

weight = 0.01; %the weight of watermarking
height = p/4;
width  = q/4;

tic;
for k = 1:r
    [ca,ch,cv,cd] = dwt2(img(:,:,k),'db1');  %Thực hiện biến đổi wavelet mức 1 cho ảnh gốc
    [caa,cha,cva,cda] = dwt2(ca,'db1');      %Chọn dải tần phụ ca và thực hiện biến đổi wavelet mức 2 để thực hiện nhúng thủy vân vào dải này
    y = [caa cha;cva cda];
    %disp(size(y));    %[256 256]
    Temp = y + weight*watermark(:,:,k);
    %disp(size(Temp)); %[256 256]
    for i = 1:height
        for j = 1:width
            ncaa(i,j) = Temp(i,j);
            ncha(i,j) = Temp(i,j+width);
            ncva(i,j) = Temp(i+height,j);
            ncda(i,j) = Temp(i+height,j+height);
        end
    end
    d1 = idwt2(ncaa,ncha,ncva,ncda,'db1');
    watermarked_img(:,:,k) = (idwt2(d1,ch,cv,cd,'db1'));
end
time = toc;

watermarked = uint8(watermarked_img);

filter = {'*.fits';'*.xls';'*.mat';'*.*'};
[file, path] = uiputfile(filter, 'Lưu file giá trị ảnh đã nhúng thủy vân');
save_path = strcat(path,'/',file);
fitswrite(watermarked_img, save_path);

end
