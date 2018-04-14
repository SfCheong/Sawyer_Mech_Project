% Clean all
clc;
close all;

rosshutdown;
rosinit;

%**************************************************************************
%% Import packages
import LeonaRT.*;               % Sawyer modeling package
import Viewer3D.*;              % 3D Visaualization
import Viewer3D.GUI.*;          % GUI Classes

% Load object
fileName    = 'jointStateList_sendFormat_new.mat';
scriptPath  = mfilename('fullpath');
fullPath    = [ scriptPath( 1:end-length( mfilename ) )  fileName ];
load( fullPath );

% Reduce data
%positionRecorder.reduce();

% Save length
%arrayLangth = positionRecorder.length();
arrayLangth = 1122;
% Allocate array **********************************************************
id       = zeros( 1, arrayLangth );
position = zeros( 7, arrayLangth );
velocity = zeros( 7, arrayLangth );
effort   = zeros( 7, arrayLangth );

%**************************************************************************
%% Sawyer current state representation
hRobotCurrentState       = SawyerModel();
% Set color
hRobotCurrentState.Color = [ 0.0, 0.0, 0.0 ];

% Allocate mamory for path
motionPoints = repelem( single(0), 7, 3, arrayLangth );

% Make array
for i = 1:arrayLangth
    % Id nomber
    id(:, i)         = jointStateList_send(i).id;
    % Save position
    position( :, i ) = jointStateList_send(i).position;
    % Save velosity
    velocity( :, i ) = jointStateList_send(i).velocity_30;
    % Save velosity
    effort( :, i )   = jointStateList_send(i).effort;
    
	% Set new position to model
    hRobotCurrentState.setJointAngle( position(:, i) );
	% Build 3D motion path
    motionPoints( :, :, i) = hRobotCurrentState.getJointPositions();
end

%**************************************************************************
%% Reduce arrays
reduceStart = 110;
reduceEnd   = 150;

position     =     position(    :, reduceStart:end-reduceEnd );
velocity     =     velocity(    :, reduceStart:end-reduceEnd );
effort       =       effort(    :, reduceStart:end-reduceEnd );

motionPoints = motionPoints( :, :, reduceStart:end-reduceEnd );

%**************************************************************************
%% Calculate losed frames
diffID = id( 2:end ) - id( 1:end-1 );

%**************************************************************************   
%% Create figure for records representation
hAnglesFig = figure( 'Name', 'Motion Records' );

hAxis(1) = subplot( 2, 1, 1  );        
    % Plot positions
    plot(   1:length( position ),	...
            position );    
hAxis(2) = subplot( 2, 1, 2);
    % Plot velocity
     plot(   1:length( velocity ),	...
            velocity );
% grid on for all axes
set( hAxis, 'XGrid',    'on',       ...
            'YGrid',    'on'     	);  
    
% Initialize data
linePlace = 400;
lineSize  = 2;  

XLinePos = [ linePlace linePlace];
YLinePos = [-lineSize  lineSize ];

% Draw vertical lines
vLine(1) = line( 	'Parent',       hAxis(1),	...
                    'Color',        'r',        ...
                    'LineWidth',	2               );        
% Fitch copy to second axes
vLine(2) = copyobj( vLine(1), hAxis(2) );
                
%**************************************************************************  
%% Create playback figure 
hFigure  = figure( 'Name', 'Playback motion animation' );
% Connect callback for close
hFigure.CloseRequestFcn  = @closeFigureCallback;

global needClose;
needClose = false;

% Get path to current projectdir
scriptPath = mfilename('fullpath');
scriptPath = scriptPath( 1:end-length( mfilename ) );
% Get current axis
hAxis	= axes( hFigure, 'Tag', 'robotAxis' );

% Get path to current projectdir
hScene 	= Scene3D( hAxis, scriptPath );

%  Append handle to User data
hFigure.UserData.hScene = hScene;

% Add new drwable objects
hRobotCurrentState.setParent( hScene.hAxes );

% Append motion pathes
motionLines = gobjects( 1, 5 );

% Joint 4
XData = motionPoints( 4, 1, : );
XData = permute( XData, [3 2 1] );

YData = motionPoints( 4, 2, : );
YData = permute( YData, [3 2 1] );

ZData = motionPoints( 4, 3, : );
ZData = permute( ZData, [3 2 1] );

motionLines( 1, 1) = line(	XData,	YData,	ZData,      ...
                            'Color',        'r',        ...
                            'Parent',       hScene.hAxes        );

% Joint 5
XData = motionPoints( 5, 1, : );
XData = permute( XData, [3 2 1] );

YData = motionPoints( 5, 2, : );
YData = permute( YData, [3 2 1] );

ZData = motionPoints( 5, 3, : );
ZData = permute( ZData, [3 2 1] );

motionLines( 1, 2) = line(	XData,	YData,	ZData,      ...
                            'Color',        'g',        ...
                            'Parent',       hScene.hAxes        );              
                        
% !!! Moving to first point
global isWaitPlayback;
global isPlayback;

% % Play animation
% isWaitPlayback  = true;
% isPlayback      = false;

% Initialize motion controller*********************************************
hSawyerMotionController = LeonaRT.JointStateReceiver();
% % Add lisener
% addlistener(	hSawyerMotionController, ...
%                 'JointStateUpdated', @jointStateListener );

addlistener(	hSawyerMotionController, ...
                'MotionDone', @motionDoneListener );

% Move to first joint state
jointState      =  JointState( );

jointState.id       = position( :, 1 );

jointState.position = position( :, 1 );
jointState.velocity = velocity( :, 1 );
jointState.effort   = effort  ( :, 1 );

% Play animation
isWaitPlayback  = true;
isPlayback      = false;
      
% Move to new position
hSawyerMotionController.setPosition( jointState );

% Wait for moving in the start position
while ~isPlayback
	% Delay
    pause(0.5);
end
%**************************************************************************

% Playback loop
posCounter   = 1;
incDirection = 1;

% Animation
while true
   	% Check state
    if needClose == true
        % Close figure
        delete( hAnglesFig );
        delete(hSawyerMotionController);
        
%         % Show profile result
%         profile viewer
%         % Save result
%         profsave
        
        
        % Break loop
        break;
    end
       
    % Motion controller ***************************************************
	% Get next joint state 
	jointState      =  JointState( );
    
    jointState.id       = position( :, posCounter );
    
    jointState.position = position( :, posCounter );
    jointState.velocity = velocity( :, posCounter );
    jointState.effort   = effort  ( :, posCounter );
    
	% Move to new position
	hSawyerMotionController.setPosition( jointState );
    %**********************************************************************
    
    % Set new position to model
    hRobotCurrentState.setJointAngle(  position(:, posCounter) );
    
    % Update position
    XLinePos = [ posCounter	 posCounter ];
    YLinePos = [  -lineSize    lineSize	];
    
    % Update player's marker
    set( vLine, 'XData', XLinePos, 'YData', YLinePos );
    
    % Update data
    posCounter = posCounter + incDirection;
    
    % If record done
    if	posCounter >= length(position)    || ...
        posCounter <= 1
        % Switch playback direction
        incDirection = incDirection * -1;
    end
   
    % Delay
    pause(0.02);
end
       
%% Joint position callback liseners
function motionDoneListener( src, evnt )
    % Notify received
    disp( 'motionDoneListener: Motion done...' );
    global isWaitPlayback;
    global isPlayback;
    
    % If check for start playback
    if isWaitPlayback
        % Reset waiting
        isWaitPlayback   = false;
        % Start playback
        isPlayback       = true;
    end
end
    
% Save axis parameters befor figure will close ****************************
function  closeFigureCallback( src, data )
    % Show debug message
    disp( 'closeFigureCallback: Try to close..' );
    
    global needClose;
    needClose = true;
    
    % Scene was append
    if ~isempty( src.UserData )
        % save scene
        delete( src.UserData.hScene );
    end
    
    % Close figure
    delete( gcf );
end
