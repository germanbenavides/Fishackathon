function varargout = video(varargin)
% VIDEO M-file for video.fig
%      VIDEO, by itself, creates a new VIDEO or raises the existing
%      singleton*.
%
%      H = VIDEO returns the handle to a new VIDEO or the handle to
%      the existing singleton*.
%
%      VIDEO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEO.M with the given input arguments.
%
%      VIDEO('Property','Value',...) creates a new VIDEO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before video_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to video_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help video

% Last Modified by GUIDE v2.5 21-Jun-2011 14:49:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @video_OpeningFcn, ...
                   'gui_OutputFcn',  @video_OutputFcn, ...
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


% --- Executes just before video is made visible.
function video_OpeningFcn(hObject, eventdata, handles, varargin)
global vid
handles.rgb = [];
handles.noback = [];
guidata(hObject, handles);
% This sets up the video camera and starts the preview
% Only do this when it's invisible
if strcmp(get(hObject,'Visible'),'off')
try
vid = videoinput('winvideo');
% Update handles structure
start(vid);
guidata(hObject, handles);
vidRes = get(vid, 'VideoResolution');
nBands = get(vid, 'NumberOfBands');
vid.ReturnedColorspace = 'rgb';
hImage = image(zeros(vidRes(2), vidRes(1), nBands), 'Parent',...
handles.axes1);
preview(vid,hImage);
catch
msgbox('NO HAY CÁMARA CONECTADA. Cargando imagen.jpg.')
hImage = image(imread('imagen.jpg'), 'Parent',handles.axes1);
end
end
% Choose default command line output for video
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes video wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = video_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in captura.
function captura_Callback(hObject, eventdata, handles)
% hObject    handle to captura (see GCBO)
global vid
axes(handles.axes2)
I = getsnapshot(vid);
delete(vid); 
image(I,'Parent',handles.axes2);
axis off

% --- Executes on button press in guardar.
function guardar_Callback(hObject, eventdata, handles)
rgb = getimage(handles.axes2);
if isempty(rgb), return, end
%guardar como archivo
fileTypes = supportedImageTypes; % Función auxiliar.
[f,p] = uiputfile(fileTypes);
if f==0, return, end
fName = fullfile(p,f);
imwrite(rgb,fName);
msgbox(['Imagen guardada en ' fName]);
%Cambio al directorio donde se ha guardado la imagen (prescindible)
%if ~strcmp(p,pwd)
% cd(p);
%end
function fileTypes = supportedImageTypes
% Función auxiliar: formatos de imágenes.
fileTypes = {'*.jpg','JPEG (*.jpg)';'*.tif','TIFF (*.tif)';...
'*.bmp','Bitmap (*.bmp)';'*.*','All files (*.*)'};
% hObject    handle to guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
