classdef RobotParams < handle
    %% Interface class for essential ROS parameters on Intera robot.
    
    properties
        sdk_networking_url  = 'http://sdk.rethinkrobotics.com/intera/Networking';
        ros_networking_url  = 'http://wiki.ros.org/ROS/NetworkSetup';
        % ROS parameters list
        ptree               = [];
        % Message function list
        color_dict          = [];
    end
    
    methods
        %% Constructor
        function obj = RobotParams()
            % Get ros parameters tree
            obj.ptree       = rosparam;            
            % Initialize messages list
            obj.color_dict = containers.Map(    {   'INFO', 'WARN',     'ERROR' },...
                                                {	@disp,   @warning,   @error }       );
            
        end
        
        %% Return the names of the camera.
        %	@rtype:     list [str]
        %   @return:	ordered list of camera names
        function keys = get_camera_names( obj )
            % Get camera names
%         	keys =  obj.get_camera_details().keys();
        end

        %% Return the details of the cameras.
        %	@rtype:     list [str]
        %   @return:	ordered list of camera details
        function camera_dict = get_camera_details( obj )           
%             try
                % Receive robot parameters
                camera_dict = get( obj.ptree, '/robot_config/camera_config'); 
%             except KeyError:
%                 rospy.logerr('RobotParam:get_camera_details cannot detect any '
%                     'cameras under the parameter {0}'.format(camera_config_param))
%             except (socket.error, socket.gaierror):
%                  obj ._log_networking_error()
%             end            
        end

        %% Return the names of the robot's articulated limbs from ROS parameter.
        % @rtype: list [str]
        % @return: ordered list of articulated limbs names
        %          (e.g. right, left). on networked robot
        function limbNames = get_limb_names( obj )
            % Keys for exclude
            non_limb_assemblies = {'torso', 'head'};
            % Recieve all assemblies names
            assemblies =  obj.get_robot_assemblies();
            % Reduce non_limb_assemblies
            limbNames = setdiff(assemblies, non_limb_assemblies);
        end

        %% Return the names of the robot's assemblies from ROS parameter.
        %   @rtype:     list [str]
        %   @return:    ordered list of assembly names (e.g. right, left, torso, head). on networked robot
        function assemblies = get_robot_assemblies( obj )
%             try
                 assemblies =  get( obj.ptree, '/robot_config/assembly_names');
%             except KeyError:
%                 rospy.logerr('RobotParam:get_robot_assemblies cannot detect assembly names'
%                              ' under param /robot_config/assembly_names')
%             except (socket.error, socket.gaierror):
%                  obj ._log_networking_error()
%             end
        end

        %% Return the names of the joints for the specified limb from ROS parameter.
        % 
        % @type  limb_name: str
        % @param limb_name: name of the limb for which to retrieve joint names
        % 
        % @rtype:   list [str]
        % @return:  ordered list of joint names from proximal to distal
        %          (i.e. shoulder to wrist). joint names for limb
        function joint_names = get_joint_names(obj, limb_name)
%             try:
                 joint_names = get( obj.ptree, ['robot_config/' limb_name '_config/joint_names']);
%             except KeyError:
%                 rospy.logerr(('RobotParam:get_joint_names cannot detect joint_names for'
%                               ' arm \'{0}\'').format(limb_name))
%             except (socket.error, socket.gaierror):
%                  obj ._log_networking_error()
%             end
            
        end

        %% Return the name of class of robot from ROS parameter.
        % @rtype:  str
        % @return: name of the class of robot (eg. "sawyer", "baxter", etc.)
        function robot_name = get_robot_name( obj )
%             try
                 robot_name = get( obj.ptree, '/manifest/robot_class' );
%             except KeyError:
%                 rospy.logerr('RobotParam:get_robot_name cannot detect robot name'
%                              ' under param /manifest/robot_class')
%             except (socket.error, socket.gaierror):
%                  obj ._log_networking_error()
%             end
        end

        %% Make log message  error
        function log_networking_error( obj )
            % Prepear message
            msg = ['Failed to connect to the ROS parameter server!\n'
                   'Please check to make sure your ROS networking is properly configured:\n'
                   'Intera SDK Networking Reference:' obj.sdk_networking_url '\n' 
                   'ROS Networking Reference:'        obj.ros_networking_url ];
   
            % Log message
            obj.log_message( msg, 'ERROR' );
        end

        %% Print the desired message on stdout using level-colored text.
        % 
        % @type  msg: str
        % @param msg: Message text to be desplayed
        % 
        % @type  level: str
        % @param level: Level to color the text. Valid levels:
        %               ["INFO", "WARN", "ERROR"]
        function log_message( obj , msg, level )
            % Set default values
            if nargin < 3 || isempty(level)
                level = 'INFO';
            end                
            % Get function
            pFunc = obj.color_dict(level);
            % Print message
            pFunc( msg );
        end

    end
    
end

