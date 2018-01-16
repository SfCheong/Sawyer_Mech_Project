classdef Limb < handle
    % Interface class for a limb on Intera robots.
    %   Detailed explanation goes here
    
    properties (Access = private)
        % Containers
%         Point      	= collections.namedtuple('Point',       ['x', 'y', 'z']     )
%         Quaternion 	= collections.namedtuple('Quaternion',	['x', 'y', 'z', 'w'])
%       % ROS node descriptor
%         node;         

        name;                   % Name of limb
        
        joint_names;            % Joint's name list
                
        joint_angles;           % Current angles
        joint_velocitys;        % Current velositys
        joint_efforts;          % Current efforts
        
        cartesian_pose;
        cartesian_velocity;
        cartesian_effort;       
        
        collision_state;
        
        command_msg;
        pub_speed_ratio;
        
        pub_joint_cmd;
        pub_joint_cmd_timeout;
    end
    
    methods 
        %% Constructor 
        function obj = Limb( limb, synchronous_pub )
            % Save ROS node descriptor
%             obj.node = node;

            if nargin < 2 || isempty( synchronous_pub )
                synchronous_pub = false;
            end

            if nargin < 1 || isempty(limb)
                limb = 'right';
            end

            % initialize object params
            initialize( obj, limb, synchronous_pub );
        end
        
        %
        function on_joint_states( obj, src, msg )
            % Find differnet 
%             jointDiff   = setdiff(msg.Name', keys(obj.joint_angles));
            jointDiff   = {'head_pan',  'torso_t0'};
            % Receive joint names without 'head_pan'  and  'torso_t0'
%             jointNames    = setdiff(msg.Name, jointDiff);
            
            % make new list for all maps
            obj.joint_angles 	= containers.Map( msg.Name, msg.Position    );
            obj.joint_velocitys	= containers.Map( msg.Name, msg.Velocity    );
            obj.joint_efforts	= containers.Map( msg.Name, msg.Effort      );
            
            % Delete 'head_pan'  and  'torso_t0' positons
            remove( obj.joint_angles,    jointDiff );
            remove( obj.joint_velocitys, jointDiff );
            remove( obj.joint_efforts,   jointDiff );            
        end

        % Callback function for end point state message
        on_endpoint_states(obj, src, msg);

        % Chack collision state
        function on_collision_state(obj, src, msg)
             if obj.collision_state ~= msg.CollisionState
                 obj.collision_state = msg.CollisionState;
            end        
        end
        
        
        function res = has_collided(obj)
            %%  Return True if the specified limb has experienced a collision.
            % 
            % @rtype: bool
            % @return: True if the arm is in collision, False otherwise.
            res = obj.collision_state;
        end

        function res = getJoint_names(obj)
            %% Return the names of the joints for the specified limb.
            % 
            % @rtype: [str]
            % @return: ordered list of joint names from proximal to distal (i.e. shoulder to wrist).
            res = obj.joint_names(obj.name);
        end

        function res = getJoint_angle(obj, joint)
            %%	Return the requested joint angle.
            % 
            % @type     joint: str
            % @param    joint: name of a joint
            % @rtype:   float
            % @return: angle in radians of individual joint
            res = obj.joint_angles( joint );
        end

        function res = getJoint_angles(obj)
            %%   Return all joint angles.
            % 
            % @rtype: dict({str:float})
            % @return: unordered dict of joint name Keys to angle (rad) Values
            res = obj.joint_angles.values;
        end

        function res = getJoint_velocity(obj, joint)
            %% Return the requested joint velocity.
            % 
            % @type joint: str
            % @param joint: name of a joint
            % @rtype: float
            % @return: velocity in radians/s of individual joint
            res = obj.joint_velocitys( joint );
        end

        function res = getJoint_velocitys(obj)
            %% Return all joint velocities.
            % 
            % @rtype: dict({str:float})
            % @return: unordered dict of joint name Keys to velocity (rad/s) Values
            res = obj.joint_velocitys.values;
        end

        function res = getJoint_effort(obj, joint)
            %% Return the requested joint effort.
            % 
            % @type     joint: str
            % @param    joint: name of a joint
            % @rtype:   float
            % @return:  effort in Nm of individual joint
            res = obj.joint_efforts(joint);
        end

        function res = getJoint_efforts(obj)
            %%  Return all joint efforts.
            % 
            % @rtype: dict({str:float})
            % @return: unordered dict of joint name Keys to effort (Nm) Values
            res = obj.joint_efforts.values;
        end

        function res = endpoint_pose(obj)
            %%  Return Cartesian endpoint pose {position, orientation}.
            % 
            % @rtype: dict({str:L{Limb.Point},str:L{Limb.Quaternion}})
            % @return: position and orientation as named tuples in a dict
            % 
            % C{pose = {'position': (x, y, z), 'orientation': (x, y, z, w)}}
            % 
            % - 'position'      : Cartesian coordinates x,y,z in namedtuple L{Limb.Point}
            % - 'orientation'   : quaternion x,y,z,w in named tuple L{Limb.Quaternion}
            res = deepcopy(obj.cartesian_pose);
        end

        function res = endpoint_velocity(obj)
            %%  Return Cartesian endpoint twist {linear, angular}.
            % 
            % @rtype: dict({str:L{Limb.Point},str:L{Limb.Point}})
            % @return: linear and angular velocities as named tuples in a dict
            % 
            % C{twist = {'linear': (x, y, z), 'angular': (x, y, z)}}
            % 
            % - 'linear': Cartesian velocity in x,y,z directions in namedtuple L{Limb.Point}
            % - 'angular': Angular velocity around x,y,z axes in named tuple L{Limb.Point}
            res = obj.cartesian_velocity.values;
        end

        function res = endpoint_effort(obj)
            %% Return Cartesian endpoint wrench {force, torque}.
            % 
            % @rtype: dict({str:L{Limb.Point},str:L{Limb.Point}})
            % @return: force and torque at endpoint as named tuples in a dict
            % 
            % C{wrench = {'force': (x, y, z), 'torque': (x, y, z)}}
            % 
            %   - 'force': Cartesian force on x,y,z axes in namedtuple L{Limb.Point}
            %   - 'torque': Torque around x,y,z axes in named tuple L{Limb.Point}
            res = obj.cartesian_effort.values;
        end

        function set_command_timeout(obj, timeout)
            %% Set the timeout in seconds for the joint controller
            % 
            % @type timeout: float
            % @param timeout: timeout in seconds
            obj.pub_joint_cmd_timeout.publish(Float64(timeout));
        end

        function exit_control_mode(obj, timeout)
            %% Clean exit from advanced control modes (joint torque or velocity).
            % 
            % Resets control to joint position mode with current positions.
            % 
            % @type timeout: float
            % @param timeout: control timeout in seconds [0.2]
            if nargin < 2 || isempty( timeout )
                timeout = 0.2;
            end   
            
            obj.set_command_timeout(timeout);
            obj.set_joint_positions(obj.joint_angles());
        end

        function set_joint_position_speed(obj, speed)
            %% Set ratio of max joint speed to use during joint position moves.
            % 
            % Set the proportion of maximum controllable velocity to use
            % during joint position control execution. The default ratio
            % is `0.3`, and can be set anywhere from [0.0-1.0] (clipped).
            % Once set, a speed ratio will persist until a new execution
            % speed is set.
            % 
            % @type speed: float
            % @param speed: ratio of maximum joint speed for execution default= 0.3; range= [0.0-1.0]
            if nargin < 2 || isempty( speed )
                speed = 0.3;
            end 
            
            msg         = rosmessage(obj.pub_speed_ratio.MessageType);
            msg.Data    = speed;
            
            send( obj.pub_speed_ratio, msg );
        end

        function set_joint_trajectory(obj, names, positions, velocities, accelerations)
            % % Commands the joints of this limb to the specified positions using
            % the commanded velocities and accelerations to extrapolate between
            % commanded positions (prior to the next position being received).
            % 
            % B{IMPORTANT:} Joint Trajectory control mode allows for commanding
            % joint positions, without modification, directly to the JCBs
            % (Joint Controller Boards). While this results in more unaffected
            % motions, Joint Trajectory control mode bypasses the safety system
            % modifications (e.g. collision avoidance).
            % Please use with caution.
            % 
            % @type names:          list [str]
            % @param names:         joint_names list of strings
            % @type positions:      list [float]
            % @param positions:     list of positions in radians
            % @type velocities:     list [float]
            % @param velocities:    list of velocities in radians/second
            % @type accelerations:  list [float]
            % @param accelerations: list of accelerations in radians/seconds^2
                                   
            obj.command_msg.Names           = names;
            obj.command_msg.Position        = positions;
            obj.command_msg.Velocity        = velocities;
            obj.command_msg.Acceleration    = accelerations;
            obj.command_msg.Mode            = obj.command_msg.TRAJECTORYMODE;
            obj.command_msg.Header.Stamp    = rostime('now') ;
            
            send( obj.pub_joint_cmd, obj.command_msg  );
        end

        function set_joint_positions(obj, positions)
            %%  Commands the joints of this limb to the specified positions.

            % B{IMPORTANT:} 'raw' joint position control mode allows for commanding
            % joint positions, without modification, directly to the JCBs
            % (Joint Controller Boards). While this results in more unaffected
            % motions, 'raw' joint position control mode bypasses the safety system
            % modifications (e.g. collision avoidance).
            % Please use with caution.
            % 
            % @type positions: dict({str:float})
            % @param positions: joint_name:angle command
            % @type raw: bool
            % @param raw: advanced, direct position control mode
            
            obj.command_msg.Names           = positions.keys;
            obj.command_msg.Position        = cell2mat( positions.values );
            obj.command_msg.Mode            = obj.command_msg.POSITIONMODE;
            obj.command_msg.Header.Stamp    = rostime('now');
            
            send( obj.pub_joint_cmd, obj.command_msg  );
        end

        function set_joint_velocities(obj, velocities)
            % Commands the joints of this limb to the specified velocities.
            % 
            % B{IMPORTANT}: set_joint_velocities must be commanded at a rate great
            % than the timeout specified by set_command_timeout. If the timeout is
            % exceeded before a new set_joint_velocities command is received, the
            % controller will switch modes back to position mode for safety purposes.
            % 
            % @type velocities: dict({str:float})
            % @param velocities: joint_name:velocity command
            obj.command_msg.Names           = velocities.key;
            obj.command_msg.Velocity        = cell2mat( velocities.values );
            obj.command_msg.Mode            = obj.command_msg.VELOCITYMODE;
            obj.command_msg.Header.Stamp	= rostime('now') ;

            send( obj.pub_joint_cmd, obj.command_msg  );
        end

        function set_joint_torques(obj, torques)
            % %%  Commands the joints of this limb to the specified torques.
            % 
            % B{IMPORTANT}: set_joint_torques must be commanded at a rate great than
            % the timeout specified by set_command_timeout. If the timeout is
            % exceeded before a new set_joint_torques command is received, the
            % controller will switch modes back to position mode for safety purposes.
            % 
            % @type torques: dict({str:float})
            % @param torques: joint_name:torque command
            obj.command_msg.Names           = torques.keys;
            obj.command_msg.Effort          = cell2mat( torques.values );
            obj.command_msg.Mode            = obj.command_msg.TORQUEMODE;
            obj.command_msg.Header.Stamp    = rostime('now');
            
            send( obj.pub_joint_cmd, obj.command_msg  );
        end

        %% Command the Limb joints to a predefined set of "neutral" joint angles.
        res = move_to_neutral( obj, timeout, speed );
       
        %% (Blocking) Commands the limb to the provided positions.
        res = move_to_joint_positions( obj, positions, timeout, threshold, test );
    end

    %% Povate methods
    methods( Access = private )        
        % Initialization routing
        initialize( obj, limb, synchronous_pub );
    end    
    
end

