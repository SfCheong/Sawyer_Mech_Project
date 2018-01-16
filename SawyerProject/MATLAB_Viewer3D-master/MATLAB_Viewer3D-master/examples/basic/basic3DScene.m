%% Show simple 3D scene. Save and load Axes parameters
clc
close all
% clear all

%% Import packages ********************************************************

import Viewer3D.*;
import Viewer3D.GUI.*;
import Viewer3D.Primitives.*; 

%% Testing axes ***********************************************************
% Make figure
hFigure  = figure( 1 );
% Appen call back function
hFigure.CloseRequestFcn  = @closeFigureCallback;

% Get path to current projectdir
scriptPath = mfilename('fullpath');
scriptPath = scriptPath( 1:end-length( mfilename ) );
% Get current axis
hAxis                   = axes( hFigure, 'Tag', 'basicAxes' );
% Create new scene
hBasicScene             = Viewer3D.GUI.Scene3D( hAxis, scriptPath );
%  Append handle to User data
hFigure.UserData.hScene = hBasicScene;

hAxis = gca;

%%  Add Graphic objects ***************************************************
% Axes for debug drawing
hTestAxes = Viewer3D.Primitives.Axes();
hTestAxes.setParent( hAxis );
% Change visible
%hTestAxes.Visible = false;

% Draw camera
hCamera = Viewer3D.Primitives.Camera();
% Try to draw
hCamera.drawCamera( 1 );

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
