classdef JointInterface < Sawyer.MotionCommand
    properties
        mode = 0;
        rosPub;
        rosSub;
    end
    methods
        function obj = JointInterface()
%           %Send command for control robot arm
%           [obj.rosPub,obj.goalMsg] = rospublisher( '/robot/limb/right/joint_command', 'intera_core_msgs/JointCommand');
%           %Receive Sawyer arm's status
%           obj.rosSub    = rossubscriber( '/robot/joint_states', 'sensor_msgs/JointState');              
            obj.Interface = 'Joint Interface';
        end
        
        function setMode(obj,mode)
            obj.mode         = mode
            obj.goalMsg.Mode = mode;
            if mode ==2
                obj.goalMsg.Velocity = [1 1 1 1 1 1 1];
            end
        end
        
        function jointPosition = getJointStatus(obj)
            %result       = receive(sub,5);
            %jointPosition = result.Position(2:8);
            disp('receiving data.....');
            jointPosition = [1 2 3 4 5 6 7];
        end
        
        function setJointAngle(obj,pos_array)
            disp('sending data.....');
            obj.goalMsg.Position = pos_array; 
            %send(pubJointCommand,obj.goalMsg);
        end
    end
end
