
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
diffID = id( 2:end ) - id( 1:end-1 );
diffID=   diffID(    :, reduceStart:end-reduceEnd );
%replace the first element to Zero(Assume first motion point to be accurate)
diffID_new = [0,diffID]; 
%%
%create new array, with losedframed, position and vel of 1 joint
pos_1st_joint = position(1,:);
vel_1st_joint = velocity(1,:);
array_combi   = [diffID_new;pos_1st_joint;vel_1st_joint];

%%
%calculate difference
frame_no = length(pos_1st_joint);
%create x-axis of figure, sequence of frames
frame_index = zeros( 1, frame_no );
%Deviation at first frame is zero
diff_pos=zeros(1,frame_no);
diff_pos(1)=0;
diff_vel=zeros(1,frame_no);
diff_vel(1)=0;
calc_pos = zeros(1,frame_no);
calc_pos(1)=pos_1st_joint(1);
calc_vel = zeros(1,frame_no);
calc_vel(1)=vel_1st_joint(1);
for i = 2:frame_no
    frame_index(i) = diffID_new(i)+frame_index(i-1);
end
%%
%interpolate
p=1;
q=1;
while p <= frame_index(end)
    while p <= frame_index(q+1)
        diff_pos(p+1) = (pos_1st_joint(q+1)-pos_1st_joint(q))/(diffID_new(q+1));
        calc_pos(p+1) = calc_pos(p)+diff_pos(p+1);
        diff_vel(p+1) = (vel_1st_joint(q+1)-vel_1st_joint(q))/(diffID_new(q+1));
        calc_vel(p+1) = calc_vel(p)+diff_vel(p+1);
        p=p+1;
    end
    q=q+1;
end

%calc_val = calc_val(:,1:313);

%%
%Plot position graph
x = linspace(0,frame_index(end),frame_index(end)+1);
figure('Name','Position vs Frame.No')
plot(frame_index,pos_1st_joint,'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b')
title('Recorded and Calculated Position')
xlim([0 30])
ylabel('Position [rad]')
xlabel('frame index')
hold on
plot(x,calc_pos,'Marker','o','MarkerEdgeColor','r')
legend('Recorded Position','Calculated Position')
grid on
hold off
%%
%Plot Velocity Graph
figure('Name','Velocity vs Frame.No')
plot(frame_index,vel_1st_joint,'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b')
title('Recorded and Calculated Velocity')
xlim([0 30])
ylabel('Velocity [rad/s]')
xlabel('frame index')
hold on
plot(x,calc_vel,'Marker','o','MarkerEdgeColor','r')
legend('Recorded Velocity','Calculated Velocity')
grid on
hold off
%%
%Calculate and plot Acceleration graph
%Assume the time between each frame is 5ms (0.005s)
calc_accel = diff_vel/0.05;
figure('Name','Acceleration vs time')
plot(x*0.005,calc_accel,'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b')
title('Calculated Acceleration')
xlim([0 0.15])
ylabel('Acceleration [rad/s^2]')
xlabel('time [s]')
grid on
grid minor
%%
% send to ros
%all topic name is not correct yet, just for guidance
% rosinit('IP-Address')
% %Get all topics that are available
% rostopic list
% %Check what data is published on the topic
% odometry        = rostopic ('echo', '/odom')
% showdetails(odometry)
% scanner         = rossubscriber('scan')
% %3 different way to get info. from subscriber (Accessing Data)
% %5 is time out
% laserdata       = receive (scanner, 5)
% %OR
% laserdata       = scanner.LatestMessage
% %OR (The one temporary is using in recordJointStates.m)
% scanner.NewMessafeFcn   = { @keyFrameCallback, outputPath };
% %Create a publisher to control the robot
% %velcmd is publisher it self, while vel is the message
% [velcmd, vel]   = rospublisher('/mobile_base/command/velocity')  
% %configure the message (JUST example!)
% vel.Linear.X    = 0.2;
% vel.Angular.Z   = 0.5;
% send(velcmd,vel)
% rosshutdown;
%%
%record data from Ros

%%
%Analysis the deviated between input and output data
