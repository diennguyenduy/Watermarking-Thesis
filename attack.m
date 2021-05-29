function varargout = attack(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @attack_OpeningFcn, ...
                   'gui_OutputFcn',  @attack_OutputFcn, ...
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
% End initialization code

% --- Executes just before attack is made visible.
function attack_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for attack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using attack.
%if strcmp(get(hObject,'Visible'),'off')
%    wallpaper = imread('default_image.jpg');
%    imshow(wallpaper);
%end

% UIWAIT makes attack wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = attack_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
cla;

popup_sel_index = get(handles.attackmode, 'Value');
switch popup_sel_index
    case 1
        % Gaussian filter
        sigma = 3;
        gaussianimg = handles.img;
        
        GlowPassFilterImageAttacked = imgaussfilt(gaussianimg, sigma);
        
        imshow(GlowPassFilterImageAttacked);
        title('Ảnh đã qua bộ lọc Gaussian');
        imsave;
    case 2
        % Histogram attack
        hisimg = handles.img;
        
        histImageAttacked = histeq(hisimg);
        
        imshow(histImageAttacked);
        title('Ảnh đã được cân bằng histogram');
        imsave;
    case 3
        % Rescale
        h = fspecial('average',[3 3]);
        averageimg = handles.img;

        averageImageAttacked = imfilter(averageimg,h,'replicate');
        
        imshow(averageImageAttacked);
        title('Ảnh đã qua bộ lọc Average');
        imsave;
    case 4
        % Noise
        noiseimg = handles.img;
        
        SaltPepperNoiseImageAttacked = imnoise(noiseimg,'salt & pepper',0.05);
        
        imshow(SaltPepperNoiseImageAttacked);
        title('Ảnh đã thêm nhiễu');
        imsave;
    case 5
        % Motion attack
        h = fspecial('motion',7,4);
        motionimg = handles.img;
        
        motionImageAttacked = imfilter(motionimg,h,'replicate');
        
        imshow(motionImageAttacked);
        title('Ảnh đã bị làm mờ');
        imsave;
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)

file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in attackmode.
function attackmode_Callback(hObject, eventdata, handles)
% hObject    handle to attackmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns attackmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from attackmode


% --- Executes during object creation, after setting all properties.
function attackmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attackmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Gaussian Filter'
                        'Histogram Equalization'
                        'Average Filter'
                        'Noise'
                        'Motion Blur'
                        });

function attackimage_Callback(hObject, eventdata, handles)
% hObject    handle to attackimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of attackimage as text
%        str2double(get(hObject,'String')) returns contents of attackimage as a double


% --- Executes during object creation, after setting all properties.
function attackimage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attackimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

[fname path]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.png'},'Browse Image');
if fname~=0
    img=imread([path,fname]);
    try
        % For four channel tiff images
        img=img(:,:,1:3);
    catch lasterr
        % Do Nothing
    end
    axes(handles.axes1); imshow(img);
    title('Ảnh chưa tấn công')
    handles.img=img;
    set(handles.pushbutton1,'Enable','on')
else
    warndlg('Please Select the necessary Image File');
end
guidata(hObject,handles);



function attparam_Callback(hObject, eventdata, handles)
% hObject    handle to attparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of attparam as text
%        str2double(get(hObject,'String')) returns contents of attparam as a double


% --- Executes during object creation, after setting all properties.
function attparam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
