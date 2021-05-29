function varargout = embed_lsb(varargin)

    key = varargin{3};
    rng(key);	%the seed is any non-negative integer < 2^32
    %rng thay đổi trạng thái của generator giúp việc sinh ra các dãy random trả về cùng 1 kết quả khi có cùng seed (ở đây là key)

    %Lưu khóa vào file key.txt
    keyfile = fopen('key.txt', 'w');
    fprintf(keyfile,'%d',varargin{3});
    fclose(keyfile);

    cover_image = varargin{1};
    [x, y, ~] = size(cover_image);

    watermark = varargin{2};

    if(numel(cover_image)<(numel(watermark)*8))
        x = x/sqrt(8) - 1;
        y = y/sqrt(8) - 1;
        watermark = imresize(watermark, [x y]);
    end

    dim = size(watermark);
    infofile = fopen('watermark_info.txt', 'w');
    fprintf(infofile,'%d\t',dim);
    fclose(infofile);

    if(numel(cover_image)>=(prod(dim)*8)) %Kiểm tra nếu kích thước của ảnh gốc có thể chứa được thủy vân
        im_w = watermark(:);       %Đưa thủy vân về vector 1 chiều (dạng cột)
        im = cover_image(:);       %Đưa ảnh gốc về vector 1 chiều (dạng cột)
        %disp(size(im));    % = [512x512x3 1] = [786432 1]

        x = ones(length(im),1);    %Tạo ra vector 1 chiều cùng kích thước với ảnh cover chỉ chứa số 1
        y = uint8(x*254);          %Tạo ra vector 1 chiều cùng kích thước với ảnh cover chỉ chứa số 254
        im = bitand(im,y);         %Septum 0 to the least significant bits của ảnh gốc

        k = 0;
        len = prod(dim);    %Kích thước của thủy vân cần nhúng

        p = randperm(length(im_w)*8); %Tạo 1 véc-tơ ngẫu nhiên vị trí của các bit ảnh gốc
        %p = randperm(n) trả về 1 véc-tơ các số nguyên từ 1 đến n được sắp xếp 1 cách ngẫu nhiên

        while k < len                       %Xét từng điểm ảnh thứ k của thủy vân
            k = k+1;
            for j = 1:8                     %Xét từng bit thứ j của điểm ảnh k
                index = (k-1)*8 + j;        %Xét 8 pixel một lần trên ảnh gốc (mỗi bit thủy vân nhúng trên 1 pixel ảnh gốc)
                b = bitget(im_w(k),j);      %Lấy bit thứ j của pixel thứ k của thủy vân
                if(b == 1)                  %Nếu bit lấy ra = 1
                    im(p(index)) = bitset(im(p(index)),1); %Set bit ở vị trí thứ 1 (LSB) của pixel đang xét trên ảnh gốc là 1
                end
            end
        end

        [x,y,z] = size(cover_image);
        varargout{1} = reshape(im,x,y,z);
    else
        msgbox('Kích thước của thủy vân quá lớn!');
    end
end
