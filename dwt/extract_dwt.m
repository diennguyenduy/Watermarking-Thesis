% Thực hiện trích xuất thủy vân bằng thuật toán DWT
% img: Ảnh gốc ban đầu
% watermarked_img: Ảnh đã chứa thủy vân cần trích xuất
function [recover_watermark] = extract_dwt(varargin)

watermarked_img = varargin{1};

%Lẩy ảnh gốc và thực hiện biến đổi
img = varargin{2};
img = double(img);

[~, ~, r] = size(img); % r: số channel màu của ảnh - (RGB : 3)
weight = 0.01;

for k = 1:r
    [ca,~,~,~] = dwt2(img(:,:,k),'db1'); %Thực hiện biến đổi wavelet mức 1 cho ảnh gốc
    [caa,cha,cva,cda] = dwt2(ca,'db1');     %Chọn dải tần phụ ca và thực hiện biến đổi wavelet mức 2
    y = [caa cha;cva cda];
    
    %Áp dụng phép biến đổi wavelet tương tự cho ảnh chứa thủy vân cần trích xuất
    [w_ca,~,~,~] = dwt2(watermarked_img(:,:,k),'db1');
    [w_caa,w_cha,w_cva,w_cda] = dwt2(w_ca,'db1');
    n1(:,:,k) = [w_caa,w_cha;w_cva,w_cda];
    
    recover(:,:,k) = n1(:,:,k) - y;
    recover(:,:,k) = recover(:,:,k)/weight;
end

recover_watermark = uint8(recover);

end
