%% 
% Intera SDK Joint Torque Example: joint springs
%
% ***************************** Main *************************************
%     """RSDK Joint Torque Example: Joint Springs
% 
%     Moves the default limb to a neutral location and enters
%     torque control mode, attaching virtual springs (Hooke's Law)
%     to each joint maintaining the start position.
% 
%     Run this example and interact by grabbing, pushing, and rotating
%     each joint to feel the torques applied that represent the
%     virtual springs attached. You can adjust the spring
%     constant and damping coefficient for each joint using
%     dynamic_reconfigure.
%     """

% Querying the parameter server to determine Robot model and limb name(s)    
ptree       = rosparam;                                     % Read params tree
valid_limbs = get(ptree,'/robot_config/assembly_names'); 	% Get assembly list
    
% If no limbs avilable
if  isempty( valid_limbs )
    disp('Cannot detect any limb parameters on this robot. Exiting. ERROR!!');
end

% Receive robot name
robotName = get(ptree,'/manifest/robot_class'); 

% Parsing Input Arguments *************************************************
% arg_fmt = argparse.ArgumentDefaultsHelpFormatter
% parser  = argparse.ArgumentParser(formatter_class=arg_fmt)
% 
% parser.add_argument(    "-l", "--limb", dest="limb", default=valid_limbs[0],
%                         choices=valid_limbs,
%                         help='limb on which to attach joint springs' )

% args = parser.parse_args(rospy.myargv()[1:])
%**************************************************************************

% Grabbing Robot-specific parameters for Dynamic Reconfigure
% config_name     = ''.join([robot_name,"JointSpringsExampleConfig"])
% config_module   = "intera_examples.cfg"
% 
% cfg = importlib.import_module('.'.join([config_module,config_name]))

% Starting node connection to ROS *****************************************
disp('Initializing node... ');

% initialize node 
% rospy.init_node("sdk_joint_torque_springs_{0}".format(args.limb))

% Register server
% dynamic_cfg_srv = Server(cfg, lambda config, level: config);

% Create class ************************************************************
% js = JointSprings( dynamic_cfg_srv, limb = args.limb )
js = JointSprings('right');

% register shutdown callback **********************************************
% rospy.on_shutdown( js.clean_shutdown )

% Move to neutral positon
js.move_to_neutral();

% ???????
% js.attach_springs()



