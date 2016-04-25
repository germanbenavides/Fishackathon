function varargout = video(varargin)
% VIDEO MATLAB code for video.fig
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

% Last Modified by GUIDE v2.5 24-Apr-2016 03:43:37

% Copyright 2011 The MathWorks, Inc.

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
global I
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to video (see VARARGIN)
%ar=arduino('COM7');
% definimos el pin 3 como salida
%ar.pinMode(13,'output');
% Choose default command line output for video
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes video wait for user response (see UIRESUME)
% uiwait(handles.figure1);

movegui(handles.figure1, 'center');

warning('off', 'imaq:peekdata:tooManyFramesRequested');
imaqreset;


% --- Outputs from this function are returned to the command line.
function varargout = video_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartStopBtn.
function StartStopBtn_Callback(hObject, eventdata, handles)
% hObject    handle to StartStopBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject, 'String'), 'Start')
   % create video object
   handles.vid = webcam;
   
   % set timer function
   handles.vid.TimerPeriod = 0.1;
   handles.vid.TimerFcn = {@videoTimerFunction, handles};
   
   % start acquisition
   start(handles.vid);
   
   % change button label
   set(hObject, 'String', 'Stop');
   
   % Update handles structure
   guidata(hObject, handles);
else
   % stop image acquisition
   stop(handles.vid);
   
   % delete video object
   delete(handles.vid);
   
   % clear image
   cla(handles.axes1);
   
   % change button label
   set(hObject, 'String', 'Start');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Timer Function
function videoTimerFunction(vid, eventdata, handles)
global pic
% get a single frame
pic = peekdata(vid,1);

% find ball
thresh = str2double(get(handles.threshEdit, 'String'));
h = get(handles.imageTypeSelection, 'SelectedObject');
imageType = get(h, 'UserData');
findBallFcn(pic, thresh, imageType, handles.axes1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function threshEdit_Callback(hObject, eventdata, handles)
% hObject    handle to threshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshEdit as text
%        str2double(get(hObject,'String')) returns contents of threshEdit as a double


% --- Executes during object creation, after setting all properties.
function threshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in imageTypeSelection.
function imageTypeSelection_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in imageTypeSelection
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('on', 'imaq:peekdata:tooManyFramesRequested');
imaqreset;


% --- Executes on button press in Captura.
function Captura_Callback(hObject, eventdata, handles)

global pic
%     I=greenBall1;
I=pic;
%    I=imcrop(I,bb);
    figure,imshow(I)
    %stop(handles.vid);
% hObject    handle to Captura (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
