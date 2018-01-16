classdef SendTrajectory < handle
%% Send desired trajectory via ROS action
properties(Access = public)
   %ROS action
   trajectoryAction;
   %desired waypoints
   goalMsg;
   %Feedback Message
   feedbackMsg;
end
methods
    %%
    %Constructor
    function obj = SendTrajectory()
        %client = rosactionclient(actionname) creates a client for the specified ROS ActionName
        obj.trajectoryAction = rosactionclient('robot/limb/right/motion_command');
        
        % intera_motion_msgs/Trajectory message is used to specify a trajectory for Sawyer
        obj.goalMsg                 = rosmessage('intera_motion_msgs/Trajectory');
        obj.goalMsg.Joint_names     = ['right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'];
        %set desired waypoints
        %Todo:Here should be add the interpolated position [rad]
        obj.goalMsg.Waypoints       = [0 0 0 0 0 0 0];
        
        %obtain feedback message during execution
        obj.feedbackMsg      = rosmessage('intera_motion_msgs/MotionStatus');
    end
  %%
  %Set new position
    function setPosition(obj,new_pos)
        %Here should use the command append_waypoint() and
        %send_trajectory()
        %logically, should use for-loop for imported interpolated positions
    end
    
   %%
   %Get feedback Message during execution
   function feedbackMsg = getFeedback(obj)
       feedbackMsg = obj.feedbackMsg;
   end
   
end

end