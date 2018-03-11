function varargout = interp_ui(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interp_ui_OpeningFcn, ...
                   'gui_OutputFcn',  @interp_ui_OutputFcn, ...
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

function interp_ui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
global interp_list;
interp_list =[];
set(handles.total_time,'String','1122');
set(handles.file_path,'String','');
set(handles.loaded_list,'String',[]);
set(handles.interp_list,'String',[]);
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = interp_ui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function load_button_Callback(hObject, eventdata, handles)
global fileName;
global plot_list;
global loaded_data;
[fileName, pathName] = uigetfile('*.mat','Select recorded state record file');
jointStateList       = load(fileName);
plot_list            = rmfield(jointStateList,'diffID');
loaded_data          = fieldnames(jointStateList);
loaded_data          = loaded_data(2:end,:);
set(handles.file_path,'String',pathName);
set(handles.loaded_list,'String',loaded_data);
set(handles.plot_list1,'String',loaded_data);
set(handles.plot_list2,'String',loaded_data);
guidata(hObject,handles);

function interp_button_Callback(hObject, eventdata, handles)
global fileName;
global plot_list;
global loaded_data;
global interp_list;
%get selected data for interpolation
selected_data_name = get(handles.loaded_list,'String');
selected_data_name = char(selected_data_name(get(handles.loaded_list,'Value')));
selected_data      = load(fileName,selected_data_name);

%Call the interpolate function
%selected_data need convert to array, as function cannot process struct
selected_data        = struct2array(selected_data);
lost_frames          = load(fileName,'diffID');
lost_frames          = struct2array(lost_frames);
interp_data_name     = [selected_data_name,'_interp'];
interp_data          = interpolate(selected_data,lost_frames);
interp_list.(interp_data_name) = interp_data; 
plot_list.(interp_data_name)   = interp_data;
plot_list_name       = fieldnames(plot_list);
plot_list_name       = sort(plot_list_name(2:end,:));

%Update interp_list
set(handles.interp_list,'String',sort(fieldnames(interp_list)));

%Update plot_list for plotting
set(handles.plot_list1,'String',plot_list_name);
set(handles.plot_list2,'String',plot_list_name);
guidata(hObject,handles);

function calc_vel_button_Callback(hObject, eventdata, handles)
global interp_list;
global plot_list;
if isempty(get(handles.interp_list,'String')) || isempty(str2num(get(handles.total_time,'String')))
    errordlg('Interpolate data list or total time of motion is empty!');
else
    selected_data_name = get(handles.interp_list,'String');
    selected_data_name = char(selected_data_name(get(handles.interp_list,'Value')));
    selected_data      = interp_list.(selected_data_name);
    total_time         = str2num(get(handles.total_time,'String'));
    joint_index        = strfind(selected_data_name,'j');
    calc_data_name     = ['vel_',selected_data_name(joint_index:joint_index+2),'_calc_',num2str(total_time)];
    calc_data          = calc_velocity(selected_data,total_time);
    
    interp_list.(calc_data_name) = calc_data;
    plot_list.(calc_data_name)   = calc_data;
    set(handles.interp_list,'String',sort(fieldnames(interp_list)));
    set(handles.plot_list1,'String',sort(fieldnames(plot_list)));
    set(handles.plot_list2,'String',sort(fieldnames(plot_list)));
end

function save_button_Callback(hObject, eventdata, handles)
global interp_list;
if isempty(get(handles.interp_list,'String'));
    errordlg('Your interpolate list is empty!');
else
    [interpFileName,savePathName]=uiputfile('jointStateList_interp.mat','Save interpolate Data')
    save(interpFileName,'interp_list');

end

function remove_button_Callback(hObject, eventdata, handles)
global interp_list;
global plot_list;
selected_data_name = get(handles.interp_list,'String');
selected_data_name = char(selected_data_name(get(handles.interp_list,'Value')));
selected_data      = interp_list.(selected_data_name);
interp_list        =rmfield(interp_list,selected_data_name);
plot_list          =rmfield(plot_list,selected_data_name);
set(handles.interp_list,'String',sort(fieldnames(interp_list)));
set(handles.plot_list1,'String',fieldnames(plot_list));
set(handles.plot_list2,'String',fieldnames(plot_list));
guidata(hObject,handles);

function plot_button1_Callback(hObject, eventdata, handles)
global plot_list;
plot_option        = get(handles.add_plot1,'value');
if plot_option == 1
    set(handles.graph1,'NextPlot','add');
else
   set(handles.graph1,'NextPlot','replace'); 
end
selected_data_name = get(handles.plot_list1,'String');
selected_data_name = char(selected_data_name(get(handles.plot_list1,'Value')));
selected_data      = plot_list.(selected_data_name);
x = linspace(0,length(selected_data)-1,length(selected_data));
axes(handles.graph1)
plot(x,selected_data)

function plot_button2_Callback(hObject, eventdata, handles)
global plot_list;
plot_option        = get(handles.add_plot2,'value');
if plot_option == 1
    set(handles.graph2,'NextPlot','add');
else
   set(handles.graph2,'NextPlot','replace'); 
end
selected_data_name = get(handles.plot_list2,'String');
selected_data_name = char(selected_data_name(get(handles.plot_list2,'Value')));
selected_data      = plot_list.(selected_data_name);
x = linspace(0,length(selected_data)-1,length(selected_data));
axes(handles.graph2)
plot(x,selected_data)

%=========================Display UI======================================%
function loaded_list_Callback(hObject, eventdata, handles)
function loaded_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function interp_list_Callback(hObject, eventdata, handles)
function interp_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_list1_Callback(hObject, eventdata, handles)
function plot_list1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_list2_Callback(hObject, eventdata, handles)
function plot_list2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================Edit text======================================%
function total_time_Callback(hObject, eventdata, handles)
function total_time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file_path_Callback(hObject, eventdata, handles)
function file_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================Checkbox=======================================%
function add_plot1_Callback(hObject, eventdata, handles)

function add_plot2_Callback(hObject, eventdata, handles)
