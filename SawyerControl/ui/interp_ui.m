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
set(handles.total_time,'String','60');
set(handles.file_path,'String','');
set(handles.interp_point,'String','2');
set(handles.loaded_list,'String',[]);
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = interp_ui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function load_button_Callback(hObject, eventdata, handles)
global fileName;
global plot_list;
global loaded_data;
global oriDataSize;
global oriFieldSize;
global traj;
[fileName, pathName] = uigetfile('*.mat','Select recorded state record file');
jointStateList       = load(fileName);
traj                 = Sawyer.Trajectory(fileName,jointStateList)
traj.JointStateList  = traj.JointStateList.jointStateList;
p=1;
loaded_data  = fieldnames(traj.JointStateList);
oriFieldSize = numel(loaded_data);
plot_list    = '';
while p <= numel(fieldnames(traj.JointStateList))
    i=1; 
    fn               = fieldnames(traj.JointStateList);
    strName          = char(fn(p));
    indexJoint       = size(traj.JointStateList.(strName),1);
    while i <= indexJoint
        tempName             = ([strName '_j0' num2str(i)]);
        plot_list.(tempName) = traj.JointStateList.(strName)(i,:);
        i=i+1;
    end
    p=p+1;
end
oriDataSize  = numel(fieldnames(plot_list));
set(handles.file_path,'String',pathName);
set(handles.loaded_list,'String',loaded_data);
set(handles.plot_list1,'String',fieldnames(plot_list));
set(handles.plot_list2,'String',fieldnames(plot_list));
guidata(hObject,handles);

function interp_button_Callback(hObject, eventdata, handles)
global plot_list;
global oriDataSize;
global oriFieldSize;
global traj;
selected    = get(handles.interp_button_group,'SelectedObject');
selected    = selected.String;
if strcmp (selected,'lost_id')  
    traj.calc_lostframes();
else
    point = get(handles.interp_point,'string');
    traj.setLostFrames(str2num(point));
end
p        = 1;
while p <= oriDataSize
        fn                     = fieldnames(plot_list);
        strName                = char(fn(p));
        selected_data          = plot_list.(strName);
        interp_data            = interpolate(selected_data,double(traj.lostframes));
        tempName               = [strName '_interp'];
        plot_list.(tempName)   = interp_data;
        traj.JointStateList.(tempName) = interp_data;
        p=p+1;
end
temp = 'JointStateList';
if isfield(traj.JointStateList,'position_j07_interp')
    traj.JointStateList.position_interp=[traj.JointStateList.position_j01_interp;traj.JointStateList.position_j02_interp;traj.JointStateList.position_j03_interp;traj.JointStateList.position_j04_interp;];
    traj.JointStateList.position_interp=[traj.JointStateList.position_interp;traj.JointStateList.position_j05_interp;traj.JointStateList.position_j06_interp;traj.JointStateList.position_j07_interp;];
    traj.(temp) = rmfield(traj.(temp),'position_j01_interp');
    traj.(temp) = rmfield(traj.(temp),'position_j02_interp');
    traj.(temp) = rmfield(traj.(temp),'position_j03_interp');
    traj.(temp) = rmfield(traj.(temp),'position_j04_interp');
    traj.(temp) = rmfield(traj.(temp),'position_j05_interp');
    traj.(temp) = rmfield(traj.(temp),'position_j06_interp');
    traj.(temp) = rmfield(traj.(temp),'position_j07_interp');
end
if isfield(traj.JointStateList,'velocity_j07_interp')
    traj.JointStateList.velocity_interp=[traj.JointStateList.velocity_j01_interp;traj.JointStateList.velocity_j02_interp;traj.JointStateList.velocity_j03_interp;traj.JointStateList.velocity_j04_interp;];
    traj.JointStateList.velocity_interp=[traj.JointStateList.velocity_interp;traj.JointStateList.velocity_j05_interp;traj.JointStateList.velocity_j06_interp;traj.JointStateList.velocity_j07_interp;];
    traj.(temp) = rmfield(traj.(temp),'velocity_j01_interp');
    traj.(temp) = rmfield(traj.(temp),'velocity_j02_interp');
    traj.(temp) = rmfield(traj.(temp),'velocity_j03_interp');
    traj.(temp) = rmfield(traj.(temp),'velocity_j04_interp');
    traj.(temp) = rmfield(traj.(temp),'velocity_j05_interp');
    traj.(temp) = rmfield(traj.(temp),'velocity_j06_interp');
    traj.(temp) = rmfield(traj.(temp),'velocity_j07_interp');
end
if isfield(traj.JointStateList,'effort_j07_interp')
    traj.JointStateList.effort_interp=[traj.JointStateList.effort_j01_interp;traj.JointStateList.effort_j02_interp;traj.JointStateList.effort_j03_interp;traj.JointStateList.effort_j04_interp;];
    traj.JointStateList.effort_interp=[traj.JointStateList.effort_interp;traj.JointStateList.effort_j05_interp;traj.JointStateList.effort_j06_interp;traj.JointStateList.effort_j07_interp;];
    traj.(temp) = rmfield(traj.(temp),'effort_j01_interp');
    traj.(temp) = rmfield(traj.(temp),'effort_j02_interp');
    traj.(temp) = rmfield(traj.(temp),'effort_j03_interp');
    traj.(temp) = rmfield(traj.(temp),'effort_j04_interp');
    traj.(temp) = rmfield(traj.(temp),'effort_j05_interp');
    traj.(temp) = rmfield(traj.(temp),'effort_j06_interp');
    traj.(temp) = rmfield(traj.(temp),'effort_j07_interp');
end
set(handles.plot_list1,'String',fieldnames(plot_list));
set(handles.plot_list2,'String',fieldnames(plot_list));
guidata(hObject,handles);

function calc_vel_button_Callback(hObject, eventdata, handles)
global interp_list;
global plot_list;
global traj;
if isempty(str2num(get(handles.total_time,'String')))
    errordlg('Total time of motion is empty!');
else
selected    = get(handles.calcVel_button_group,'SelectedObject');
selected    = selected.String;
total_time  = str2num(get(handles.total_time,'String'));
strName    = 'velocity_calc_';
i=1;
if strcmp (selected,'Original position')
    strName = [strName num2str(total_time)];
    traj.calc_velocity(total_time,'position',strName);
    indexJoint       = size(traj.JointStateList.(strName),1);
    while i <= indexJoint
        tempName             = [strName '_j0' num2str(i)];
        plot_list.(tempName) = traj.JointStateList.(strName)(i,:);
        tempName             = string(tempName);
        i=i+1;
    end
else
    strName = [strName 'interp_' num2str(total_time)];
    traj.calc_velocity(total_time,'position_interp',strName);
    indexJoint       = size(traj.JointStateList.(strName),1);
    while i <= indexJoint
        tempName             = ([strName '_j0' num2str(i)]);
        plot_list.(tempName) = traj.JointStateList.(strName)(i,:);
        tempName             = string(tempName);
        i=i+1;
    end
end   
    set(handles.plot_list1,'String',fieldnames(plot_list));
    set(handles.plot_list2,'String',fieldnames(plot_list));
end

function save_button_Callback(hObject, eventdata, handles)
global traj;
temp='JointStateList'
jointStateList=traj.(temp)
[interpFileName,savePathName]=uiputfile('path001.mat','Save data')
matfile                      =fullfile(savePathName,interpFileName)
save(matfile,'jointStateList');

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

function interp_point_Callback(hObject, eventdata, handles)
function interp_point_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================Checkbox=======================================%
function add_plot1_Callback(hObject, eventdata, handles)

function add_plot2_Callback(hObject, eventdata, handles)
