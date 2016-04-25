function varargout = caras(varargin)
% caras M-file for caras.fig
%      caras, by itself, creates a new caras or raises the existing
%      singleton*.
%
%      H = caras returns the handle to a new caras or the handle to
%      the existing singleton*.
%
%      caras('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in caras.M with the given input arguments.
%
%      caras('Property','Value',...) creates a new caras or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AGENTE_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to caras_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help caras

% Last Modified by GUIDE v2.5 07-Jul-2012 16:40:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @caras_OpeningFcn, ...
                   'gui_OutputFcn',  @caras_OutputFcn, ...
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


% --- Executes just before caras is made visible.
function caras_OpeningFcn(hObject, eventdata, handles, varargin)
global vid
handles.rgb = [];
handles.noback = [];
guidata(hObject, handles);
% This sets up the video camera and starts the preview
% Only do this when it's invisible
if strcmp(get(hObject,'Visible'),'off')
try
vid = videoinput('winvideo',1);
% Update handles structure
vid.ReturnedColorspace = 'rgb';
start(vid);
guidata(hObject, handles);
vidRes = get(vid, 'VideoResolution');
nBands = get(vid, 'NumberOfBands');
hImage = image(zeros(vidRes(2), vidRes(1), nBands), 'Parent',...
handles.axes9);
preview(vid,hImage);
catch
msgbox('NO HAY CÁMARA CONECTADA. Cargando imagen.jpg.')
hImage = image(imread('profile.jpg'), 'Parent',handles.axes1);
axis off;
end
end
% Choose default command line output for video
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes caras wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = caras_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cargar.
function cargar_Callback(hObject, eventdata, handles)
% hObject    handle to cargar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.*'}, 'Elija la Imagen a reconocer');
imagen = imread([pathname,filename]);
axes(handles.axes1);
imshow(imagen);
handles.imagen = imagen;
guidata(hObject, handles);

% --- Executes on button press in reconocer.
function reconocer_Callback(hObject, eventdata, handles)
%%%guidata(hObject, handles);
axes(handles.axes2);
imshow(handles.imagen);
% Preprocesamiento (GCBO) cambia a blanco y negro la imagen
imgGray = rgb2gray(handles.imagen);
bw = im2bw(handles.imagen,graythresh(imgGray));
axes(handles.axes2);
imshow(bw);
%%la ajusta al porte de la imagen
bw2 = ajustarAlTamanioDeLaImagen(bw);
axes(handles.axes3);
imshow(bw2);
%%%guidata(hObject, handles);
% Se extrae caracteristicas importantes o relevantes
charvec = obtenerMatrizDeCaracteristicas(bw2);
axes(handles.axes4);
plotchar(charvec);
% Se procede a realizar el reconocimiento
result = sim(handles.net,charvec);
[val, num] = max(result);
%%La variable num almacena el numero de posicion de salida que representa
%%el caracter en cuestion.

caracteres=['ATÚN            ';'BAGRE           ';'CARPA           ';'ESPADA          ';'PARGO           ';'SALMÓN          ';'SARGO           '];
caracteres=cellstr(caracteres);
set(handles.nivelConfianza, 'string',[num2str(val*100),' %']);
if (val*100 >= 80)%%Si se supera el nivel de confianza se muestra la advertencia
    set(handles.advertencia, 'string',caracteres(num));
else%%caso contario no se muestra
    set(handles.advertencia, 'string','?');
end

function editResult_Callback(hObject, eventdata, handles)
% hObject    handle to editResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResult as text
%        str2double(get(hObject,'String')) returns contents of editResult as a double


% --- Executes during object creation, after setting all properties.
function editResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pbCrop.
function pbCrop_Callback(hObject, eventdata, handles)
% hObject    handle to pbCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in entrenar.
function entrenar_Callback(hObject, eventdata, handles)
% hObject    handle to entrenar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Read the image

 for cnt = 0:27
    imagen = imread(['imagenes/', int2str(cnt), '.jpg']);    
    imgGray = rgb2gray(imagen);
    bw = im2bw(imagen,graythresh(imgGray));
    axes(handles.axes2);
    imshow(bw);
    bw2 = ajustarAlTamanioDeLaImagen(bw);
    axes(handles.axes3);
    imshow(bw2);
    % Se extrae caracteristicas importantes o relevantes
    charvec = obtenerMatrizDeCaracteristicas(bw2);
    axes(handles.axes4);
    %%imprime la intensidad de imagen en todas las zonas
    plotchar(charvec);
    cojuntoDeEntrenamiento(:,cnt+1) = charvec;
 end

%% Se crea los vectores para los patrones y su respectiva salida ()
P = cojuntoDeEntrenamiento(:,1:28);
T = [eye(7) eye(7) eye(7) eye(7)];

%% Creamos y entrenamos la red neuronal
handles.net = crearRedNeuronal(P,T);
guidata(hObject, handles);
%% Testing the Neural Network
%%%%%%%%%%%[a,b]=max(sim(net,Ptest));
%%%%%%%%%%%disp(b);




function nivelConfianza_Callback(hObject, eventdata, handles)
% hObject    handle to nivelConfianza (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nivelConfianza as text
%        str2double(get(hObject,'String')) returns contents of nivelConfianza as a double


% --- Executes during object creation, after setting all properties.
function nivelConfianza_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nivelConfianza (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function advertencia_Callback(hObject, eventdata, handles)
% hObject    handle to advertencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of advertencia as text
%        str2double(get(hObject,'String')) returns contents of advertencia as a double


% --- Executes during object creation, after setting all properties.
function advertencia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to advertencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in captura.
function captura_Callback(hObject, eventdata, handles)
global vid
axes(handles.axes1)
imagen = getsnapshot(vid);
delete(vid); 
image(imagen,'Parent',handles.axes1);
handles.imagen = imagen;
guidata(hObject, handles);
% hObject    handle to captura (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
