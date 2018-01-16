function initialize( obj, limb, synchronous_pub )
%% Constructor.
% @type     limb: str
% @param	limb: limb to interface
% 
% @type synchronous_pub:    bool
% @param synchronous_pub:   designates the JointCommand Publisher
%                           as Synchronous if True and Asynchronous if False.
% 
%     Synchronous Publishing means that all joint_commands publishing to
%     the robot's joints will block until the message has been serialized
%     into a buffer and that buffer has been written to the transport
%     of every current Subscriber. This yields predicable and consistent
%     timing of messages being delivered from this Publisher. However,
%     when using this mode, it is possible for a blocking Subscriber to
%     prevent the joint_command functions from exiting. Unless you need exact
%     JointCommand timing, default to Asynchronous Publishing (False).
% 
%     For more information about Synchronous Publishing see:    
%     http://wiki.ros.org/rospy/Overview/Publishers%20and%20Subscribers#queue_size:_publish.28.29_behavior_and_queuing

    if nargin < 2 || isempty( synchronous_pub )
        synchronous_pub = false;
    end
    
    if nargin < 1 || isempty(limb)
        limb = 'right';
    end

    % Create parameters class
	params = RobotParams();
    % Get limb names
	limb_names = params.get_limb_names();
        
    % Check limb in in limb names list
    if ~ismember( limb, limb_names )
        disp( [ 'Cannot detect limb' limb  'on this robot.'
                'Valid limbs are' limb_names '. Exiting Limb.init().'] );
        return
    end

    % Get joint names
    joint_names = params.get_joint_names( limb );

    if isempty(joint_names)
        disp(['Cannot detect joint names for limb' limb 'on this '
                     'robot. Exiting Limb.init().']);
        return
    end
    
    obj.name            = limb;
    obj.joint_names     = containers.Map( {limb}, {joint_names} );    
    obj.collision_state	= false;

%     obj.joint_angle           = containers.Map( joint_names, zeros(1, length(joint_names)) );
%     obj.joint_velocity        = containers.Map( joint_names, zeros(1, length(joint_names)) );
%     obj.joint_effort          = containers.Map( joint_names, zeros(1, length(joint_names)) );

%     obj.cartesian_pose        = dict()
%     obj.cartesian_velocity    = dict()
%     obj.cartesian_effort      = dict()

    % Create topic base
    ns = ['/robot/limb/' limb '/'];         % /robot/limb/right/

%     obj.command_msg = JointCommand();
    obj.command_msg     = rosmessage('intera_core_msgs/JointCommand');
    % Make publisher
    obj.pub_speed_ratio = rospublisher( [ ns 'set_speed_ratio' ], 'std_msgs/Float64');

%     queue_size = None if synchronous_pub else 1      
     if synchronous_pub
        queue_size = 0;
     else
        queue_size = 1;
     end
     
%     with warnings.catch_warnings():
%         warnings.simplefilter('ignore');
    obj.pub_joint_cmd = rospublisher( [ ns 'joint_command'], 'intera_core_msgs/JointCommand' );

    % Publisher for timeout time
    obj.pub_joint_cmd_timeout = rospublisher( [ ns 'joint_command_timeout' ], 'std_msgs/Float64' );

    % Create subscriber for 
    endpoint_state = 'endpoint_state';
    cartesian_state_sub = rossubscriber(	[ ns   endpoint_state ],            ...
                                            'intera_core_msgs/EndpointState',	...
                                            @obj.on_endpoint_states,          	...
                                            'BufferSize', 1             );

    % Create subscriber for 
    collision_state_sub = rossubscriber(	[ ns  'collision_detection_state'],         ...
                                            'intera_core_msgs/CollisionDetectionState', ...
                                             @obj.on_collision_state,                   ...
                                            'BufferSize', 1            );

	joint_state_topic   = 'robot/joint_states';
    joint_state_sub     = rossubscriber(	joint_state_topic,          	...
                                            'sensor_msgs/JointState',       ...
                                            @obj.on_joint_states,           ...
                                            'BufferSize', 1            );

    % Prepear message for feedback                     
    err_msg = [ obj.name ' limb init failed to get current joint_states from ' joint_state_topic ];               
    % Wating for joint angels initializing
    testFnc = @()length( obj.joint_angles ) > 0;
    intera_dataflow.wait_for( testFnc, 5.0, err_msg );
             
    % Prepear message for feedback
    err_msg = [ obj.name ' limb init failed to get current endpoint_state from ' ns endpoint_state ];
	% Wating for cartesian pose initializing 
    testFnc = @()length( obj.cartesian_pose) > 0;
    intera_dataflow.wait_for( testFnc, 1.0, err_msg );
end

