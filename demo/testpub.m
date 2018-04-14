%%
clc
%%
%Send command for control robot arm
[pubJointCommand,msgJC] = rospublisher( '/robot/limb/right/joint_command', 'intera_core_msgs/JointCommand');
%Receive Sawyer arm's status
sub    = rossubscriber( '/robot/joint_states', 'sensor_msgs/JointState');

%%
%Read current status of Sawyer robot
result       = receive(sub,5);
init_pos     =result.Position;
pos=init_pos(2:8)
init_pos_j01 = rad2deg(init_pos(2));
%%
msgJC.Mode        = msgJC.POSITIONMODE; %Position mode
% msgJC.Mode         = msgJC.TRAJECTORYMODE;
% msgJC.Velocity     = 1e-10*[0.2 0.2 0.2 0.2 0.2 0.2 0.2];
% msgJC.Acceleration = 1e-10*[0.2 0.2 0.2 0.2 0.2 0.2 0.2];
msgJC.Position     = [0.0074 -0.2576 -0.5909 0.5849 -0.0499 0.7384 0.2147]; 
msgJC.Names        = {'right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'};
msgJC.Position     = init_pos(2:8);

%%
%Set desired position [rad]
msgJC.Position(1) = deg2rad(-10);
%Send joint command to Sawyer
send(pubJointCommand,msgJC);

%%
%Read the status of Sawyer robot after moving
last = receive(sub,5);
final_pos=last.Position;
final_vel=last.Velocity;
final_pos_j01 = rad2deg(final_pos(2))