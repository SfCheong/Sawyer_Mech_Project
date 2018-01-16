 function on_endpoint_states(obj, src, msg)
%             % Comments in this private method are for documentation purposes.
%             % _pose = {'position': (x, y, z), 'orientation': (x, y, z, w)}
%             obj.cartesian_pose = { 'position':        obj.Point(	msg.pose.position.x,
%                                                                   msg.pose.position.y,
%                                                                   msg.pose.position.z,    ),
%                                     'orientation':    obj.Quaternion(	msg.pose.orientation.x,
%                                                                       msg.pose.orientation.y,
%                                                                       msg.pose.orientation.z,
%                                                                    	msg.pose.orientation.w, ), }
            obj.cartesian_pose.position.x = msg.Pose.Position.X;
            obj.cartesian_pose.position.y = msg.Pose.Position.Y;
            obj.cartesian_pose.position.z = msg.Pose.Position.Z;
            
            obj.cartesian_pose.orientation.x = msg.Pose.Orientation.X;
            obj.cartesian_pose.orientation.y = msg.Pose.Orientation.Y;
            obj.cartesian_pose.orientation.z = msg.Pose.Orientation.Z;
            obj.cartesian_pose.orientation.w = msg.Pose.Orientation.W;


%             % _twist = {'linear': (x, y, z), 'angular': (x, y, z)}
%             obj.cartesian_velocity = { 'linear': obj.Point( msg.twist.linear.x,
%                                                             msg.twist.linear.y,
%                                                             msg.twist.linear.z, ),
%                                         'angular': obj.Point(   msg.twist.angular.x,
%                                                                 msg.twist.angular.y,
%                                                                 msg.twist.angular.z,    ),  }

            obj.cartesian_velocity.linear.x = msg.Twist.Linear.X;
            obj.cartesian_velocity.linear.y = msg.Twist.Linear.Y;
            obj.cartesian_velocity.linear.z = msg.Twist.Linear.Z;
            
            obj.cartesian_velocity.linear.x = msg.Twist.Angular.X;
            obj.cartesian_velocity.linear.y = msg.Twist.Angular.Y;
            obj.cartesian_velocity.linear.z = msg.Twist.Angular.Z;


%             % _wrench = {'force': (x, y, z), 'torque': (x, y, z)}
%             obj.cartesian_effort = { 'force': obj.Point(	msg.wrench.force.x,
%                                                             msg.wrench.force.y,
%                                                             msg.wrench.force.z, ),
%                                                         'torque': obj.Point(    msg.wrench.torque.x,
%                                                                                 msg.wrench.torque.y,
%                                                                                 msg.wrench.torque.z, ), }

            obj.cartesian_effort.force.x = msg.Wrench.Force.X;
            obj.cartesian_effort.force.y = msg.Wrench.Force.Y;
            obj.cartesian_effort.force.z = msg.Wrench.Force.Z;
            
            obj.cartesian_effort.torque.x = msg.Wrench.Torque.X;
            obj.cartesian_effort.torque.y = msg.Wrench.Torque.Y;
            obj.cartesian_effort.torque.z = msg.Wrench.Torque.Z;
end
