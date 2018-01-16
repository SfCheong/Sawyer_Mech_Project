%% Show simple 3D scene. Save and load Axes parameters

clc
close all
% clear all

% Includ packages
import Viewer3D.*;     % Include this package
import MATLAB_Sawyer.libs.STLRead.*;

%% Testing axes ***********************************************************
% Make figure
hFigure  = figure( 1 );
% Appen call back function
hFigure.CloseRequestFcn  = @closeFigureCallback;

% Get path to current projectdir
scriptPath = mfilename('fullpath');
scriptPath = scriptPath( 1:end-length( mfilename ) );
% Get current axis
hAxis                   = axes( hFigure, 'Tag', 'meshAxes' );
% Create new scene
hBasicScene             = Viewer3D.GUI.Scene3D( hAxis, scriptPath );
%  Append handle to User data
hFigure.UserData.hScene = hBasicScene;

%%  Add Graphic objects ***************************************************
    % Axes for debug drawing
    hTestAxes = Viewer3D.Primitives.Axes();
    % Add new drwable objects
    hBasicScene.append( hTestAxes );    
    
    %% Path to rest folder
    % Get base project folder path
    baseProjectPath = getenv( 'SLAM_PROJECTS_PATH' );
    % If  steel empty
    if isempty( baseProjectPath )
        % Use current directory
        baseProjectPath = pwd;
    end

%     projectPath     = [ baseProjectPath '/TestProject/objects/ColoredCubs.stl'];
% 	projectPath     = [ baseProjectPath '/TestProject/objects/testCube.stl'];
    projectPath     = '/home/deep/MyLsdSlamProject/ROS_Catkin/src/sawyer_robot/sawyer_description/meshes/sawyer_mp3/l0.STL';

base = stlread('C:\Users\8Users\Desktop\Sem 5\MATLAB_examples\MATLAB_Sawyer\examples\Data\meshes\sawyer_ft\base.stl');
head = stlread('C:\Users\8Users\Desktop\Sem 5\MATLAB_examples\MATLAB_Sawyer\examples\Data\meshes\sawyer_ft\head.stl');

    %% Render *****************************************************************
    % The model is rendered with a PATCH graphics object. We also add some dynamic
    % lighting, and adjust the material properties to change the specular
    % highlighting.

%% Render
% The model is rendered with a PATCH graphics object. We also add some dynamic
% lighting, and adjust the material properties to change the specular
% highlighting.

baseModel = patch(gca, base,'FaceColor',       [0.8 0.8 1.0], ...
                'EdgeColor',       'none',        ...
                'FaceLighting',    'gouraud',     ...
                'AmbientStrength', 0.15);
     
headModel = patch(gca, head,'FaceColor',       [0.8 0.8 1.0], ...
                'EdgeColor',       'none',        ...
                'FaceLighting',    'gouraud',     ...
                'AmbientStrength', 0.15);

% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
% view([-135 35]);

% Configure Transformation object and make tree
tfBase          = hgtransform('Parent', gca);
baseModel.Parent     = tfBase;

tfHead          = hgtransform; %('Parent', gca );
headModel.Parent     = tfHead;


M               = makehgtform('translate',[0 0 1]); % User defined
tfHead.Matrix    = M;

%% Save axis parameters befor figure will close ***************************
function  closeFigureCallback( src, data )
    % Show debug message
    disp( 'closeFigureCallback: Try to close..' );
    
    % Scene was append
    if ~isempty( src.UserData )
        % save scene
        delete( src.UserData.hScene );
    end
    
    % Close figure
    delete( gcf );
end
