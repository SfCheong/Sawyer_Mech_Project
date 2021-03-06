function openRecorded_test(pos_array,vel_array)
%% Import packages
import LeonaRT.*;           % Sawyer modeling package
import Viewer3D.*;          % 3D Visaualization
import Viewer3D.GUI.*;

%% Sawyer current state representation
hRobotCurrentState       = SawyerModel();
% Set color
hRobotCurrentState.Color = [ 0.0, 0.0, 0.0 ];

% Allocate mamory for path
motionPoints = repelem( single(0), 7, 3, size(pos_array,2) );
position = pos_array;
velocity = vel_array;
% Make array
for i = 1:size(pos_array,2)
	% Set new position to model
    hRobotCurrentState.setJointAngle( position(:, i) );
	% Build 3D motion path
    motionPoints( :, :, i) = hRobotCurrentState.getJointPositions();
end  
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
%%
% Create playback figure 
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
% Playback loop
posCounter   = 1;
incDirection = 1;

% Animation
while true
   	% Check state
    if needClose == true
        % Close figure
        delete( hAnglesFig );
        break;
    end
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
