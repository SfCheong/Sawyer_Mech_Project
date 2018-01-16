clc;
close all;

%% Import packages
import LeonaRT.*;           % Sawyer modeling package
import Viewer3D.*;          % 3D Visaualization
import Viewer3D.GUI.*;

% Profilign
% profile on

% Load object
fileName    = 'stateRecords.mat';
scriptPath  = mfilename('fullpath');
fullPath    = [ scriptPath( 1:end-length( mfilename ) )  fileName ];
load( fullPath );

arrayLength = positionRecorder.length();
%%
%Create empty necessary array (4 date will received from Sawyer)
id       = zeros( 1, arrayLength );
position = zeros( 7, arrayLength );
velocity = zeros( 7, arrayLength );
effort   = zeros( 7, arrayLength );

%%
%load Sawyer Model and append the data to empty array being created 
hRobotCurrentState       = SawyerModel();
% Set color
hRobotCurrentState.Color = [ 0.0, 0.0, 0.0 ];

% Allocate mamory for path
motionPoints = repelem( single(0), 7, 3, arrayLength );

% Make array
for i = 1:arrayLength
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

%%
%reduce array, cut off part of recorded array which contain no change of
%data
reduceStart = 110;
reduceEnd   = 150;

position     =     position(    :, reduceStart:end-reduceEnd );
velocity     =     velocity(    :, reduceStart:end-reduceEnd );
effort       =       effort(    :, reduceStart:end-reduceEnd );

motionPoints = motionPoints( :, :, reduceStart:end-reduceEnd );
%calculate lost frame and reduce the array
diffID      = id( 2:end ) - id( 1:end-1 );
diffID      = diffID(    :, reduceStart:end-reduceEnd );
%replace the first element to Zero(Assume first motion point to be accurate)
diffID_new  = [0,diffID]; 
%%
%create new array, with losedframed, position and vel of 1 joint
pos_1st_joint = position(1,:);
vel_1st_joint = velocity(1,:);
%combination of array, which contains no. of lose frame, pos and vel of 1st
%joint
array_combi   = [diffID_new;pos_1st_joint;vel_1st_joint];

%%
frame_no    = length(pos_1st_joint);
%create x-axis of figure, sequence of frames
frame_index = zeros( 1, frame_no );
%fill in lost frame with self-defined value
diff_val    = zeros(1,frame_no);
diff_val(1) = pos_1st_joint(1);
calc_pos    = zeros(1,frame_no);
calc_pos(1) = pos_1st_joint(1);
for i = 2:frame_no
    %frame_index=INDEX of recorded frame [0,4,7,11,...]
    %last element is 1121, which mean it should contain 1121 joints states
    %data if no frames is lost
    frame_index(i) = diffID_new(i)+frame_index(i-1);
end
%%
p=1;
q=1;
while p <= frame_index(end)
    while p <= frame_index(q+1)
        diff_val(p+1) = (pos_1st_joint(q+1)-pos_1st_joint(q))/(diffID_new(q+1));
        calc_pos(p+1) = calc_pos(p)+diff_val(p+1);
        p=p+1;
    end
    q=q+1;
end
%calc_val = calc_val(:,1:313);

%%
%Plot graph
%x=index of frame
x = linspace(0,frame_index(end)+1,frame_index(end)+1);
figure('Name','Position vs Frame.No')
plot(frame_index,pos_1st_joint,'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b')
xlim([0 30])
ylabel('Position/rad')
xlabel('frame index')
hold on
plot(x,calc_pos,'Marker','o','MarkerEdgeColor','r')
title('Calculated Position in between lost frames')
grid on
hold off
legend('Recorded Position','Calculated Position')
%%
figure
plot(x,calc_pos,'b')
title('Complete calculated position')
ylabel('Position/rad')
xlabel('frame index')
grid on
%%
%calculate velocity
calc_vel = (calc_pos( 2:end )- calc_pos( 1:end-1))/0.02;
calc_vel = [0,calc_vel];
figure('Name','Velocity')

xlabel('time/s')
ylabel('velocity/rads-1')
plot(x,calc_vel,'Marker','o','MarkerEdgeColor','b')
xlim([0 30])
hold on
plot(frame_index,vel_1st_joint,'Marker','o','MarkerEdgeColor','r')
title('Calculated and recorded velocity')
grid on
hold off
legend('Calculated Velocity','Recorded Velocity')


%%
%send to ros
%refer moveSawyerGUImain.m

%%
%record data from Ros
%hJointStateSubsciber = rossubscriber(	'/robot/joint_states',  ...
%                                        'BufferSize',           50  );

%%
%Analysis the deviated between input and output data
