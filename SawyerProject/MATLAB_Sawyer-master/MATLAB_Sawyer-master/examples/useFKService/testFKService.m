% Clean command line 
clc;
close all;
%**************************************************************************
% Import packages
import LeonaRT.*;           % Sawyer modeling package
import Viewer3D.*;          % 3D Visaualization
import Viewer3D.GUI.*;

% Initialize ROS
rosshutdown;
rosinit;

% Create service client
fkClient = rossvcclient( '/ExternalTools/right/PositionKinematicsNode/FKService' );
% Create message
fkMsg       = rosmessage( fkClient );
responseMsg	= rosmessage( 'intera_core_msgs/SolvePositionFKResponse' );

% jsMsg          	= rosmessage( 'sensor_msgs/JointState' );
% jsMsg.Name     	= { 'right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'   };
% jsMsg.Position	= [  0, 0, 0, 0, 0, 0, 0 ];

% Initialize message
fkMsg.Configuration             = rosmessage( 'sensor_msgs/JointState' );
fkMsg.Configuration.Name        = { 'right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'   };
fkMsg.Configuration.Position	= [  0, 0, 0, 0, 0, 0, 0 ];
% fkMsg.Configuration	= jsMsg;
fkMsg.TipNames        = {'right_hand'};
% Check service available
% waitForServer( fkClient );

% Load object
fileName    = 'stateRecords.mat';
scriptPath  = mfilename('fullpath');
fullPath    = [ scriptPath( 1:end-length( mfilename ) )  fileName ];
load( fullPath );

% Reduce data
positionRecorder.reduce();

% Save length
arrayLangth = positionRecorder.length();

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

% For each joint state in list 
for i = 1:arrayLangth
    % Set data to arrays ***********************************************
    % ID number
    id(:, i)         = positionRecorder.jointStateList(i).id;
    % Save position
    position( :, i ) = positionRecorder.jointStateList(i).position;
    % Save velosity
    velocity( :, i ) = positionRecorder.jointStateList(i).velocity;
    % Save velosity
    effort( :, i )   = positionRecorder.jointStateList(i).effort;
    
	% Calculate FK by Sawyer model *************************************
	% Start time measuring 
    
    % Set angles to model
    hRobotCurrentState.setJointAngle( position(:, i) );
	% Build 3D motion path
    motionPoints( :, :, i) = hRobotCurrentState.getJointPositions();
	% End time measuring
    
	% Start time measuring
    
    % Update message
    fkMsg.Configuration.Position	= position(:, i);
    % Get positions form FK service
    responseMsg = call( fkClient,fkMsg );    
	% End time measuring
    
	% Compare results
	disp( '----------------------------------------' );
    disp( 'KFservice:' );    
    disp( [ 'Position X: '    num2str( responseMsg.PoseStamp.Pose.Position.X    ) ] ); 
    disp( [ 'Position Y: '    num2str( responseMsg.PoseStamp.Pose.Position.Y    ) ] ); 
    disp( [ 'Position Z: '    num2str( responseMsg.PoseStamp.Pose.Position.Z    ) ] );    
%     disp( [ 'Quaternion: '  num2str( responseMsg.PoseStamp.Pose.Quaternion	) ] );
    disp( 'SawyerModel:' );    
    disp( [ 'Position: '    num2str( motionPoints( 7, 1:3, i)   ) ] );    
%     disp( [ 'Quaternion: '  num2str(responseMsg.PoseStamp.Pose.Quaternion	) ] );
    
    
    % Compare time
end

%***********************************************************************
% Reduce arrays
reduceStart = 110;
reduceEnd   = 150;

position     =     position(    :, reduceStart:end-reduceEnd );
velocity     =     velocity(    :, reduceStart:end-reduceEnd );
effort       =       effort(    :, reduceStart:end-reduceEnd );

motionPoints = motionPoints( :, :, reduceStart:end-reduceEnd );

%**************************************************************************
% Calculate losed frames
diffID = id( 2:end ) - id( 1:end-1 );

%**************************************************************************   
    
% If different big and misstake is regulare - try to recalculate joint
% length.

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