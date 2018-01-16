% Clean all
clc;
close all;

%**************************************************************************
%% Import packages
import LeonaRT.*;           % Sawyer modeling package
import Viewer3D.*;          % 3D Visaualization
import Viewer3D.GUI.*;

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

% Make array
for i = 1:arrayLangth
    % Id number
    id(:, i)         = positionRecorder.jointStateList(i).id;
    % Save position
    position( :, i ) = positionRecorder.jointStateList(i).position;
    % Save velosity
    velocity( :, i ) = positionRecorder.jointStateList(i).velocity;
    % Save velosity
    effort( :, i )   = positionRecorder.jointStateList(i).effort;
    
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
% Append interpolated points for loosed frames

% SAVE time of frame

% Calculate velosity
% Compare with saved velosity




