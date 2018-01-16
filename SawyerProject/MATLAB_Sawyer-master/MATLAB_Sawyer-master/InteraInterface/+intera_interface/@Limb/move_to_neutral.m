function res = move_to_neutral( obj, timeout, speed )
%% Command the Limb joints to a predefined set of "neutral" joint angles.
%	From rosparam named_poses/<limb>/poses/neutral.
% 
%	@type   timeout:	float
%	@param  timeout:	seconds to wait for move to finish [15]
%	@type   speed:      float
%	@param  speed:      ratio of maximum joint speed for execution default= 0.3; range= [0.0-1.0]

    % Organize default values
    if nargin < 3 || isempty( speed )
        speed = 0.7;
    end
    
    if nargin < 2 || isempty( timeout )
        timeout = 15.0;
    end
    
    res = false;
    % Get neutral pose for right limb
    ptree = rosparam;            
%         try:
	neutralPose = get( ptree, ['named_poses/' obj.name '/poses/neutral']);
%         except KeyError:
%             rospy.logerr(("Get neutral pose failed, arm: \"{0}\".").format(self.name))
%             return

    % Set target joint angles
    angles = containers.Map( obj.joint_angles.keys, neutralPose );
    % Set speed
    obj.set_joint_position_speed( speed );

    % Move to joint
    res = obj.move_to_joint_positions( angles, timeout );
end
        
