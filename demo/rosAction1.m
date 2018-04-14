%%
clc
%rosinit
%%
%Test Ros-Action
[actClient, goalMsg] = rosactionclient('/motion/motion_command');
goalMsg.Trajectory.JointNames   = {'right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'};
%Assign a temporary variable
tempTraj = goalMsg.Trajectory(1);
tempTraj.Waypoints = rosmessage('intera_motion_msgs/Waypoint');

%%
%set desired position
i=1;
j=1;
[fileName, pathName] = uigetfile('*.mat','Select recorded state record file');
load(fileName);
while i <= 1122
%desired_pos_deg = [-i*3 i*5 10 40 i*8 10 20];
%desired_pos_rad = deg2rad(desired_pos_deg);
desired_pos_rad  = list_send(i).position;
goalMsg.Trajectory.Waypoints(j)=rosmessage('intera_motion_msgs/Waypoint');
goalMsg.Trajectory.Waypoints(j).JointPositions =desired_pos_rad;

% goalMsg.Trajectory.Waypoints(i).Options.MaxJointAccel = [0.17 0.17 0.17 0.17 0.17 0.17 0.17]; %10°/s²
% goalMsg.Trajectory.Waypoints(i).Options.JointTolerances = 0.087; %5°
% goalMsg.Trajectory.Waypoints(j).Options.MaxJointSpeedRatio = 0.5; %range 0.0~1.0
% goalMsg.Trajectory.Waypoints(j).Options.MaxRotationalSpeed = 0.5; %range 0.0~1.0
% goalMsg.Trajectory.Waypoints(j).Options.MaxLinearSpeed = 0.5; %range 0.0~1.0

i = i + 50;
j = j + 1;
end

goalMsg.Trajectory.TrajectoryOptions.InterpolationType = 'JOINT';
goalMsg.Trajectory.Label = 'test';

%%
%set other parameter
% goalMsg.Trajectory.Waypoints(:).Options.MaxJointAccel = [0.17 0.17 0.17 0.17 0.17 0.17 0.17]; %10°/s²
% goalMsg.Trajectory.Waypoints(:).Options.JointTolerances = 0.087; %5°
% goalMsg.Trajectory.Waypoints(:).Options.MaxJointSpeedRatio = 0.5; %range 0.0~1.0
goalMsg.Command = goalMsg.MOTIONGENERATE;
%goalMsg.Trajectory.TrajectoryOptions.PathInterpolationStep = 1;
%sendGoal(actClient,goalMsg)
sendGoalAndWait(actClient,goalMsg,20)
%cancelAllGoals(actClient)
%%
goalMsg.Command=goalMsg.MOTIONSTART;
sendGoal(actClient,goalMsg)