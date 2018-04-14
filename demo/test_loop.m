%%
%Configuration for rospublisher and rossubscriber
[pubJointCommand,msgJC] = rospublisher( '/robot/limb/right/joint_command', 'intera_core_msgs/JointCommand');
sub    = rossubscriber( '/robot/joint_states', 'sensor_msgs/JointState');

%Read current status of Sawyer robot
result       = receive(sub,5);
init_pos     =result.Position;
init_pos_j01 = rad2deg(init_pos(2))

%Configure ROS message of JointCommand
%msgJC.Mode        = msgJC.POSITIONMODE;
msgJC.Mode         = msgJC.TRAJECTORYMODE;
msgJC.Acceleration = 1e-20*[0.2 0.2 0.2 0.2 0.2 0.2 0.2];
msgJC.Names       = {'right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'};
msgJC.Velocity     = 1e-06*[1 1 1 1 1 1 1];
msgJC.Position    = init_pos(2:8);
%%
%Send controlling command
p=1;
while p < 4
    %0.08727=5°
    msgJC.Position(1) = p*(-0.08727);
    status_           =rad2deg(msgJC.Position(1))
    %Send Joint Command
    send(pubJointCommand,msgJC);
    p=p+1;
end
%%
%Read the status of Sawyer robot after moving
last = receive(sub,5);
final_pos=last.Position;
final_vel=last.Velocity;
final_pos_j01 = rad2deg(final_pos(2))