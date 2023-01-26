function varargout = program_gui(varargin)
% PROGRAM_GUI MATLAB code for program_gui.fig
%      PROGRAM_GUI, by itself, creates a new PROGRAM_GUI or raises the existing
%      singleton*.
%
%      H = PROGRAM_GUI returns the handle to a new PROGRAM_GUI or the handle to
%      the existing singleton*.
%
%      PROGRAM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROGRAM_GUI.M with the given input arguments.
%
%      PROGRAM_GUI('Property','Value',...) creates a new PROGRAM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before program_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to program_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help program_gui

% Last Modified by GUIDE v2.5 21-Jan-2023 08:35:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @program_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @program_gui_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before program_gui is made visible.
function program_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to program_gui (see VARARGIN)

% Choose default command line output for program_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject,'center');

% UIWAIT makes program_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = program_gui_OutputFcn(hObject, eventdata, handles) 
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

% memanggil menu "browse file"
[nama_file, nama_folder] = uigetfile('*.jpg');
 
% jika ada nama file yang dipilih maka akan mengeksekusi perintah di bawah
% ini
if ~isequal(nama_file,0)
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
    % menampilkan citra rgb pada axes
    axes(handles.axes1)
    imshow(Img)
    title('Citra RGB')
    % menampilkan nama file pada edit text
    set(handles.edit1,'String',nama_file)

    % menyimpan variabel Img pada lokasi handles agar dapat dipanggil oleh
    % pushbutton yang lain
    handles.Img = Img;
    guidata(hObject, handles)
else
    % jika tidak ada nama file yang dipilih maka akan kembali
    return
end
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memanggil variabel Img yang ada di lokasi handles 
Img = handles.Img;

% melakukan konversi citra rgb menjadi citra grayscale
Img_gray = rgb2gray(Img);
%   figure, imshow(Img_gray)
% melakukan konversi citra grayscale menjadi citra biner
bw = im2bw(Img_gray);
%   figure, imshow(bw)
% melakukan operasi komplemen 
bw = imcomplement(bw);
%   figure, imshow(bw)
% melakukan operasi morfologi filling holes
bw = imfill(bw,'holes');
% menampilkan citra biner pada axes
axes(handles.axes2)
imshow(bw)
title('Citra Biner')
    
% menyimpan variabel bw pada lokasi handles agar dapat dipanggil oleh
% pushbutton yang lain
handles.bw = bw;
guidata(hObject, handles)   

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memanggil variabel Img dan bw yang ada di lokasi handles
Img = handles.Img;
bw = handles.bw;

% ekstaksi ciri
% melakukan konversi citra rgb menjadi citra hsv
HSV = rgb2hsv(Img);
%   figure, imshow(HSV)
% mengekstrak komponen h,s, dan v pada citra hsv
H = HSV(:,:,1); % Hue / H
S = HSV(:,:,2); % Saturation
V = HSV(:,:,3); % Value
% mengubah nilai piksel background menjadi nol
H(~bw) = 0;
S(~bw) = 0; 
V(~bw) = 0;
%   figure, imshow(H)
%   figure, imshow(S)
%   figure, imshow(V)
% menghitung nilai rata2 h,s, dan v 
Hue = sum(sum(H))/sum(sum(bw));
Saturation  = sum(sum(S))/sum(sum(bw));
Value = sum(sum(V))/sum(sum(bw));
% menghitung luas objek 
Luas = sum(sum(bw));
% mengisi variabel ciri_uji dengan ciri hasil ekstraksi
ciri_uji(1,1) = Hue;
ciri_uji(1,2) = Saturation;
ciri_uji(1,3) = Value;
ciri_uji(1,4) = Luas;

% menampilkan ciri hasil ekstraksi pada tabel
ciri_tabel = cell(4,2);
ciri_tabel{1,1} = 'Hue';
ciri_tabel{2,1} = 'Saturation';
ciri_tabel{3,1} = 'Value';
ciri_tabel{4,1} = 'Luas';
ciri_tabel{1,2} = num2str(Hue);
ciri_tabel{2,2} = num2str(Saturation);
ciri_tabel{3,2} = num2str(Value);
ciri_tabel{4,2} = num2str(Luas);
set(handles.uitable1,'Data',ciri_tabel,'RowName',1:4)

% menyimpan variabel ciri_uji pada lokasi handles agar dapat dipanggil oleh
% pushbutton yang lain
handles.ciri_uji = ciri_uji;
guidata(hObject, handles)   


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memanggil variabel ciri_uji yang ada di lokasi handles
ciri_uji = handles.ciri_uji;

% memanggil model naive bayes hasil pelatihan 
load Mdl
 
% membaca kelas keluaran hasil dari pengujian 
hasil_uji = predict(Mdl,ciri_uji);

% menampilkan kelas keluaran hasil dari pengujian pada edit teks
set(handles.edit2,'String',hasil_uji{1});

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mereset tampilan GUI
set(handles.edit1,'String',[])
set(handles.edit2,'String',[])

axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

set(handles.uitable1,'Data',[],'RowName',{'' '' '' ''})

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
