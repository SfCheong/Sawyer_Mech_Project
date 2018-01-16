function varargout = interpolate_ui(varargin)
% INTERPOLATE_UI MATLAB code for interpolate_ui.fig
%      INTERPOLATE_UI, by itself, creates a new INTERPOLATE_UI or raises the existing
%      singleton*.
%
%      H = INTERPOLATE_UI returns the handle to a new INTERPOLATE_UI or the handle to
%      the existing singleton*.
%
%      INTERPOLATE_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERPOLATE_UI.M with the given input arguments.
%
%      INTERPOLATE_UI('Property','Value',...) creates a new INTERPOLATE_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interpolate_ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interpolate_ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interpolate_ui

% Last Modified by GUIDE v2.5 15-Dec-2017 13:42:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interpolate_ui_OpeningFcn, ...
                   'gui_OutputFcn',  @interpolate_ui_OutputFcn, ...
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


% --- Executes just before interpolate_ui is made visible.
function interpolate_ui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function varargout = interpolate_ui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function load_button_Callback(hObject, eventdata, handles)
%make fileName as global variable so that it can use throughout the program
global fileName;
[fileName, pathName] = uigetfile('*.mat','Select recorded state record file');
jointStateList       = load(fileName);
recorded_data        = fieldnames(jointStateList);
assignin('base','jointStateList',jointStateList)
set(handles.file_path,'String',pathName);
set(handles.recorded_data,'String',recorded_data);
guidata(hObject,handles);
assignin('base','fileName',fileName)

function append_data_Callback(hObject, eventdata, handles)
%get the name of popup-menu's selection
struct_list      = get(handles.recorded_data,'String');
selected_struct  = struct_list{get(handles.recorded_data,'Value')};
global fileName;
%load selected data in popuo-menu
appended_data    = load(fileName,selected_struct);

%Update Listbox with appended data and sort it alphabetically
data_list        = get(handles.data_list,'String');
new_data_list    = [cellstr(data_list); cellstr(selected_struct)];
new_data_list    = sort(new_data_list);
%Todo: If repeated data append, dialogue appear to ask about replace or
%rename
set(handles.data_list,'String',new_data_list);
default_up_limit = struct2array(appended_data);
default_up_limit = length(default_up_limit);
set(handles.low_limit,'String','0');
set(handles.up_limit,'String',default_up_limit);

function data_list_Callback(hObject, eventdata, handles)
function data_list_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function interpolate_button_Callback(hObject, eventdata, handles)
global fileName;
%Load array of selected data in data list
appended_data_list   = get(handles.data_list,'String');
selected_data_name   = appended_data_list(get(handles.data_list,'Value'));
selected_data_name   = char(selected_data_name);
selected_data        = load(fileName,selected_data_name);

%Call the interpolate function
%selected_data need convert to array, as function cannot process struct
selected_data        = struct2array(selected_data);
lost_frames          = load(fileName,'diffID');
lost_frames          =struct2array(lost_frames);
interp_data          = interpolate(selected_data,lost_frames);

%Update data list with newly interpolated data
interp_data_name = [selected_data_name,'_interpolate'];
data_list        = get(handles.data_list,'String');
new_data_list    = sort([cellstr(data_list); interp_data_name]);
set(handles.data_list,'String',new_data_list);
assignin('base','selected_data_name',selected_data_name)
assignin('base',selected_data_name,selected_data)
assignin('base','interp_data_name',interp_data_name)
assignin('base',interp_data_name,interp_data)

%save interpolated data in seperate .mat file
if exist('interpolate_data_list.mat', 'file') == 0
    evalin('base','save(''interpolate_data_list.mat'',selected_data_name,interp_data_name)')
else
evalin('base','save(''interpolate_data_list.mat'',selected_data_name,interp_data_name,''-append'')')
end


function recorded_data_Callback(hObject, eventdata, handles)
function recorded_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_button_Callback(hObject, eventdata, handles)
global fileName;
%Load array of selected data in data list
appended_data_list   = get(handles.data_list,'String');
selected_data_name   = appended_data_list(get(handles.data_list,'Value'));
selected_data_name   = char(selected_data_name);
selected_data        = struct2array(load('interpolate_data_list.mat',selected_data_name));
x = linspace(0,length(selected_data)-1,length(selected_data));
plot(x,selected_data)
%Update x-axis
upper_limit = get(handles.up_limit,'String');
lower_limit = get(handles.low_limit,'String');
if isempty(str2num(upper_limit))
upper_limit = length(selected_data);
end
if isempty(str2num(lower_limit))
lower_limit = 0;
end
upper_limit = str2num(upper_limit);
lower_limit = str2num(lower_limit);
xlim([lower_limit upper_limit])
grid on

function up_limit_Callback(hObject, eventdata, handles)
upper_limit = get(handles.up_limit,'String');
if isempty(str2num(upper_limit))
    set(handles.up_limit,'String','0')
    warndlg('axis limit must be nuremic value.');
end

function up_limit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function low_limit_Callback(hObject, eventdata, handles)
lower_limit = get(handles.low_limit,'String');
if isempty(str2num(lower_limit))
    set(handles.up_limit,'String','0')
    warndlg('axis limit must be nuremic value.');
end

function low_limit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
