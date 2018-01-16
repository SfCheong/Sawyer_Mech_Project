% %     
%     Virtual Joint Springs class for torque example.
% 
%     @param limb: limb on which to run joint springs example
%     @param reconfig_server: dynamic reconfigure server
% 
%     JointSprings class contains methods for the joint torque e    xample allowing
%     moving the limb to a neutral location, entering torque mode, and attaching
%     virtual springs.
%  
classdef JointSprings < handle
    %JOINTSPRINGS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( Access = private )
        % control parameters
        limb;
        
        pub_cuff_disable;
        
        rate            = 1000.0;    % Hz
        missed_cmds     = 20.0;      % Missed cycles before triggering timeout

        springs         = [];
        damping         = [];
        start_angles    = [];
    end
    
    methods
        %% Constructor
        function obj = JointSprings( limbName )
            % create our limb instance
            obj.limb = Limb(limbName);

            % create cuff disable publisher
            cuff_ns                 = ['robot/limb/' limbName '/suppress_cuff_interaction'];
            obj.pub_cuff_disable	= rospublisher( cuff_ns, 'std_msgs/Empty' );

            % verify robot is enabled
            disp('Getting robot state... ');
%             rs          = intera_interface.RobotEnable(CHECK_VERSION);
%             init_state  = rs.state().enabled;
%             rs.enable();
            
            disp( 'JointSprings: Constructor done..' );
        end
        
        %% Update parameters
        function update_parameters( obj )
            
            jointsNames = obj.limb.joint_names();
            
            for joints = jointsNames
%             self._springs[joint] = self._dyn.config[joint[-2:] + '_spring_stiffness']
%             self._damping[joint] = self._dyn.config[joint[-2:] + '_damping_coefficient']
            end
        end
        
        %%
        % Calculates the current angular difference between the start position
        % and the current joint positions applying the joint torque spring forces
        % as defined on the dynamic reconfigure server.
        function update_forces( obj )
            % get latest spring constants
            obj.update_parameters();

            % disable cuff interaction
            msg = rosmessage(obj.pub_cuff_disable.msgtype);
            send( obj.pub_cuff_disable, msg );

            % create our command dict
%             cmd = [];
            
            % record current angles/velocities
            
            cur_pos = obj.limb.joint_angles();
            cur_vel = obj.limb.joint_velocities();
            
            % calculate current forces
            joinValues = obj.start_angles.keys();   % ???? 
            for joint =  joinValues                 % ????
%                 % spring portion
%                 cmd[joint] = self._springs[joint] * (self._start_angles[joint] - cur_pos[joint])
%                 % damping portion
%                 cmd[joint] -= self._damping[joint] * cur_vel[joint]
            end
            
            % command new joint torques            
            obj.limb.set_joint_torques(cmd);
        end

        function move_to_neutral( obj )
            %% Moves the limb to neutral location.
            obj.limb.move_to_neutral();
        end                               

        %	Switches to joint torque mode and attached joint springs to 
        %   current joint positions.
        function attach_springs( obj ) 
            % record initial joint angles
%             obj.start_angles = obj.limb.joint_angles()

            % set control rate
%             control_rate = rospy.Rate(obj.rate)

            % for safety purposes, set the control rate command timeout.
            % if the specified number of command cycles are missed, the robot
            % will timeout and return to Position Control Mode
%             self.limb.set_command_timeout((1.0 / self.rate) * self.missed_cmds)

            % loop at specified rate commanding new joint torques
%             while not rospy.is_shutdown()
% %                 if not self.rs.state().enabled
% %                     rospy.logerr(   'Joint torque example failed to meet ...
% %                                     specified control rate timeout.')
% %                     break;
% %                 end
%                 
% %                 obj.update_forces();
% %                 control_rate.sleep();
%             end
        end

        % Switches out of joint torque mode to exit cleanly
        function clean_shutdown( obj )
            disp('\nExiting example...');
            obj.limb.exit_control_mode();       
        end
    end    
end


      
    