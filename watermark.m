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

function txtinsert_watermark_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider2_Callback(~, ~, ~)

function slider2_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function btn_insertwatermark_Callback(~, ~, handles)

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

% L??u h??nh ???nh sau khi nh??ng th???y v??n
save_image('L??u h??nh ???nh ???? nh??ng th???y v??n', watermarked);

axes(handles.axes2);
imshow(watermarked);
title('???nh sau khi nh??ng')


% --- L???a ch???n thu???t to??n nh??ng th???y v??n
function lsbbutton_Callback(~, ~, ~)
global emb_algorithm;
emb_algorithm = 'lsb';

function dctbutton_Callback(~, ~, ~)
global emb_algorithm;
emb_algorithm = 'dct';

function dwtbutton_Callback(~, ~, ~)
global emb_algorithm;
emb_algorithm = 'dwt';

function btn_insertwatermark_CreateFcn(~, ~, ~)

function rbtext_CreateFcn(~, ~, ~)

function rbimage_CreateFcn(~, ~, ~)

function outputimage_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rbpng_CreateFcn(~, ~, ~)

function outputimage_Callback(~, ~, ~)

function embtime_Callback(~, ~, ~)

% --- Executes during object creation, after setting all properties.
function embtime_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, ~, handles)

[fname, path]=uigetfile('*.png;*.bmp;*.tif;*.jpg','Ch???n ???nh g???c');
if fname~=0
    img = imread([path,fname]);
    try
        img = img(:,:,1:3);
    catch lasterr
    end
    axes(handles.axes1); imshow(img);
    title('???nh g???c')
    handles.sourceimage = img;
    set(handles.btn_insertwatermark,'Enable','on')
else
    warndlg('Please Select the necessary Image File');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function key_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, ~, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, path]=uigetfile('*.png;*.bmp;*.tif;*.jpg','Ch???n th???y v??n');
if fname~=0
    watermark = imread([path,fname]);
    
    try
        watermark = watermark(:,:,1:3);
    catch lasterr
    end
    
    axes(handles.axes3); imshow(watermark);
    title('Th???y v??n')
    handles.watermarkimage = watermark;
else
    warndlg('Please Select the necessary Image File');
end
guidata(hObject,handles);


function figure1_CloseRequestFcn(hObject, ~, ~)

clear global ext_out
clear global w_type
clear global emb_algorithm

delete(hObject);


function secretkey_Callback(~, ~, ~)


% --- Executes during object creation, after setting all properties.
function secretkey_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetstate.
function resetstate_Callback(~, ~, handles)

axes(handles.axes1); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes2); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes3); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
set(handles.secretkey,'String','');
set(handles.embtime,'String','');
set(handles.watermarkedpsnr,'String','');
