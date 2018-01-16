function varargout = RobotKinematic(varargin)
% ROBOTKINEMATIC MATLAB code for RobotKinematic.fig
%      ROBOTKINEMATIC, by itself, creates a new ROBOTKINEMATIC or raises the existing
%      singleton*.
%
%      H = ROBOTKINEMATIC returns the handle to a new ROBOTKINEMATIC or the handle to
%      the existing singleton*.
%
%      ROBOTKINEMATIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTKINEMATIC.M with the given input arguments.
%
%      ROBOTKINEMATIC('Property','Value',...) creates a new ROBOTKINEMATIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RobotKinematic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RobotKinematic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RobotKinematic

% Last Modified by GUIDE v2.5 08-Sep-2017 23:11:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RobotKinematic_OpeningFcn, ...
                   'gui_OutputFcn',  @RobotKinematic_OutputFcn, ...
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


% --- Executes just before RobotKinematic is made visible.
function RobotKinematic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data       (see GUIDATA)
% varargin   command line arguments to RobotKinematic   (see VARARGIN)

% Choose default command line output for RobotKinematic
handles.output = hObject;

% Create Maine GUI Controller 
handles.robotGUIMain = RobotGUIMain( handles.robotAxis );

% rotate3d(  findobj( handles , 'Tag', 'robotAxis' )  );

rotate3d on;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RobotKinematic wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = RobotKinematic_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%*************************** Input Callbacks ******************************
%% Callback function for all edit box and sliders
function jointAngle_Callback( hObject, eventdata, handles )
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.robotGUIMain.updateInputAngleForms( hObject, eventdata, handles );

%************************************ JOINT 1 *****************************
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

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set limit value 
set( hObject,'min', -175,'max', +175   );
% set( hObject,'max', 350 );

% Set text in edit box
editHandle = findobj( 'Tag', 'edit1' );
set(editHandle,'String', num2str(0) );

%************************************ JOINT 2 *****************************
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set limit value 
set( hObject,'min', -175,'max', +175   );
% set( hObject,'max', 350 );

% Set text in edit box
editHandle = findobj( 'Tag', 'edit2' );
set(editHandle,'String', num2str(0) );

%************************************ JOINT 3 *****************************
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set limit value 
set( hObject,'min', -175,'max', +175   );
% set( hObject,'max', 350 );

% Set text in edit box
editHandle = findobj( 'Tag', 'edit3' );
set(editHandle,'String', num2str(0) )

%************************************ JOINT 4 *****************************
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% Set limit value 
set( hObject,'min', -170.5,'max', +170.5   );
% set( hObject,'max', 341 );

% Set text in edit box
editHandle = findobj( 'Tag', 'edit4' );
set(editHandle,'String', num2str(0) )


%************************************ JOINT 5 *****************************
% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set limit value 
set( hObject,'min', -170.5,'max', +170.5   );
% set( hObject,'max', 341 );

% Set text in edit box
editHandle = findobj( 'Tag', 'edit5' );
set(editHandle,'String', num2str(0) )

%************************************ JOINT 6 *****************************
% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set limit value 
set( hObject,'min', -175,'max', +175   );
% set( hObject,'max', 350 );

% Set text in edit box
editHandle = findobj( 'Tag', 'edit6' );
set(editHandle,'String', num2str(0) )

%************************************ JOINT 7 *****************************
% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal( get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set limit value 
set( hObject,'min', -270,'max', +270   );
% set( hObject,'max', 540 );

% Set text in edit box
editHandle = findobj( 'Tag', 'edit7' );
set(editHandle,'String', num2str(0) )

% --- Executes on button press in recordButton.
function recordButton_Callback(hObject, eventdata, handles)
% hObject    handle to recordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of recordButton
newValue = hObject.Value;

if newValue
    % Block playback button
    handles.playButton.Enable = 'off';
else
    % Unblock playback button
    handles.playButton.Enable = 'on';
end

% Call record function
handles.robotGUIMain.recordButton( newValue );
    
% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of playButton
newValue = hObject.Value;

if newValue
    % Block playback button
    handles.recordButton.Enable = 'off';  
else
    % Unblock playback button
    handles.recordButton.Enable = 'on';
end   
% Call record function
handles.robotGUIMain.playButton( newValue );


% --- Executes on button press in motionSaveButton.
function motionSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to motionSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.robotGUIMain.saveStatesButton();

% --- Executes on button press in motionLoadButton.
function motionLoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to motionLoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.robotGUIMain.loadStatesButton();


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete( handles.robotGUIMain );


% --- Executes on button press in AxesEditor.
function AxesEditor_Callback(hObject, eventdata, handles)
% hObject    handle to AxesEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
propertyeditor(  findobj( handles , 'Tag', 'robotAxis' )  );
