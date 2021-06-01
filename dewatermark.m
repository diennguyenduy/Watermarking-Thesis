function varargout = dewatermark(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dewatermark_OpeningFcn, ...
    'gui_OutputFcn',  @dewatermark_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function dewatermark_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

global ext_algorithm
ext_algorithm = 'lsb';


function varargout = dewatermark_OutputFcn(~, eventdata, handles)

varargout{1} = handles.output;


function btnextract_Callback(hObject, eventdata, handles)

global ext_algorithm

img = handles.extimage;

if(ext_algorithm=='lsb')
    tic;
    watermark = extract_lsb(img, handles.extkey); %Trích xuất sử dụng khóa
    exttime = toc;
    set(handles.exttime,'String',exttime);
elseif(ext_algorithm=='dct')
    tic;
    origin_image = handles.origin_img;
    watermark = extract_dct(img, origin_image);
    exttime = toc;
    set(handles.exttime,'String',exttime);
elseif(ext_algorithm=='dwt')
    tic;
    origin_image = handles.origin_img;
    watermark = extract_dwt(img, origin_image);
    exttime = toc;
    set(handles.exttime,'String',exttime);
else
    return
end

% Lưu hình ảnh sau khi nhúng thủy vân
save_image('Lưu thủy vân trích xuất được', watermark);

axes(handles.axes3);
imshow(watermark);
title("Thủy vân trích xuất được");

handles.extwatermark = watermark;


% --- Executes on button press in extalgo.
function extalgo_Callback(hObject, eventdata, handles)

global ext_algorithm
ext_algorithm = 'lsb';

% --- Executes on button press in dct_ext_algo.
function dct_ext_algo_Callback(hObject, eventdata, handles)

global ext_algorithm
ext_algorithm = 'dct';

% --- Executes on button press in dwt_ext_algo.
function dwt_ext_algo_Callback(hObject, eventdata, handles)

global ext_algorithm
ext_algorithm = 'dwt';


function figure1_CloseRequestFcn(hObject, eventdata, handles)

clear global ext_algorithm

delete(hObject);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject,~, handles)

global ext_algorithm;
if(ext_algorithm == 'lsb')
    [fname, path] = uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn ảnh đã nhúng thủy vân');
    if fname~=0
        img = imread([path,fname]);
        try
            % For four channel tiff images
            img = img(:,:,1:3);
        catch lasterr
        end
        axes(handles.axes2);
        imshow(img);
        title('Ảnh cần trích xuất')
        handles.extimage = img;
        set(handles.btnextract,'Enable','on')
    else
        warndlg('Please Select the necessary Image File');
    end
elseif(ext_algorithm == 'dwt')
    [fname, path] = uigetfile('*.fits','Chọn ảnh đã nhúng thủy vân');
    if fname~=0
        dwt_wmd = fitsread([path,fname]);
        handles.extimage = dwt_wmd;
        display_img = uint8(dwt_wmd);
        axes(handles.axes2);
        imshow(display_img);
        title('Ảnh cần trích xuất')
        set(handles.btnextract,'Enable','on')
    else
        warndlg('Please Select the necessary Image File');
    end
elseif(ext_algorithm == 'dct')
    [fname, path] = uigetfile('*.fits','Chọn ảnh đã nhúng thủy vân');
    if fname~=0
        dwt_wmd = fitsread([path,fname]);
        handles.extimage = dwt_wmd;
        display_img = dwt_wmd;
        axes(handles.axes2);
        imshow(display_img);
        title('Ảnh cần trích xuất')
        set(handles.btnextract,'Enable','on')
    else
        warndlg('Please Select the necessary Image File');
    end
end
guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject,~, handles)

[fname, path] = uigetfile({'*.txt'},'Chọn file khóa');
if fname~=0
    keyfile = fopen([path, fname], 'r');
    key = fscanf(keyfile, '%d');
    handles.extkey = key;
    set(handles.text13,'String',num2str(key));
    fclose(keyfile);
else
    warndlg('Please Select Key File');
end
guidata(hObject,handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, ~, handles)

[fname, path] = uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn ảnh gốc');
if fname~=0
    origin_img = imread([path,fname]);
    try
        % For four channel tiff images
        origin_img = origin_img(:,:,1:3);
    catch lasterr
    end
    
    axes(handles.axes4);
    imshow(origin_img);
    title('Ảnh gốc')
    handles.origin_img = origin_img;
else
    warndlg('Please Select the necessary Image File');
end
guidata(hObject,handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

axes(handles.axes2); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes3); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes4); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
set(handles.text13,'String','');
set(handles.exttime,'String','');
set(handles.ncc,'String','');
