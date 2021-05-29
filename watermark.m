function varargout = watermark(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @watermark_OpeningFcn, ...
                   'gui_OutputFcn',  @watermark_OutputFcn, ...
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

function watermark_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

global emb_algorithm
emb_algorithm = 'lsb';


function varargout = watermark_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

function sourceimage_Callback(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sourceimage_CreateFcn(hObject, eventdata, handles)

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtinsert_watermark_Callback(hObject, eventdata, handles)

function txtinsert_watermark_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider2_Callback(hObject, eventdata, handles)

function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function btn_insertwatermark_Callback(hObject, eventdata, handles)                              

global emb_algorithm;

img = handles.sourceimage;
watermark = handles.watermarkimage;

if(emb_algorithm=='lsb')
    disp(['Algorithm used: ', emb_algorithm]);
    embkey = get(handles.secretkey,'String');
    key = str2num(embkey);
    tic;
    watermarked = embed_lsb(img,watermark,key);
    embtime = toc;
    set(handles.embtime,'String',embtime);
elseif(emb_algorithm=='dct')
    disp(['Algorithm used: ', emb_algorithm]);
    [watermarked, time] = embed_dct(img, watermark);
    embtime = time;
    set(handles.embtime,'String',embtime);
elseif(emb_algorithm=='dwt')
    disp(['Algorithm used: ', emb_algorithm]);
    [watermarked, time] = embed_dwt(img, watermark);
    embtime = time;
    set(handles.embtime,'String',embtime);
else
    return
end

psnr2 = psnr(img, watermarked);
set(handles.watermarkedpsnr, 'String', psnr2);

% Lưu hình ảnh sau khi nhúng thủy vân
save_image('Lưu hình ảnh đã nhúng thủy vân', watermarked);

axes(handles.axes2);
imshow(watermarked);
title('Ảnh sau khi nhúng')


% --- Executes on button press in lsbbutton.
function lsbbutton_Callback(hObject, eventdata, handles)

global emb_algorithm;
emb_algorithm = 'lsb';

% --- Executes on button press in dctbutton.
function dctbutton_Callback(hObject, eventdata, handles)

global emb_algorithm;
emb_algorithm = 'dct';

% --- Executes on button press in dwtbutton.
function dwtbutton_Callback(hObject, eventdata, handles)

global emb_algorithm;
emb_algorithm = 'dwt';

function btn_insertwatermark_CreateFcn(hObject, eventdata, handles)

function rbtext_CreateFcn(hObject, eventdata, handles)

function rbimage_CreateFcn(hObject, eventdata, handles)

function outputimage_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rbpng_CreateFcn(hObject, eventdata, handles)

function outputimage_Callback(hObject, eventdata, handles)

function embtime_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function embtime_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

[fname path]=uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn ảnh gốc');
if fname~=0
    img = imread([path,fname]);
    try
        img = img(:,:,1:3);
    catch lasterr
    end
    axes(handles.axes1); imshow(img);
    title('Ảnh gốc')
    handles.sourceimage = img;
    set(handles.btn_insertwatermark,'Enable','on')
else
    warndlg('Please Select the necessary Image File');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function key_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname path]=uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn thủy vân');
if fname~=0
    watermark = imread([path,fname]);
    
    try
        watermark = watermark(:,:,1:3);
    catch lasterr
    end
    
    axes(handles.axes3); imshow(watermark);
    title('Thủy vân')
    handles.watermarkimage = watermark;
else
    warndlg('Please Select the necessary Image File');
end
guidata(hObject,handles);


function figure1_CloseRequestFcn(hObject, eventdata, handles)

clear global ext_out
clear global w_type
clear global emb_algorithm

delete(hObject);

function secretkey_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function secretkey_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
