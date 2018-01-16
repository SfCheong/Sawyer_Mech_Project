
clc
close all
% clear all

import Viewer3D.*;
import Viewer3D.Primitives.*;

% Testing axes ************************************************************
hFigure  = figure( 1 );
hFigure.CloseRequestFcn  = @closeFigureCallback;
%hFigure.NextPlot         = 'replace';
%hFigure.NextPlot         = 'replacechildren';

% % Get current axis
% hAxis	= axes( hFigure, 'Tag', 'firstScene' );
% % Get path to current projectdir
scriptPath = mfilename('fullpath');
scriptPath = scriptPath( 1:end-length( mfilename ) );
% Get current axis
hAxis	= axes( hFigure, 'Tag', 'robotAxis' );
% Get path to current projectdir
% scriptPath = '/home/sergey/MyLsdSlamProject/MATLAB/Robot/@RobotGUIMain/RobotGUIMain/';
hScene 	= Viewer3D.GUI.Scene3D( hAxis, scriptPath );

%  Append handle to User data
hFigure.UserData.hScene = hScene;

% Sawyer current state representation
hRobotCurrentState       = LeonaRT.SawyerModel();
% Set color
hRobotCurrentState.Color = [ 0.0, 1.0, 0.0 ];
% Append to scene
hRobotCurrentState.setParent( hScene.hAxes );
% Change visible
% hRobotCurrentState.Visible = false;

% % Sawyer target state representation
% hRobotTargetState        = LeonaRT.SawyerModel();
% % Set color
% hRobotTargetState.Color  = [ 1.0, 0.0, 0.0 ];
% % Append to scene
% hRobotTargetState.setParent( hScene.hAxes );
% % Change visible
% hRobotTargetState.Visible = false;

% hAxesLines = Axes();
% hAxesLines.setParent( hScene.hAxes );

% Save axis parameters befor figure will close ****************************
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
